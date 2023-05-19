//
//  ecommerceApp.swift
//  ecommerce
//
//  Created by Mirza Showvik on 19/5/23.
//

import SwiftUI

@main
struct ecommerceApp: App {
    @StateObject private var productController=DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environment(
                \.managedObjectContext,productController.container.viewContext)
        }
    }
}
