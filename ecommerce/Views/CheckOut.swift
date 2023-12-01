//
//  CheckOut.swift
//  ecommerce
//
//  Created by Mirza Showvik on 19/5/23.
//

import SwiftUI

struct CheckOut: View {
    @Environment(\.managedObjectContext) var managedObject
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var products: FetchedResults<Product>
    @Environment(\.dismiss) var dismiss
    
    @State private var showingAlert = false
    @State private var productCount: [Int16] = []
    @State private var isArrayLoaded = false
    @State private var totalPrice: Float = 0.0
    @State private var tips: Float = 10.0
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Checkout Page")
                Spacer()
                Button(action: {
                    dismiss()
                }, label: { Image(systemName: "arrow.backward") }).onTapGesture {
                    dismiss()
                }
            }.padding().onAppear {
                self.productCount = []

                self.tips = 0.0
                self.isArrayLoaded = false
                self.totalPrice = 0.0
                print("im on")
                for product in products {
                    self.productCount.append(product.incart)
                    self.totalPrice += (Float(product.incart) * product.price)
                }
                self.isArrayLoaded = true
                print(self.productCount)
            }
               
            if self.isArrayLoaded == true { List {
                ForEach(Array(products.enumerated()), id: \.element) { index, product in
                        
                    if product.incart > 0 {
                        VStack {
                            HStack {
                                VStack {
                                    Text("\(product.name!) ").bold()
                                    Text("\(String(format: "%.2f", product.price)) Taka")
                                    Text("SKU : \(product.sku!) ")
                                }
                                Spacer()
                                Text("\(String(format: "%.2f", Float(self.productCount[index]) * product.price))")
                                    
                                Spacer()
                            }
                            HStack {
                                Button(action: {}, label: { Image(systemName: "minus.square") }).onTapGesture {
                                    if self.productCount[index] == 0 {
                                        return
                                    }
                                    self.productCount[index] -= 1
                                    self.totalPrice -= product.price
                                    print("minus called")
                                    print(self.productCount)
                                    DataController().addToCart(incart: self.productCount[index], context: managedObject, product: product)
                                }
                                Spacer()
                                Text("\(self.productCount[index])").padding()
                                Spacer()
                                Button(action: {}, label: { Image(systemName: "plus.app") }).onTapGesture {
                                    self.productCount[index] += 1
                                    print("plus called")
                                    self.totalPrice += product.price
                                    print(self.productCount)
                                    DataController().addToCart(incart: self.productCount[index], context: managedObject, product: product)
                                }
                            }
                        }
                    }
                }
            }}
            Form {
                Section {
                    Text("Given Tips %:")
                    TextField("Price", value: $tips, formatter: doubleFormatter)
                        .keyboardType(.decimalPad).onSubmit {}
                }
            }
            HStack {
                Spacer()
                Text("Total Price \(String(format: "%.2f", self.totalPrice))")
                Spacer()
            }
            HStack {
                Spacer()
                Text("Tip \(String(format: "%.2f", self.totalPrice * self.tips / 100))")
                Spacer()
            }
            HStack {
                Spacer()
                Button {} label: {
                    Label("Order Now", systemImage: "paperplane.fill")
                }
                Spacer()
            }

        }.navigationViewStyle(.stack).alert("Important message", isPresented: $showingAlert) {
            Button("OK", role: .cancel) {}
        }
        
        .onReceive(NotificationCenter.default.publisher(for: AlertClassX.showAlertMsg)) { _ in
            self.showingAlert = true
        }
    }

    func deleteProduct(offsets: IndexSet) {
        withAnimation {
            offsets.map { products[$0] }.forEach(managedObject.delete)
            DataController().save(context: managedObject)
        }
    }

    let doubleFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
}
