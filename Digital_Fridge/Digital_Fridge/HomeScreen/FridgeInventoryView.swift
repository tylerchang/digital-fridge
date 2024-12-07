//  Created by Simay Cural on 2/11/24.
//
//  This class is a sepearate view page to house the items in the fridge inventory.
//  Provides  brief descriptions of the items, swipe actions, and pop-ups for item specific inventory cards.


import Foundation
import SwiftUI


struct FridgeInventoryView: View {
    @EnvironmentObject private var firebaseModel : FirebaseViewModel
    @State private var isPresented = false
    
    var body: some View{
        NavigationView{
            if firebaseModel.foodInFridge.count != 0 {
                List(firebaseModel.foodInFridge){food in
                    VStack(alignment: .leading){
                        Button(food.productName){
                            self.isPresented = true
                        }.font(.headline)
                        Text(food.shelfLifeLength + " " + food.shelfLifeMetric)
                            .font(.subheadline)
                        
                    }
                    .swipeActions(edge: .trailing){
                        Button{ Task{ try await deleteFromList(food: food) }
                        } label: {
                            Label("Eaten~", systemImage: "fork.knife.circle.fill")
                        } 
                        .tint(.green)
                    }
                    .sheet(isPresented: $isPresented, content: {
                        InventoryCardView(productName: food.productName, shelfLife: food.shelfLifeLength, shelfLifeMetric: food.shelfLifeMetric,
                                          shelfLifeType: "Fridge", foodDocumentID: food.foodDocumentID, isPresented: $isPresented)
                    })
                }
                .navigationTitle("Fridge Products")
                .navigationBarTitleDisplayMode(.inline)
            }
            // Adds items when fridge is empty
            else {
                List(){
                    Button("Fridge seems to be empty for now..."){
                        self.isPresented = true
                    }
                    .foregroundStyle(.secondary)
                    .sheet(isPresented: $isPresented, content: {
                        ImportScreenView() })
                }
                .navigationTitle("Fridge Products")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .onAppear() {
            self.firebaseModel.fetchFoodFromFridge()
        }
    }
    
    func deleteFromList(food: Food) async throws{ try await firebaseModel.deleteFoodFromFridge(foodDocumentID: food.foodDocumentID) }
}

struct FridgeInventoryView_Previews: PreviewProvider{
    static var previews: some View{
        FridgeInventoryView()
    }
}
