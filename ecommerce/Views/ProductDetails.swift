import SwiftUI

struct ProductDetails: View {
    @Environment(\.managedObjectContext) var managedObject
    @Environment(\.dismiss) var dismiss
        
    var product: FetchedResults<Product>.Element
    
    @State private var name = ""
    @State private var price: Float = 0.0
    @State private var sku = ""
    @State private var quantity: Int16 = 0
    
    @State private var incart: Int16 = 1
        
    var body: some View {
        Form {
            Section {
                Text("Product Info")
                TextField("Name", text: $name).disabled(true).onAppear {
                    name = product.name!
                    price = product.price
                    sku = product.sku ?? "ss"
                    quantity = product.quantity
                    incart = product.incart
                }
                TextField("SKU", text: $sku).disabled(true)
                TextField("Price", value: $price, formatter: doubleFormatter)
                    .keyboardType(.decimalPad).disabled(true)
                TextField("Quantity", value: $quantity, formatter: intFormatter)
                    .keyboardType(.decimalPad).disabled(true)
            }
            Button(
                "-")
            {
                if self.incart == 0 {
                    return
                }
                self.incart -= 1
            }
            Text("\(incart)")
            Button(
                "+")
            {
                self.incart += 1
            }
            Button(
                "Add To Cart")
            {
                DataController().addToCart(incart: Int16(incart), context: managedObject, product: product)
                dismiss()
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
