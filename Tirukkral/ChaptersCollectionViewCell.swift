//
//  ChaptersCollectionViewCell.swift
//  Tirukkral
//
//  Created by Mohankumar on 15/11/17.
//  Copyright © 2017 Mohan. All rights reserved.
//

import UIKit
protocol ChapterSelectionCollectionViewDelegate {
    func chapterSelectedAtIndex(index : Int)
}

class ChaptersCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var chapterButton: UIButton!
    var index = 0
    var delegate : ChapterSelectionCollectionViewDelegate?
    
    @IBAction func chatperSelected(_ sender: Any) {
        let button = sender as! UIButton
        button.isSelected = true
        delegate?.chapterSelectedAtIndex(index: self.index)
    }
}
