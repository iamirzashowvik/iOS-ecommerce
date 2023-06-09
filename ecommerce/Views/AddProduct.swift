//
//  AddProduct.swift
//  ecommerce
//
//  Created by Mirza Showvik on 19/5/23.
//

import SwiftUI

struct AddProduct: View {
    @Environment(\.managedObjectContext) var managedObject
    @Environment(\.dismiss) var dismiss
    
    
    @State private var name=""
    @State private var price: Float = 0.0
    @State private var sku=""
    @State private var quantity=0
    
    
    var body: some View {
        Form{
            Section{
                HStack{
                    Text("Add a new product")
                    Spacer()
                    Button(action: {
                        dismiss()
                    }, label: {Image(systemName: "arrow.backward")}).onTapGesture {
                        dismiss();
                    }
                }
              
                TextField("Name",text: $name);
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
                        DataController().addProduct(name: name, price: price, sku: sku, quantity: Int16(quantity), context: managedObject);
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

struct AddProduct_Previews: PreviewProvider {
    static var previews: some View {
        AddProduct()
    }
}
