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
    @State private var showingAlert = false
    
    
    
    var body: some View {
       
        NavigationView{
            VStack(alignment:.leading ){
               
                List{
                    ForEach(products){ product in
                        HStack{
                            NavigationLink(destination:EditProduct(product:product) ){
                                Text("Edit")
                            }
                            Spacer()
                            Text(product.name!).bold()
                            Spacer()
                            NavigationLink(destination:ProductDetails(product:product) ){
                                Text("Add")
                            }
                        }

                    }.onDelete(perform: deleteProduct)
                }

            }.navigationTitle("E-commerce")
                .toolbar{
                    ToolbarItem(placement: .navigationBarTrailing ){
                        Button{
                            showingAddView.toggle();
                        } label: {
                            Label("Add Product",systemImage: "plus.circle")
                        }
                    }
                }.sheet(isPresented: $showingAddView){
                    AddProduct()
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
