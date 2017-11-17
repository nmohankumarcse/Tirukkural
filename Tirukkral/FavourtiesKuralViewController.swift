//
//  FavourtiesKuralViewController.swift
//  Tirukkral
//
//  Created by Mohankumar on 14/11/17.
//  Copyright © 2017 Mohan. All rights reserved.
//

import UIKit

class FavourtiesKuralViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var chapter : Chapter?
    var kurals : [Kural] = []
    @IBOutlet weak var favourtiesTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.favourtiesTableView.register(UINib.init(nibName: "KuralTableViewCell", bundle: nil), forCellReuseIdentifier: "KuralTableViewCell")
        self.navigationItem.title = "பிடித்தது"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        kurals = CoreDataHelper.shared().getAllFavouriteKurals()
        favourtiesTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return kurals.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let kural : Kural = kurals[indexPath.row]
        let cell : KuralTableViewCell = favourtiesTableView.dequeueReusableCell(withIdentifier: "KuralTableViewCell", for: indexPath) as! KuralTableViewCell
        cell.kural = kural
        cell.loadData()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let kuralsDVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "kuralDetailTable") as! KuralDetailTableViewController
        let kural : Kural = kurals[indexPath.row]
        kuralsDVC.kural = kural
        kuralsDVC.isRandom = true
        self.navigationController?.pushViewController(kuralsDVC, animated: true)
    }
    
    /*
     // Override to support conditional editing of the table view.
     func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
     func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
