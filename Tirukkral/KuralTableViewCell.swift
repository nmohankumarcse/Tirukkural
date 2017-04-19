//
//  KuralTableViewCell.swift
//  Tirukkral
//
//  Created by Muthu on 18/04/17.
//  Copyright © 2017 Mohan. All rights reserved.
//

import UIKit

class KuralTableViewCell: UITableViewCell {

    @IBOutlet weak var kuralNo: UILabel!
    @IBOutlet weak var line1: UILabel!
    @IBOutlet weak var line2: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
