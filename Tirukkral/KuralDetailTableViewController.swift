//
//  KuralDetailTableViewController.swift
//  Tirukkral
//
//  Created by Muthu on 18/04/17.
//  Copyright © 2017 Mohan. All rights reserved.
//

import UIKit
import SVProgressHUD

class KuralDetailTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var kural : Kural?
    @IBOutlet weak var tableView: UITableView!
    var isRandom : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        if kural == nil{
            isRandom = true
            let sections = CoreDataHelper().getAllSections()
            if sections.count < 3{
                SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
                SVProgressHUD.showProgress(0, status: "Loading...")
                self.completeParsing() {isCompleted in
                    // your completion block code here.
                    if isCompleted{
                        SVProgressHUD.dismiss(completion: nil)
                        self.kural =  CoreDataHelper().getRandomKuralForTheDay()
                        self.tableView.reloadData()
                    }
                }
            }
            else{
                self.kural =  CoreDataHelper().getRandomKuralForTheDay()
                self.tableView.reloadData()
            }
        }
        else{
            self.navigationItem.title =  "விளக்கம்"
        }
        self.tableView.estimatedRowHeight = 80;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func completeParsing(completion: @escaping (Bool) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            print("url : \(urls[urls.count-1])")
            if let path = Bundle.main.url(forResource: "tirukkural", withExtension: "json") {
                
                do {
                    let jsonData = try Data(contentsOf: path, options: .mappedIfSafe)
                    do {
                        if let jsonResult = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? NSDictionary {
                            let sections : NSArray = jsonResult.object(forKey: "sections") as! NSArray
                            //                        let chapters : NSArray = jsonResult.object(forKey: "chapters") as! NSArray
                            let kurals : NSArray = jsonResult.object(forKey: "kurals") as! NSArray
                            
                            for (_, section) in sections.enumerated() {
                                CoreDataHelper().insertSection(sectionName: section as! String)
                            }
                            
                            for (index, kural) in kurals.enumerated() {
                                print("index : \(index)")
                                CoreDataHelper().insertKural(kural: kural as! NSDictionary)
                                print("progress :\(Float(index)/Float(kurals.count))")
                                
                                SVProgressHUD.showProgress(Float(index)/Float(kurals.count), status: "Loading \(index)"+"/"+"\(kurals.count)")
                                if index == kurals.count-1{
                                    completion(true)
                                }
                            }
                        }
                    } catch let error as NSError {
                        print("Error: \(error)")
                    }
                } catch let error as NSError {
                    print("Error: \(error)")
                }
            }
        })

        // Call YOUR completion here...
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if kural == nil{
            return 0
        }
        return 6
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 0){
            return 0
        }
        else{
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0){
            let cell : KuralTableViewCell = tableView.dequeueReusableCell(withIdentifier: "kuralCell", for: indexPath) as! KuralTableViewCell
            cell.kural = self.kural
            cell.selectionStyle = .none
            cell.loadData()
            return cell
        }
        else if(indexPath.section == 4){
            let cell  = tableView.dequeueReusableCell(withIdentifier: "sectionNameCell", for: indexPath)
            cell.textLabel?.text = kural?.hasChapter?.chapterName
            cell.selectionStyle = .none
            return cell
        }
        else if(indexPath.section == 5){
            let cell  = tableView.dequeueReusableCell(withIdentifier: "sectionNameCell", for: indexPath)
            cell.textLabel?.text = kural?.hasChapter?.hasSection?.sectionName
            cell.selectionStyle = .none
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
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = textToBeDisplayed
            cell.selectionStyle = .none
            return cell;
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isRandom{
            if(indexPath.section == 4){
                let kuralsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "kurals") as! KuralsTableViewController
                let chapter : Chapter = (kural?.hasChapter)!
                kuralsVC.chapter = chapter
                self.navigationController?.pushViewController(kuralsVC, animated: true)
            }
            else if(indexPath.section == 5){
                let chaptersVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "chapters") as! ChaptersTableViewController
                let section : Section = (kural?.hasChapter?.hasSection)!
                chaptersVC.section = section
                self.navigationController?.pushViewController(chaptersVC, animated: true)
            }
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
