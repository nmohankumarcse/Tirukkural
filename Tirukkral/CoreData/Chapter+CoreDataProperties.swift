//
//  Chapter+CoreDataProperties.swift
//  Tirukkral
//
//  Created by Muthu on 17/04/17.
//  Copyright © 2017 Mohan. All rights reserved.
//

import Foundation
import CoreData


extension Chapter {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Chapter> {
        return NSFetchRequest<Chapter>(entityName: "Chapter");
    }

    @NSManaged public var chapterName: String?
    @NSManaged public var hasSection: Section?
    @NSManaged public var kurals: NSSet?

}

// MARK: Generated accessors for kurals
extension Chapter {

    @objc(addKuralsObject:)
    @NSManaged public func addToKurals(_ value: Kural)

    @objc(removeKuralsObject:)
    @NSManaged public func removeFromKurals(_ value: Kural)

    @objc(addKurals:)
    @NSManaged public func addToKurals(_ values: NSSet)

    @objc(removeKurals:)
    @NSManaged public func removeFromKurals(_ values: NSSet)

}
