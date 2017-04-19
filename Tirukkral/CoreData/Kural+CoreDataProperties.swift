//
//  Kural+CoreDataProperties.swift
//  Tirukkral
//
//  Created by Muthu on 17/04/17.
//  Copyright © 2017 Mohan. All rights reserved.
//

import Foundation
import CoreData


extension Kural {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Kural> {
        return NSFetchRequest<Kural>(entityName: "Kural");
    }

    @NSManaged public var kural: String?
    @NSManaged public var kuralNo: Int16
    @NSManaged public var kuralMeaningMuVa: String?
    @NSManaged public var kuralMeaningSaPa: String?
    @NSManaged public var kuralMeaningEng: String?
    @NSManaged public var hasChapter: Chapter?

}
