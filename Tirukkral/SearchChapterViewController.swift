//
//  SearchChapterViewController.swift
//  Tirukkral
//
//  Created by Mohankumar on 15/11/17.
//  Copyright © 2017 Mohan. All rights reserved.
//

import UIKit

protocol ChapterSelectionDelegate {
    func chatperSelected(chatper : Chapter)
}

class SearchChapterViewController:UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchControllerDelegate,UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    var section : Section?
    var selectedChapter : Chapter?
    var chapters : [Chapter] = []
    var delegate : ChapterSelectionDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        chapters = CoreDataHelper.shared().getAllChaptersForSection(section: section!)
        self.searchBar.showsCancelButton = true
        self.searchBar.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion:nil);
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        kurals = CoreDataHelper.shared().getKuralForKeyword(keyword: searchText)
//        self.searchTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
//        kurals = CoreDataHelper.shared().getKuralForKeyword(keyword: searchBar.text!)
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
        // #warning Incomplete implementation, return the number of rows
        return chapters.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chapter : Chapter = chapters[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "chapterCell", for: indexPath)
        cell.textLabel?.text = chapter.chapterName
        cell.selectionStyle = .none
        cell.accessoryType = .none
        if self.selectedChapter?.chapterName == chapter.chapterName{
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chapter : Chapter = chapters[indexPath.row]
        delegate?.chatperSelected(chatper: chapter)
        self.dismiss(animated: true, completion: nil)
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

