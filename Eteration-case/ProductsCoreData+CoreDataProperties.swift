//
//  ProductsCoreData+CoreDataProperties.swift
//  Eteration-case
//
//  Created by Ozgun Dogus on 8.01.2024.
//
//

import Foundation
import CoreData


extension ProductsCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductsCoreData> {
        return NSFetchRequest<ProductsCoreData>(entityName: "ProductsCoreData")
    }

    @NSManaged public var name: String?
    @NSManaged public var price: String
    @NSManaged public var quantity: Int16

}

extension ProductsCoreData : Identifiable {

}
