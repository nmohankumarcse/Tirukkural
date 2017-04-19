//
//  KuralDetailTableViewController.swift
//  Tirukkral
//
//  Created by Muthu on 18/04/17.
//  Copyright © 2017 Mohan. All rights reserved.
//

import UIKit

class KuralDetailTableViewController: UITableViewController {
    var kural : Kural?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 80;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 6
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    // width of string as a particular font in one line
    func getStringSizeForFont(font: UIFont, myText: String) -> CGSize {
        let fontAttributes = [NSFontAttributeName: font]
        let size = (myText as NSString).size(attributes: fontAttributes)
        
        return size
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 0){
            return 90;
        }
        else if(indexPath.section == 4){
            return 44
        }
        else if(indexPath.section == 5){
            return 44
        }
        else{
        // get the string size
            var textToBeDisplayed : String?
            if(indexPath.section == 1){
                textToBeDisplayed = (kural?.kuralMeaningMuVa)!
            }
            else if(indexPath.section == 2){
                textToBeDisplayed = (kural?.kuralMeaningSaPa)!
            }
            else if(indexPath.section == 3){
                textToBeDisplayed = (kural?.kuralMeaningEng)!
            }
        let stringSizeAsText: CGSize = getStringSizeForFont(font: UIFont(name: "Avenir", size: 16.0)!, myText: textToBeDisplayed!)
        
        let labelWidth: CGFloat = 259.0
        let originalLabelHeight: CGFloat = 20.5
        
        // the label can only hold its width worth of text, so we can get the ammount of lines from a specific string this way
        let labelLines: CGFloat = CGFloat(ceil(Float(stringSizeAsText.width/labelWidth)))
        
        // each line will approximately take up the original label's height
        let height =  tableView.rowHeight - originalLabelHeight + CGFloat(labelLines*stringSizeAsText.height)
        
        return height
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 0){
            return 0
        }
        else{
            return 40
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            return 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        if(section == 0){
            return ""
        }
        else if(section == 4){
            return "அதிகாரம்"
        }
        else if(section == 5){
            return "பால்"
        }
        else{
            var textToBeDisplayed : String?
            if(section == 1){
                textToBeDisplayed = "மு.வ "
            }
            else if(section == 2){
                textToBeDisplayed = "சாலமன் பாப்பையா "
            }
            else if(section == 3){
                textToBeDisplayed = "English"
            }
            return textToBeDisplayed
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0){
            let cell : KuralTableViewCell = tableView.dequeueReusableCell(withIdentifier: "kuralCell", for: indexPath) as! KuralTableViewCell
            let kuralDescription : [String] = (kural!.kural?.components(separatedBy: ","))!
            cell.kuralNo.text = "\(kural!.kuralNo)"
            cell.line1.text = kuralDescription[0]
            cell.line2.text = kuralDescription[1]
            return cell
        }
        else if(indexPath.section == 4){
            let cell  = tableView.dequeueReusableCell(withIdentifier: "sectionNameCell", for: indexPath)
            cell.textLabel?.text = kural?.hasChapter?.chapterName
            return cell
        }
        else if(indexPath.section == 5){
            let cell  = tableView.dequeueReusableCell(withIdentifier: "sectionNameCell", for: indexPath)
            cell.textLabel?.text = kural?.hasChapter?.hasSection?.sectionName
            return cell
        }
        else{
            var textToBeDisplayed : String?
            if(indexPath.section == 1){
                textToBeDisplayed = (kural?.kuralMeaningMuVa)!
            }
            else if(indexPath.section == 2){
                textToBeDisplayed = (kural?.kuralMeaningSaPa)!
            }
            else if(indexPath.section == 3){
                textToBeDisplayed = (kural?.kuralMeaningEng)!
            }
            let cell  = tableView.dequeueReusableCell(withIdentifier: "kuralDescriptionCell", for: indexPath)
//            var frame :  CGRect = (cell.textLabel?.frame)!
//            let size :CGSize  = getStringSizeForFont(font: (cell.textLabel?.font)!, myText: textToBeDisplayed!)
//            frame.size = size
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = textToBeDisplayed
            return cell;
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
