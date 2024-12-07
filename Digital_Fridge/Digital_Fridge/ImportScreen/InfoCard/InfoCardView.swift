//  Created by Tyler  Chang on 2/5/24.
//
// This View is what the user will see after successfully scanning an item via barcode
// By taking in inputs from various APIs, it will display all the data neatly into a card which allows the user to add or discard into their inventory

import SwiftUI
import UserNotifications


struct InfoCardView: View {
    
    @State var productName: String
    var barcode: String
    @State var shelfLife: String
    @State var shelfLifeMetric: String
    @State var shelfLifeType: String
    
    @Binding var isPresentingScanner: Bool
    @Binding var scannedSuccess: Bool
    @EnvironmentObject var firebaseModel: FirebaseViewModel
    @Environment(\.presentationMode) var presentationMode
    
    // Helper function to determine which shelf life type to be toggled to in the display
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
                            try await firebaseModel.addFoodToFridge(productName: self.productName, shelfLifeLength: self.shelfLife, shelfLifeMetric: self.shelfLifeMetric)
                            self.scannedSuccess.toggle()
                            presentationMode.wrappedValue.dismiss()
                            
                        }
                        else if self.shelfLifeType == "Pantry"{
                            print("Adding to Pantry")
                            print("Product Name: ", self.productName)
                            print("Shelf Life: ", self.shelfLife)
                            print("Shelf life Metric ", self.shelfLifeMetric)
                            try await firebaseModel.addFoodToPantry(productName: self.productName, shelfLifeLength: self.shelfLife, shelfLifeMetric: self.shelfLifeMetric)
                            self.scannedSuccess.toggle()
                            presentationMode.wrappedValue.dismiss()
                        }
                        else{
                            print("Adding to Freezer")
                            print("Product Name: ", self.productName)
                            print("Shelf Life: ", self.shelfLife)
                            print("Shelf life Metric ", self.shelfLifeMetric)
                            try await firebaseModel.addFoodToFreezer(productName: self.productName, shelfLifeLength: self.shelfLife, shelfLifeMetric: self.shelfLifeMetric)
                            self.scannedSuccess.toggle()
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

    


