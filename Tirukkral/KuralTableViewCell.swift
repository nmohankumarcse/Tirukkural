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
    @IBOutlet weak var favouriteBg: UIImageView!
    @IBOutlet weak var kuralNo: UILabel!
    @IBOutlet weak var line1: UILabel!
    @IBOutlet weak var line2: UILabel!
    @IBOutlet weak var kuralNoBg: UIView!
    var kural : Kural?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func loadData(){
        let kuralDescription : [String] = (kural!.kural?.components(separatedBy: ","))!
        self.kuralNo.text = "\(kural!.kuralNo)"
        self.line1.text = kuralDescription[0]
        self.line2.text = kuralDescription[1]
        favouriteBg.image = UIImage.init(named: "Favourites")
        favouritesButton.isSelected = false
        if let isFav = self.kural?.isFavourite{
            if isFav{
                favouriteBg.image = UIImage.init(named: "Favourites_Selected")
                favouritesButton.isSelected = true
            }
        }
        self.selectionStyle = .none
    }

    @IBAction func markAsFavourite(_ sender: UIButton) {
        if sender.isSelected{
            favouriteBg.image = UIImage.init(named: "Favourites")
            self.kural?.isFavourite = false
        }
        else{
            favouriteBg.image = UIImage.init(named: "Favourites_Selected")
            self.kural?.isFavourite = true
        }
        sender.isSelected = !sender.isSelected
        let cdm = CoreDataHelper()
        cdm.updateKural(kural: kural!)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
