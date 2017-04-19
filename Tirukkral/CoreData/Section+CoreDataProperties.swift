//
//  Section+CoreDataProperties.swift
//  Tirukkral
//
//  Created by Muthu on 17/04/17.
//  Copyright © 2017 Mohan. All rights reserved.
//

import Foundation
import CoreData


extension Section {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Section> {
        return NSFetchRequest<Section>(entityName: "Section");
    }

    @NSManaged public var sectionName: String?
    @NSManaged public var chapters: NSSet?

}

// MARK: Generated accessors for chapters
extension Section {

    @objc(addChaptersObject:)
    @NSManaged public func addToChapters(_ value: Chapter)

    @objc(removeChaptersObject:)
    @NSManaged public func removeFromChapters(_ value: Chapter)

    @objc(addChapters:)
    @NSManaged public func addToChapters(_ values: NSSet)

    @objc(removeChapters:)
    @NSManaged public func removeFromChapters(_ values: NSSet)

}
