//
//  RedditFeedVC.swift
//  RedditAPI
//
//  Created by Reiss Zurbyk on 2017-03-10.
//  Copyright © 2017 Reiss Zurbyk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

//struct RedditFeed {
//
//  let author: String
//  let creationDate: String
//  let image: String
//  let title: String
//}
//
//extension RedditFeed {
//  init?(json: [String: Any]) {
//    guard let author = json["author"] as? String,
//      let creationDate = json["created"] as? String,
//      let image = json["thumbnail"] as? String,
//      let title = json["title"] as? String
//      else {
//        return nil
//    }
//
//    self.author = author
//    self.creationDate = creationDate
//    self.image = image
//    self.title = title
//  }
//}

class RedditFeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  // Array for our JSON
  var listData: [[String: AnyObject]] = [[String: AnyObject]]()
  
  // Outlets
  @IBOutlet weak var tableView: UITableView!
  
  // Arrays for our objects
  var authors = [String]()
  var creationDates = [String]()
  var images = [String]()
  var titles = [String]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.tableView.delegate = self
    self.tableView.dataSource = self
    
    // Create url object for our request
    let url:URL = URL(string: "https://www.reddit.com/r/space/.json")!
    
    // Alamofire request
    Alamofire.request(url).responseJSON(completionHandler: { response in
      
      // Handle the API response
      let result = response.result
      switch response.result {
      case .success:
        self.listData = [response.result.value as! Dictionary<String,AnyObject>]
        
        // Create JSON object
        let json = JSON(self.listData)
        
        if let JSON = response.result.value {
          print("JSON: \(JSON)")
        }
        
        // Error handling
      case .failure(let error):
        print(error)
      }
      
      // Parse JSON and create child objects
      guard let json = response.result.value as? [String: AnyObject],
        let data = json["data"] as? [String: AnyObject],
        
        // Children nested inside Data
        let children = data["children"] as?  [AnyObject] else {
          return
      }
      for child in children{
        if let childData = child["data"] as? [String:AnyObject] {
          if let author = childData["author"] as? String {
            
            // Append JSN objects to our arrays
            self.authors.append(author)
            self.titles.append(childData["title"] as! String)
            self.creationDates.append("\(NSDate(timeIntervalSince1970: childData["created"] as! TimeInterval))")
            self.images.append(childData["thumbnail"] as! String)
            
            // Print to console
            print("AUTHOR: \(author)")
            print("TITLE: \(childData["title"] as! String)")
            
            // Convert time
            print("DATE: \(NSDate(timeIntervalSince1970: childData["created"] as! TimeInterval))")
            print("Thumbnail \(childData["thumbnail"] as! String)")
          }
        }
      }
      
      // Reload tableView
      self.tableView.reloadData()
      
    }).resume()
  }
  
  // tableView delegate methods
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    // Returns number of authors
    return self.authors.count
    
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let redditCell = tableView.dequeueReusableCell(
      withIdentifier: "postCell",
      for: indexPath) as? RedditPostCell
    
    
    // Handle objects and UI in cell
    let author = self.authors[indexPath.row]
    redditCell?.authorLabel?.text = author
    redditCell?.creationDateLabel?.text = self.creationDates[indexPath.row]
    redditCell?.titleText?.text = self.titles[indexPath.row]
    if let url = NSURL(string: self.images[indexPath.row]) {
      if let data = NSData(contentsOf: url as URL) {
        redditCell?.redditPostImage?.image = UIImage(data: data as Data)
        redditCell?.redditPostImage.layer.cornerRadius = 4.0
        redditCell?.redditPostImage.clipsToBounds = true
      }
    }
    
    return redditCell!
  }
}
