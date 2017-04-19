//
//  KuralDetailViewController.swift
//  Tirukkral
//
//  Created by Muthu on 18/04/17.
//  Copyright © 2017 Mohan. All rights reserved.
//

import UIKit

class KuralDetailViewController: UIViewController {
    var kural : Kural?
    @IBOutlet weak var kuralNo: UILabel!
    @IBOutlet weak var line1: UILabel!
    @IBOutlet weak var line2: UILabel!
    @IBOutlet weak var meaningMuVa: UILabel!
    @IBOutlet weak var meaningSaPa: UILabel!
    @IBOutlet weak var meaningEng: UILabel!
    @IBOutlet weak var chapterName: UILabel!
    @IBOutlet weak var sectionName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let kuralNoText : String! = "\(kural!.kuralNo)"
        kuralNo.text = kuralNoText
        let kuralDescription : [String] = (kural!.kural?.components(separatedBy: ","))!
        line1.text = kuralDescription[0]
        line2.text = kuralDescription[1]
        meaningMuVa.text = kural?.kuralMeaningMuVa
        meaningSaPa.text = kural?.kuralMeaningSaPa
        meaningEng.text = kural?.kuralMeaningEng
        chapterName.text = kural?.hasChapter?.chapterName
        sectionName.text = kural?.hasChapter?.hasSection?.sectionName
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
