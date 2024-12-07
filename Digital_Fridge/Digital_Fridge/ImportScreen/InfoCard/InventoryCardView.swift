//  Created by Simay Cural on 2/12/24.
//
// This View is what the user will see after selecting an item in their inventory as displaed in the home screen
// This info card is very similar to the ones shown when importing, however, instead of choosing whether or not to add an item to the database, the user now has the ability to set whether an item is "eaten"


import Foundation
import SwiftUI

struct InventoryCardView: View {
    
    @State var productName: String
    @State var shelfLife: String
    @State var shelfLifeMetric: String
    @State var shelfLifeType: String
    @State var foodDocumentID: String
    
    @Binding var isPresented: Bool
    
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
                Section("Product"){
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
                    
                    // Deletes the item from the appropriate collection
                    Task{
                        if self.shelfLifeType == "Fridge"{
                            print("Deleting From Fridge")
                            print("Product Name: ", self.productName)
                            print("Shelf Life: ", self.shelfLife)
                            print("Shelf life Metric: ", self.shelfLifeMetric)
                            try await firebaseModel.deleteFoodFromFridge(foodDocumentID: self.foodDocumentID)
                            //self.isPresented.toggle()
                            presentationMode.wrappedValue.dismiss()
                            
                        }
                        else if self.shelfLifeType == "Pantry"{
                            print("Deleting From Pantry")
                            print("Product Name: ", self.productName)
                            print("Shelf Life: ", self.shelfLife)
                            print("Shelf life Metric ", self.shelfLifeMetric)
                            try await firebaseModel.deleteFoodFromPantry(foodDocumentID: self.foodDocumentID)
                            //self.isPresented.toggle()
                            presentationMode.wrappedValue.dismiss()
                        }
                        else{
                            print("Deleting From Freezer")
                            print("Product Name: ", self.productName)
                            print("Shelf Life: ", self.shelfLife)
                            print("Shelf life Metric ", self.shelfLifeMetric)
                            try await firebaseModel.deleteFoodFromFreezer(foodDocumentID: self.foodDocumentID)
                            //self.isPresented.toggle()
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                } label: {
                    VStack{
                        Text("Have you eaten this product yet?")
                        Text("Tap here to mark as eaten!").foregroundStyle(.secondary)
                        Image(systemName: "fork.knife.circle.fill").font(.system(size: 50))
                    }
                    .font(.system(size: 17))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 150)

                }
                .background(Color(.systemGreen))
                .cornerRadius(30)
                Spacer()
            }
            
            Button{
                self.isPresented = false
            } label: {
                VStack{
                    Text("or...").foregroundStyle(.secondary)
                    Text("Tap here to go back!")
                    //Image(systemName: "fork.knife.circle.fill").font(.system(size: 50))
                }
                .font(.system(size: 17))
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width - 32, height: 70)

            }
            .background(Color(.systemFill))
            .cornerRadius(30)
            
            Spacer()
            
        }.onAppear(){
            classifyLifeType()
        }
    }

}


