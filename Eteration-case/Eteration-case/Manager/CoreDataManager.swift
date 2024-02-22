//
//  CoreDataManager.swift
//  Eteration-case
//
//  Created by Ozgun Dogus on 8.01.2024.
//

import UIKit
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Eteration_case")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func addToCart(product: ProductModel, quantity: Int16) {
        let cartItem = ProductsCoreData(context: context)
        cartItem.name = product.name
        cartItem.price = product.price
        cartItem.quantity = quantity
        saveContext()
    }

    func updateCartProduct(product: ProductModel, quantity: Int16) {
        let fetchRequest: NSFetchRequest<ProductsCoreData> = ProductsCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", product.name)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let productToUpdate = results.first {
                productToUpdate.quantity = quantity
                saveContext()
            } else {
               
                addToCart(product: product, quantity: quantity)
            }
        } catch {
            print("Update error: \(error)")
        }
    }
    
    func fetchCartItems() -> [ProductsCoreData] {
        let fetchRequest: NSFetchRequest<ProductsCoreData> = ProductsCoreData.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Fetch error: \(error)")
            return []
        }
    }
    
    func removeFromCart(name: String) {
        let fetchRequest: NSFetchRequest<ProductsCoreData> = ProductsCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)

        do {
            let results = try context.fetch(fetchRequest)
            if let productToDelete = results.first {
                context.delete(productToDelete)
                saveContext()
            }
        } catch {
            print("Remove from cart error: \(error)")
        }
    }


    
}

