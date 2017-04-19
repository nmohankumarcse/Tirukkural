//
//  ViewController.swift
//  Tirukkral
//
//  Created by Muthu on 11/04/17.
//  Copyright © 2017 Mohan. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var sections:[Section] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        sections = CoreDataHelper().getAllSections()
        print("Sections : \(sections)")
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (sections.count)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section : Section = sections[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "sectionCell", for: indexPath)
        cell.textLabel?.text = section.sectionName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chaptersVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "chapters") as! ChaptersTableViewController
        let section : Section = sections[indexPath.row]
        chaptersVC.section = section
        self.navigationController?.pushViewController(chaptersVC, animated: true)
    }
}

