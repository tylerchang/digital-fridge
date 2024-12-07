//  Created by Simay Cural on 2/10/24.
//
// This View is what the user will see after successfully scanning a receipt
// By taking in inputs from various APIs, it will display all the data neatly into a card which allows the user to add or discard into their inventory
// When an item is added or discarded, it will guide the user back to the scanned items page of the receipt scanning page so they can proceed to the next item

import Foundation

import SwiftUI

struct InfoCardViewReceipt: View, Identifiable {
    
    @State var productName: String
    var barcode: String
    @State var shelfLife: String
    @State var shelfLifeMetric: String
    @State var shelfLifeType: String
    @State var addedToInv: Bool
    
    var id = UUID()
    
    @Binding var isPresentingScanner: Bool
    @Binding var scannedSuccess: Bool
    @EnvironmentObject var firebaseModel: FirebaseViewModel
    @Environment(\.presentationMode) var presentationMode
    
    func classifyLifeType(){
        if self.shelfLifeType.contains("Refrigerate"){
            self.shelfLifeType = "Fridge"
        }
        else if self.shelfLifeType.contains("Pantry"){
            self.shelfLifeType = "Pantry"
        }
        else if self.shelfLifeType.contains("Freezer"){
            self.shelfLifeType = "Freezer"
        }
        else{
            self.shelfLifeType = "Fridge"
        }
    }

    // UI
    var body: some View {
        VStack(spacing: 24){
            
            List{
                Section("Product: \(barcode)"){
                    TextfieldView(productName: $productName, imageName: "fork", fontSize: 20)
                }
                
                Section("Estimated Shelf Life"){
                    ShelfLifeDisplayView(selectedMetric: $shelfLifeMetric, shelfLifeLength: $shelfLife)
                }
                
                Section("Add To"){
                    
                }
            }.frame(height: 280)
            
            // Which collection to add to
            CollectionPickerView(shelfLifeType: $shelfLifeType)
            
            Spacer()
            // Add / Delete
            HStack(){
                Spacer()
                
                Button{
                    isPresentingScanner.toggle()
                    scannedSuccess.toggle()
                    
                } label: {
                    Image("x-icon")
                        .resizable().frame(width: 150, height: 150)
                }
                
                Spacer()
                
                Button{
                    Task{
                        // Adds to the corresponding collection based on the option selected
                        if self.shelfLifeType == "Fridge"{
                            print("Adding to Fridge")
                            print("Product Name: ", self.productName)
                            print("Shelf Life: ", self.shelfLife)
                            print("Shelf life Metric ", self.shelfLifeMetric)
                            self.addedToInv = true
                            try await firebaseModel.addFoodToFridge(productName: self.productName, shelfLifeLength: self.shelfLife, shelfLifeMetric: self.shelfLifeMetric)
                            //self.scannedSuccess.toggle()
                            presentationMode.wrappedValue.dismiss()
                            
                        }
                        else if self.shelfLifeType == "Pantry"{
                            print("Adding to Pantry")
                            print("Product Name: ", self.productName)
                            print("Shelf Life: ", self.shelfLife)
                            print("Shelf life Metric ", self.shelfLifeMetric)
                            self.addedToInv = true
                            try await firebaseModel.addFoodToPantry(productName: self.productName, shelfLifeLength: self.shelfLife, shelfLifeMetric: self.shelfLifeMetric)
                            //self.scannedSuccess.toggle()
                            presentationMode.wrappedValue.dismiss()
                        }
                        else{
                            print("Adding to Freezer")
                            print("Product Name: ", self.productName)
                            print("Shelf Life: ", self.shelfLife)
                            print("Shelf life Metric ", self.shelfLifeMetric)
                            self.addedToInv = true
                            try await firebaseModel.addFoodToFreezer(productName: self.productName, shelfLifeLength: self.shelfLife, shelfLifeMetric: self.shelfLifeMetric)
                            //self.scannedSuccess.toggle()
                            presentationMode.wrappedValue.dismiss()
                        }
                        
                    }
                } label: {
                    Image("check")
                        .resizable().frame(width: 150, height: 150)
                }
                Spacer()
            }
            Spacer()
            
        }.onAppear(){
            classifyLifeType()
        }
    }
    
}


