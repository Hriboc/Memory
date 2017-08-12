//
//  HighScore+CoreDataProperties.swift
//  Memory
//
//  Created by Hristijan Bocevski on 2017-08-12.
//  Copyright © 2017 Hristijan Bocevski. All rights reserved.
//

import Foundation
import CoreData


extension HighScore {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HighScore> {
        return NSFetchRequest<HighScore>(entityName: "HighScore");
    }

    @NSManaged public var player: String?
    @NSManaged public var score: Int32
    @NSManaged public var gameType: String?

}
