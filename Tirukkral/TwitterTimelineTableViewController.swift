//
//  TwitterTimelineTableViewController.swift
//  Tirukkral
//
//  Created by Mohankumar on 16/11/17.
//  Copyright © 2017 Mohan. All rights reserved.
//

import UIKit
import TwitterKit



class TwitterTimelineTableViewController: TWTRTimelineViewController,UITextFieldDelegate {
    @IBOutlet weak var seachText: UITextField!
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            searchTwitter(tag: self.seachText.text!)
            textField.resignFirstResponder()
            return false
        }
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let image = UIImage.init(named: "background")?.cgImage
//        self.navigationController?.view.backgroundColor = UIColor.init(patternImage: image!)
        self.navigationController?.view.layer.contents = image
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.seachText.text = "#tirukkural"
        searchTwitter(tag :"#tirukkural")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    

    func searchTwitter(tag : String){
        TWTRTwitter.sharedInstance().sessionStore.fetchGuestSession { (guestSession, error) in
            if (guestSession != nil) {
                // make API calls that do not require user auth
                let client = TWTRAPIClient()
                self.dataSource = TWTRSearchTimelineDataSource(searchQuery: tag, apiClient: client)
            } else {
                print("error: \(String(describing: error))");
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? TWTRTweetTableViewCell {
            cell.backgroundColor = .clear
            cell.tweetView.backgroundColor = .clear
            cell.tweetView.linkTextColor = .black
            cell.tweetView.primaryTextColor = .black
        }
    }

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
