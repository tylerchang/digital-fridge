//  Created by Tyler  Chang on 2/11/24.
//
// This View is what the user will see when trying to add an item with manual entry
// All inputs will be empty by default for the user to enter in data themselves

import SwiftUI
import UserNotifications


struct InfoCardViewManual: View {
    
    @State var productName: String
    var barcode: String
    @State var shelfLife: String
    @State var shelfLifeMetric: String
    @State var shelfLifeType: String
    
    @Binding var isShowing: Bool
    
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
                    isShowing.toggle()
                    presentationMode.wrappedValue.dismiss()
                    
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
                            isShowing.toggle()
                            presentationMode.wrappedValue.dismiss()
                            
                        }
                        else if self.shelfLifeType == "Pantry"{
                            print("Adding to Pantry")
                            print("Product Name: ", self.productName)
                            print("Shelf Life: ", self.shelfLife)
                            print("Shelf life Metric ", self.shelfLifeMetric)
                            try await firebaseModel.addFoodToPantry(productName: self.productName, shelfLifeLength: self.shelfLife, shelfLifeMetric: self.shelfLifeMetric)
                            isShowing.toggle()
                            presentationMode.wrappedValue.dismiss()
                        }
                        else{
                            print("Adding to Freezer")
                            print("Product Name: ", self.productName)
                            print("Shelf Life: ", self.shelfLife)
                            print("Shelf life Metric ", self.shelfLifeMetric)
                            try await firebaseModel.addFoodToFreezer(productName: self.productName, shelfLifeLength: self.shelfLife, shelfLifeMetric: self.shelfLifeMetric)
                            isShowing.toggle()
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

    


