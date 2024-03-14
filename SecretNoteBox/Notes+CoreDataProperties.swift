//
//  Notes+CoreDataProperties.swift
//  SecretNoteBox
//
//  Created by Apple on 13/03/24.
//
//

import Foundation
import CoreData


extension Notes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Notes> {
        return NSFetchRequest<Notes>(entityName: "Notes")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var desc: String?
    @NSManaged public var img: Data?
    @NSManaged public var time: Date?
    @NSManaged public var audio: Data?

}
