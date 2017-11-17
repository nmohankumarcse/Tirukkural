//
//  KuralDetailTableViewController.swift
//  Tirukkral
//
//  Created by Muthu on 18/04/17.
//  Copyright © 2017 Mohan. All rights reserved.
//

import UIKit
import SVProgressHUD
import TwitterKit

class KuralDetailTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,DBInsertion {
    var kural : Kural?
    @IBOutlet weak var tableView: UITableView!
    var isRandom : Bool = false
    var sectionExpandArray = [true,false,false,false,false,false]
    var total = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib.init(nibName: "KuralTableViewCell", bundle: nil), forCellReuseIdentifier: "KuralTableViewCell")
        if !isRandom{
            self.navigationItem.title =  "விளக்கம்"
        }
        if kural != nil{
            animateTableView()
        }
        self.tableView.estimatedRowHeight = 80;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    @IBAction func composeTweet(_ sender: Any) {
        if (Twitter.sharedInstance().sessionStore.hasLoggedInUsers()) {
            // App must have at least one logged-in user to compose a Tweet
            self.showTweetCompose()
        } else {
            // Log in, and then check again
            Twitter.sharedInstance().logIn { session, error in
                if session != nil { // Log in succeeded
                    self.showTweetCompose()
                } else {
                    let alert = UIAlertController(title: "No Twitter Accounts Available", message: "You must log in before presenting a composer.", preferredStyle: .alert)
                    self.present(alert, animated: false, completion: nil)
                }
            }
        }
    }
    
    func showTweetCompose(){
        let kuralDescription : [String] = (self.kural!.kural!.components(separatedBy: ","))
        let chapterName : String = (kural?.hasChapter?.chapterName)!
        let composer = TWTRComposerViewController(initialText: "\(kuralDescription[0]) \n \(kuralDescription[1]) #\(chapterName) #tirukkural #திருக்குறள்", image: UIImage.init(named: "thiruvalluvar"), videoURL: nil)
        composer.becomeFirstResponder()
        self.present(composer, animated: true, completion: {
        })
    }
    
    
    func animateTableView(){
        self.tableView.reloadData()
        for (index,_) in self.sectionExpandArray.enumerated(){
            DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
                self.tableView.beginUpdates()
                self.sectionExpandArray[index] = true
                self.tableView.reloadSections(IndexSet.init(integer: index), with: .automatic)
                self.tableView.endUpdates()
            })
        }
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
                            self.total = kurals.count
                            let cdh = CoreDataHelper.shared()
                            cdh.delegete = self
                            for (_, section) in sections.enumerated() {
                                cdh.insertSection(sectionName: section as! String)
                            }
                            
                            for (index, kural) in kurals.enumerated() {
                                cdh.insertKural(kural: kural as! NSDictionary, index: index)
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

    func kuralInserted(index: Int) {
        DispatchQueue.main.async{
            if index == self.total-1{
                SVProgressHUD.dismiss()
            }
            else{
                print("index : \(index)")
                print("progress :\(Float(index)/Float(self.total))")
                SVProgressHUD.showProgress(Float(index)/Float(self.total), status: "Loading \(index)"+"/"+"\(self.total)")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if self.kural != nil{
            return 6
        }
        return 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
       let isExpanded =  self.sectionExpandArray[section]
        if isExpanded == true{
                return 1
        }
        return 0
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for cell in tableView.visibleCells {
            let hiddenFrameHeight = scrollView.contentOffset.y + navigationController!.navigationBar.frame.size.height - cell.frame.origin.y
            if cell.frame.origin.y > 0{
                if (hiddenFrameHeight >= 0 || hiddenFrameHeight <= cell.frame.size.height) {
                    maskCell(cell: cell, margin: Float(hiddenFrameHeight))
                }
            }
        }
    }
    
    func maskCell(cell: UITableViewCell, margin: Float) {
        cell.layer.mask = visibilityMaskForCell(cell: cell, location: (margin / Float(cell.frame.size.height) ))
        cell.layer.masksToBounds = true
    }
    
    func visibilityMaskForCell(cell: UITableViewCell, location: Float) -> CAGradientLayer {
        let mask = CAGradientLayer()
        mask.frame = cell.bounds
        mask.colors = [UIColor(white: 1, alpha: 0).cgColor, UIColor(white: 1, alpha: 1).cgColor]
        mask.locations = [NSNumber(value: location), NSNumber(value: location)]
        return mask;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 0){
            return 90;
        }
        else if(indexPath.section == 1){
            return 44
        }
        else if(indexPath.section == 2){
            return 44
        }
        else{
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
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell : AuthorHeaderTableViewCell = tableView.dequeueReusableCell(withIdentifier: "sectionNameCell") as! AuthorHeaderTableViewCell
        cell.headerCaption.isHidden = true
        if(section == 0){
            cell.authorName.text = ""
        }
        else if(section == 1){
            cell.authorName.text = "அதிகாரம்"
        }
        else if(section == 2){
            cell.authorName.text = "பால்"
        }
        else{
            if(section == 3){
                cell.headerCaption.isHidden = false
                cell.authorName.text = "Meaning"
            }
            else if(section == 4){
                cell.authorName.text = "மு.வ "
                cell.authorImage.image = UIImage.init(named: "muva")
            }
            else if(section == 5){
                cell.authorName.text = "சாலமன் பாப்பையா "
                cell.authorImage.image = UIImage.init(named: "sapa")
            }
        }
        cell.setUpUI()
        return cell.contentView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0){
            let cell : KuralTableViewCell = tableView.dequeueReusableCell(withIdentifier: "KuralTableViewCell", for: indexPath) as! KuralTableViewCell
            cell.kural = self.kural
            cell.selectionStyle = .none
            cell.loadData()
            return cell
        }
        else{
            var textToBeDisplayed : String?
            if(indexPath.section == 1){
                if let hasChapter = kural?.hasChapter{
                textToBeDisplayed = hasChapter.chapterName
                }
            }
            else if(indexPath.section == 2){
                if let hasSection = kural?.hasChapter?.hasSection{
                    textToBeDisplayed = hasSection.sectionName
                }
            }
            else if(indexPath.section == 3){
                textToBeDisplayed = (kural?.kuralMeaningEng)!
            }
            else if(indexPath.section == 4){
                textToBeDisplayed = (kural?.kuralMeaningMuVa)!
            }
            else if(indexPath.section == 5){
                textToBeDisplayed = (kural?.kuralMeaningSaPa)!
            }
            let cell : KuralDescriptionTableViewCell  = tableView.dequeueReusableCell(withIdentifier: "kuralDescriptionCell", for: indexPath) as! KuralDescriptionTableViewCell
            cell.descriptionLabel?.numberOfLines = 0
            cell.descriptionLabel?.text = textToBeDisplayed
            cell.selectionStyle = .none
            return cell;
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isRandom{
            if(indexPath.section == 1){
                let kuralsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "kurals") as! KuralsTableViewController
                let chapter : Chapter = (kural?.hasChapter)!
                kuralsVC.chapter = chapter
                self.navigationController?.pushViewController(kuralsVC, animated: true)
            }
            else if(indexPath.section == 2){
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
