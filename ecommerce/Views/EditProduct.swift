//
//  EditProduct.swift
//  ecommerce
//
//  Created by Mirza Showvik on 19/5/23.
//

import SwiftUI

struct EditProduct: View {
    @Environment(\.managedObjectContext) var managedObject
    @Environment(\.dismiss) var dismiss
    
    
    
    var product:FetchedResults<Product>.Element
    @State private var name=""
    @State private var price: Float = 0.0
    @State private var sku=""
    @State private var quantity:Int16=0
    
    
    var body: some View {
        Form{
            Section{
                Text("Product Info")
                TextField("Name",text: $name).onAppear{
                    name = product.name!;
                    price = product.price;
                    sku = product.sku ?? "ss";
                    quantity = product.quantity;
                };
                TextField("SKU",text: $sku);
                TextField("Price", value: $price, formatter: doubleFormatter)
                    .keyboardType(.decimalPad);
                TextField("Quantity", value: $quantity, formatter: intFormatter)
                    .keyboardType(.decimalPad);
            }
            HStack{
                Spacer()
                Button(
                    "Save"){
                        DataController().editProduct(name: name, price: price, sku: sku, quantity: Int16(quantity), context: managedObject, product: product);
                        dismiss();
                    }
                Spacer()
                
            }
        }
    }
    let intFormatter: NumberFormatter = {
              let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
              return formatter
         }()
    let doubleFormatter: NumberFormatter = {
              let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
              return formatter
         }()
}


