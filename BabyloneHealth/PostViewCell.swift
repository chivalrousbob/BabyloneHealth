//
//  PostViewCell.swift
//  BabyloneHealth
//
//  Created by mac on 16/01/17.
//  Copyright © 2017 Ayoub NOURI. All rights reserved.
//

import UIKit

class PostViewCell: UITableViewCell {
    
    @IBOutlet weak var postTitle: UILabel!
    
    var post: Post? {
        didSet{
            postTitle.text = post?.title
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
