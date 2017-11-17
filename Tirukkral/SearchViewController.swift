//
//  SearchViewController.swift
//  Tirukkral
//
//  Created by Muthu on 19/04/17.
//  Copyright © 2017 Mohan. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchControllerDelegate,UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    var kurals : [Kural] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchTableView.register(UINib.init(nibName: "KuralTableViewCell", bundle: nil), forCellReuseIdentifier: "KuralTableViewCell")
        self.searchBar.showsCancelButton = true
        self.searchBar.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion:nil);
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        kurals = CoreDataHelper.shared().getKuralForKeyword(keyword: searchText)
        self.searchTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        kurals = CoreDataHelper.shared().getKuralForKeyword(keyword: searchBar.text!)
        self.view.endEditing(true)
        self.searchTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kurals.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let kural : Kural = kurals[indexPath.row]
        let cell : KuralTableViewCell = tableView.dequeueReusableCell(withIdentifier: "KuralTableViewCell", for: indexPath) as! KuralTableViewCell
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
        self.navigationController?.pushViewController(kuralsDVC, animated: true)
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
