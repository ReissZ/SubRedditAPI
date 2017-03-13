//
//  RedditPostCell.swift
//  RedditAPI
//
//  Created by Reiss Zurbyk on 2017-03-10.
//  Copyright © 2017 Reiss Zurbyk. All rights reserved.
//

import UIKit

class RedditPostCell: UITableViewCell {
  
  @IBOutlet weak var redditPostImage: UIImageView!
  @IBOutlet weak var titleText: UITextView!
  @IBOutlet weak var authorLabel: UILabel!
  @IBOutlet weak var creationDateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
