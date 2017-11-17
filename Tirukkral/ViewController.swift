//
//  ViewController.swift
//  Tirukkral
//
//  Created by Muthu on 11/04/17.
//  Copyright © 2017 Mohan. All rights reserved.
//

import UIKit
import SVProgressHUD

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,ChapterSelectionDelegate,ChapterSelectionCollectionViewDelegate,UICollectionViewDelegateFlowLayout
{
    
    
    var kural : Kural?
    var sections:[Section] = []
    var chapters:[Chapter] = []
    var selectedChapter : Chapter?
    var kurals : [Kural] = []
    @IBOutlet weak var chatpterTitleButton: UIBarButtonItem!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var tirukkuralTableView: UITableView!
    @IBOutlet weak var chaptersCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tirukkuralTableView.register(UINib.init(nibName: "KuralTableViewCell", bundle: nil), forCellReuseIdentifier: "KuralTableViewCell")
        sections = CoreDataHelper.shared().getAllSections()
        if sections.count > 0{
            chapters = CoreDataHelper.shared().getAllChaptersForSection(section: sections[0])
            self.chatperSelected(chatper: chapters[0])
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func chapterSelectedAtIndex(index: Int) {
        self.selectedChapter = self.chapters[index]
        self.chatperSelected(chatper: self.selectedChapter!)
    }
    
    func setCollectionViewSelection(index : Int){
        self.chaptersCollectionView.scrollToItem(at: IndexPath.init(row: index, section: 0), at: .centeredHorizontally, animated: true)
        self.chaptersCollectionView.reloadData()
    }
    
    func chatperSelected(chatper: Chapter) {
        self.selectedChapter = chatper
        kurals = CoreDataHelper.shared().getAllKuralsForChapter(chapter: self.selectedChapter!)
        self.tirukkuralTableView.reloadData()
        for (index,element) in self.chapters.enumerated(){
            if element.chapterName == self.selectedChapter?.chapterName{
                self.setCollectionViewSelection(index: index)
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == tirukkuralTableView{
//            self.chatperSelected(chatper: self.selectedChapter!)
        }
    }
    @IBAction func selectChatper(_ sender: Any) {
        chapters = CoreDataHelper.shared().getAllChaptersForSection(section: sections[segmentControl.selectedSegmentIndex])
        self.chatperSelected(chatper: chapters[0])
    }
    
    @IBAction func searchChapter(_ sender: Any) {
        let searchChapter = self.storyboard?.instantiateViewController(withIdentifier: "SearchChapter") as! SearchChapterViewController
        searchChapter.delegate = self
        searchChapter.section = self.sections[segmentControl.selectedSegmentIndex]
        if let chapter = self.selectedChapter {
            searchChapter.selectedChapter = chapter
        }
        self.present(searchChapter, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if sections.count > 2{
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return kurals.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chapters.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let chapter = self.chapters[indexPath.item]
        let size: CGSize = chapter.chapterName!.size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 18.0)])
        return CGSize(width: size.width + 35, height: self.chaptersCollectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : ChaptersCollectionViewCell = self.chaptersCollectionView.dequeueReusableCell(withReuseIdentifier: "ChaptersCollectionViewCell", for: indexPath) as! ChaptersCollectionViewCell
        cell.delegate = self
        cell.index  = indexPath.item
        let chapter = self.chapters[indexPath.item]
        cell.chapterButton.setTitle(chapter.chapterName, for: .normal)
        cell.bottomBar.backgroundColor = UIColor.darkGray
        cell.chapterButton.isSelected = false
        cell.bottomBar.backgroundColor = UIColor.init(red: 200/255.0, green: 120/255.0, blue: 70/255.0, alpha: 1)
        if chapter.chapterName == self.selectedChapter?.chapterName{
            cell.chapterButton.isSelected = true
            cell.bottomBar.backgroundColor = UIColor.black
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let kural : Kural = kurals[indexPath.row]
        let cell : KuralTableViewCell = tableView.dequeueReusableCell(withIdentifier: "KuralTableViewCell", for: indexPath) as! KuralTableViewCell
        cell.kural = kural
        cell.loadData()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        }
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            let kuralsDVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "kuralDetailTable") as! KuralDetailTableViewController
            self.kural = self.kurals[indexPath.row]
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

