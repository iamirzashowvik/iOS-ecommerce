//
//  ContentView.swift
//  ecommerce
//
//  Created by Mirza Showvik on 19/5/23.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var managedObject
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date,order:.reverse)]) var products:FetchedResults<Product>
    
    @State private var showingAddView = false
    @State private var showingCart = false
    @State private var showingAlert = false
    
    
    
    var body: some View {
       
        NavigationView{
            VStack(alignment:.leading ){
               
                List{
                    ForEach(products){ product in
                        NavigationLink(destination:ProductDetails(product:product) ){
                            HStack{
    //                            NavigationLink(destination:EditProduct(product:product) ){
    //                                Text("Edit")
    //                            }
                               
                                VStack(alignment:.leading){
                                    Text("\(product.name!) ").bold()
                                    Text("\(String(format: "%.2f", product.price)) Taka")
                                    Text("SKU : \(product.sku!) ")
                                }
                                Spacer()
                                if product.incart>0{
                                    HStack{
                                        Text("\(product.incart)")
                                        Image(systemName: "checkmark")
                                    }
                                }
                                
                                Spacer()
                               
                            }
                        }

                    }.onDelete(perform: deleteProduct)
                }
// update
            }.navigationTitle("E-commerce")
                .toolbar{
                    ToolbarItem(placement: .navigationBarTrailing ){
                        Button{
                            showingAddView.toggle();
                        } label: {
                            Label("Add Product",systemImage: "plus.circle")
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing ){
                        Button{
                            showingCart.toggle();
                        } label: {
                            Label("Cart",systemImage: "cart")
                        }
                    }
                }.sheet(isPresented: $showingAddView){
                    AddProduct()
                }
                .sheet(isPresented: $showingCart){
                    CheckOut()
                }
        }.navigationViewStyle(.stack).alert("Important message", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        }
        
        .onReceive(NotificationCenter.default.publisher(for: AlertClassX.showAlertMsg)) { msg in
            self.showingAlert = true
        }
        
    }
    func deleteProduct(offsets:IndexSet){
        withAnimation {
            offsets.map { products[$0] }.forEach (managedObject.delete)
        DataController () . save (context: managedObject)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
