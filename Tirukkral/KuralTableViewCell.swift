//
//  KuralTableViewCell.swift
//  Tirukkral
//
//  Created by Muthu on 18/04/17.
//  Copyright © 2017 Mohan. All rights reserved.
//

import UIKit
import CoreData


class KuralTableViewCell: UITableViewCell {

    @IBOutlet weak var favouritesButton: UIButton!
    @IBOutlet weak var kuralNo: UILabel!
    @IBOutlet weak var line1: UILabel!
    @IBOutlet weak var line2: UILabel!
    var kural : Kural?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func loadData(){
        if let kuralD  = self.kural{
            if let description = kuralD.kural {
            let kuralDescription : [String] = (description.components(separatedBy: ","))
            self.kuralNo.text = "\(kural!.kuralNo)"
            self.line1.text = kuralDescription[0]
            self.line2.text = kuralDescription[1]
            favouritesButton.isSelected = false
            if let isFav = self.kural?.isFavourite{
                if isFav{
                    favouritesButton.isSelected = true
                }
            }
            }
        }
        self.selectionStyle = .none
    }
    
    override func layoutSubviews() {
        self.line2.font = self.line1.font
    }

    @IBAction func markAsFavourite(_ sender: UIButton) {
        if sender.isSelected{
            self.kural?.isFavourite = false
        }
        else{
            self.kural?.isFavourite = true
        }
        sender.isSelected = !sender.isSelected
        let cdm = CoreDataHelper.shared()
        cdm.updateKural(kural: kural!)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
