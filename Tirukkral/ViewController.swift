//
//  ViewController.swift
//  Tirukkral
//
//  Created by Muthu on 11/04/17.
//  Copyright © 2017 Mohan. All rights reserved.
//

import UIKit
import SVProgressHUD

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var kural : Kural?
    var sections:[Section] = []
    @IBOutlet weak var tirukkuralTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        sections = CoreDataHelper().getAllSections()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if sections.count > 2{
            return 2
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return 1
        }
        else{
            return (sections.count)
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            kural = CoreDataHelper().getRandomKuralForTheDay()
            let cell : KuralTableViewCell = tableView.dequeueReusableCell(withIdentifier: "kuralCell", for: indexPath) as! KuralTableViewCell
            cell.kural = self.kural
            cell.loadData()
            return cell
        }
        else{
            let section : Section = sections[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "sectionCell", for: indexPath)
            cell.textLabel?.text = section.sectionName
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 0){
            return 90
        }
        else{
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        if(section == 0){
            return "இன்றைய திருக்குறள்"
        }
        else{
            return "பால்கள்"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            let kuralsDVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "kuralDetailTable") as! KuralDetailTableViewController
            
            kuralsDVC.kural = kural
            self.navigationController?.pushViewController(kuralsDVC, animated: true)
        }
        else{
        let chaptersVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "chapters") as! ChaptersTableViewController
        let section : Section = sections[indexPath.row]
        chaptersVC.section = section
        self.navigationController?.pushViewController(chaptersVC, animated: true)
        }
    }
}

