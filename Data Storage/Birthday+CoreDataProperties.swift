//
//  Birthday+CoreDataProperties.swift
//  BirthdayTracker
//
//  Created by Vadim Novikov on 02.05.2022.
//
//

import Foundation
import CoreData


extension Birthday {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Birthday> {
        return NSFetchRequest<Birthday>(entityName: "Birthday")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var birthdayId: String?
    @NSManaged public var birthdate: Date?

}

extension Birthday : Identifiable {

}
