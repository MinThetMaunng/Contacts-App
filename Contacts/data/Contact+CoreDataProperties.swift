//
//  Contact+CoreDataProperties.swift
//  Contacts
//
//  Created by Min Thet Maung on 20/06/2020.
//  Copyright © 2020 Myanmy. All rights reserved.
//
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var name: String?
    @NSManaged public var phone: String?
    @NSManaged public var photo: Data?

}
