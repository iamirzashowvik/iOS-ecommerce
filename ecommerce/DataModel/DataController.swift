

import CoreData
import Foundation
import SwiftUI

class DataController: ObservableObject {
    let container=NSPersistentContainer(name: "ProductModel")
    
    init() {
        container.loadPersistentStores { _, error in
            if let error=error {
                print("Failed to load data \(error.localizedDescription)")
            }
        }
    }
    
    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
            print("Data saved")
           
        } catch {
            print("Error on data saving")
        }
    }
    
    func addProduct(name: String, price: Float, sku: String, quantity: Int16, context: NSManagedObjectContext) {
        let product=Product(context: context)
        print("name\(name)dd")
        if name == "" {
            print("empty name")
            AlertClassX().doCalculations()
            return
        }
                                 
        product.name=name
        product.price=price
        product.quantity=quantity
        product.sku=sku
        product.date=Date()
        save(context: context)
    }
    
    func addToCart(incart: Int16, context: NSManagedObjectContext, product: Product) {
        product.incart=incart
        product.date=Date()
        save(context: context)
    }
}
