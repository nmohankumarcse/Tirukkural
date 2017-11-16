//
//  AuthorHeaderTableViewCell.swift
//  Tirukkral
//
//  Created by Mohankumar on 15/11/17.
//  Copyright © 2017 Mohan. All rights reserved.
//

import UIKit

class AuthorHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var authorImage: UIImageView!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var headerCaption: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpUI(){
        self.authorImage.layer.cornerRadius = self.authorImage.frame.width/2
        self.authorImage.layer.masksToBounds = true
    }

}
