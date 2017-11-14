//
//  CoreDataHelper.swift
//  Tirukkral
//
//  Created by Muthu on 17/04/17.
//  Copyright © 2017 Mohan. All rights reserved.
//

import UIKit
import CoreData

class CoreDataHelper: NSObject {
    
    func insertSection(sectionName : String){
        let context : NSManagedObjectContext =  CoreDataManager.sharedInstance.managedObjectContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Section")
        request.predicate = NSPredicate(format: "sectionName == %@", sectionName)
        do {
            let results : [Section] = try context.fetch(request) as! [Section]
            if results.count == 0 {
                let entity =  NSEntityDescription.entity(forEntityName: "Section", in:context)
                let section : Section =  NSManagedObject(entity: entity!,insertInto: context) as! Section
                section.sectionName = sectionName
                do {
                    try context.save()
                } catch let error as NSError {
                    print("Could not save \(error), \(error.userInfo)")
                }
            }
        } catch let error {
            print("failed to fetch Section object: \(error)")
        }
    }
    
    func fetchSectionWithName(sectionName : String)-> Section{
        let context : NSManagedObjectContext =  CoreDataManager.sharedInstance.managedObjectContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Section")
        request.predicate = NSPredicate(format: "sectionName == %@", sectionName)
        do {
            let results : [Section] = try context.fetch(request) as! [Section]
            if results.count > 0 {
                return results[0]
            }
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
        var section : Section
        section = Section()
        section.sectionName = "---"
        return section
        
    }
    
    func insertKural(kural : NSDictionary){
        let context : NSManagedObjectContext =  CoreDataManager.sharedInstance.managedObjectContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Kural")
        request.predicate = NSPredicate(format: "kuralNo == %d", kural .object(forKey: "number") as! Int16)
        do {
            let results : [Kural] = try context.fetch(request) as! [Kural]
            if results.count == 0 {
                let entity =  NSEntityDescription.entity(forEntityName: "Kural", in:context)
                let kuralEntity : Kural =  NSManagedObject(entity: entity!,insertInto: context) as! Kural
                let kuralArray : NSArray  = kural.object(forKey: "kural") as! NSArray
                kuralEntity.kural = (kuralArray .object(at: 0) as! String) .appending(",").appending((kuralArray .object(at: 1) as! String))
                kuralEntity.kuralNo = kural .object(forKey: "number") as! Int16
                let kuralMeaning: NSDictionary = (kural .object(forKey: "meaning") as? NSDictionary)!
                kuralEntity.kuralMeaningMuVa = kuralMeaning .object(forKey: "ta_mu_va") as? String
                kuralEntity.kuralMeaningSaPa = kuralMeaning .object(forKey: "ta_salamon") as? String
                kuralEntity.kuralMeaningEng = kuralMeaning .object(forKey: "en") as? String
                
                let chapter : Chapter = insertChapter(chapterName: kural .object(forKey: "chapter") as! String,sectionName: kural .object(forKey: "section") as! String)
                kuralEntity.hasChapter = chapter
                do {
                    try context.save()
                } catch let error as NSError {
                    print("Could not save \(error), \(error.userInfo)")
                }
            }
        } catch let error {
            print("failed to fetch Kural object: \(error)")
        }
    }
    
    func updateKural(kural : Kural){
        let context : NSManagedObjectContext =  CoreDataManager.sharedInstance.managedObjectContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Kural")
        request.predicate = NSPredicate(format: "kuralNo == %d", kural.kuralNo)
        do {
            let results : [Kural] = try context.fetch(request) as! [Kural]
            if results.count != 0 {
                let kural1 : Kural = results.last!
                kural1.isFavourite = kural.isFavourite
                do {
                    try context.save()
                } catch let error as NSError {
                    print("Could not save \(error), \(error.userInfo)")
                }
            }
        } catch let error {
            print("failed to fetch Kural object: \(error)")
        }
    }
    
    func insertChapter(chapterName : String,sectionName : String) -> Chapter{
        var chapter : Chapter
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Chapter")
        request.predicate = NSPredicate(format: "chapterName == %@", chapterName)
        do {
            let results : [Chapter] = try CoreDataManager.sharedInstance.managedObjectContext.fetch(request) as! [Chapter]
            if results.count == 0 {
                let entity =  NSEntityDescription.entity(forEntityName: "Chapter", in:CoreDataManager.sharedInstance.managedObjectContext)
                chapter =  NSManagedObject(entity: entity!,insertInto: CoreDataManager.sharedInstance.managedObjectContext) as! Chapter
                chapter.chapterName = chapterName
                let section:Section = fetchSectionWithName(sectionName: sectionName);
                chapter.hasSection = section
                do {
                    try CoreDataManager.sharedInstance.managedObjectContext.save()
                } catch let error as NSError {
                    print("Could not save \(error), \(error.userInfo)")
                }
                return chapter
            }
            else{
                return results[0]
            }
        } catch let error {
            print("failed to fetch Section object: \(error)")
        }
        chapter = Chapter()
        chapter.chapterName = "---"
        return chapter
    }
    
    func getAllSections() -> [Section]{
        var results : [Section]?
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Section")
        do {
            results = try CoreDataManager.sharedInstance.managedObjectContext.fetch(request) as? [Section]
        }
        catch let error {
            print("failed to fetch Section object: \(error)")
        }
        return results!
    }
    
    func getAllChaptersForSection(section : Section) -> [Chapter]{
        var results : [Chapter] = []
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Chapter")
        request.predicate = NSPredicate(format: "hasSection == %@", section)
        do {
            results = try CoreDataManager.sharedInstance.managedObjectContext.fetch(request) as! [Chapter]
        }
        catch let error {
            print("failed to fetch Section object: \(error)")
        }
        return results
    }
    
    func getAllKuralsForChapter(chapter : Chapter) -> [Kural]{
        var results : [Kural] = []
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Kural")
        let sort : NSSortDescriptor = NSSortDescriptor.init(key: "kuralNo", ascending: true)
        request.sortDescriptors = [sort]
        request.predicate = NSPredicate(format: "hasChapter == %@", chapter)
        do {
            results = try CoreDataManager.sharedInstance.managedObjectContext.fetch(request) as! [Kural]
        }
        catch let error {
            print("failed to fetch Section object: \(error)")
        }
        return results
    }
    
    
    func getAllFavouriteKurals() -> [Kural]{
        var results : [Kural] = []
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Kural")
        let sort : NSSortDescriptor = NSSortDescriptor.init(key: "kuralNo", ascending: true)
        request.sortDescriptors = [sort]
        request.predicate = NSPredicate(format: "isFavourite == %@", NSNumber.init(value: true))
        do {
            results = try CoreDataManager.sharedInstance.managedObjectContext.fetch(request) as! [Kural]
        }
        catch let error {
            print("failed to fetch Section object: \(error)")
        }
        return results
    }
    
    func getKuralForKeyword(keyword : String) -> [Kural]{
        var results : [Kural] = []
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Kural")
        request.predicate = NSPredicate(format: "kural contains[cd] %@", keyword)
        do {
            results = try CoreDataManager.sharedInstance.managedObjectContext.fetch(request) as! [Kural]
        }
        catch let error {
            print("failed to fetch Section object: \(error)")
        }
        return results
    }
    
    func getRandomKuralForTheDay()->Kural{
        
        var results : [Kural] = []
        let randomNubmer : UInt32 = arc4random()%1330
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Kural")
        request.predicate = NSPredicate(format: "kuralNo == %d", randomNubmer)
        do {
            results = try CoreDataManager.sharedInstance.managedObjectContext.fetch(request) as! [Kural]
        }
        catch let error {
            print("failed to fetch Section object: \(error)")
        }
        return results[0]
    }
    
}
