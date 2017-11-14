//
//  Kural+CoreDataProperties.swift
//  
//
//  Created by Mohankumar on 14/11/17.
//
//

import Foundation
import CoreData


extension Kural {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Kural> {
        return NSFetchRequest<Kural>(entityName: "Kural")
    }

    @NSManaged public var kural: String?
    @NSManaged public var kuralMeaningEng: String?
    @NSManaged public var kuralMeaningMuVa: String?
    @NSManaged public var kuralMeaningSaPa: String?
    @NSManaged public var kuralNo: Int16
    @NSManaged public var isFavourite: Bool
    @NSManaged public var hasChapter: Chapter?

}
