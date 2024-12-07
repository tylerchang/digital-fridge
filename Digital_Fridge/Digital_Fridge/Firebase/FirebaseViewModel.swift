//  Created by Tyler  Chang on 1/30/24.
//
//  This class serves as a reference to the our Firebase backend
//  Everything from user authentication, fetching and writing to the database, etc. are in this class as methods
//  This class is universally accessible throughout the whole application as an ObservableObject which keeps backened access to be simply

import Foundation
import Firebase
import FirebaseFirestoreSwift

protocol AuthenticationFormProtocol{
    var formIsValid: Bool {get}
}

@MainActor
class FirebaseViewModel: ObservableObject{
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var foodInFridge : [Food]
    @Published var foodInFreezer : [Food]
    @Published var foodInPantry : [Food]
    let notificationsController = NotificationsController()
    
    init(){
        // this is supposed make the user stay signed in, even after the user exits the app
        self.userSession = Auth.auth().currentUser
        self.foodInFridge = []
        self.foodInFreezer = []
        self.foodInPantry = []
        
        Task{
            await fetchUser()
        }

    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do{
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        }catch{
            print("Debug: failed to log in with error \(error.localizedDescription)")
        }
    }
    
    func createUser(withEmail email: String, password: String, fullname: String) async throws{
        do{
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let ownerID = result.user.uid
            
            
            let newFridgeID = try await createFridge(ownerID: ownerID)
            let newFreezerID = try await createFreezer(ownerID: ownerID)
            let newPantryID = try await createPantry(ownerID: ownerID)
            
            try await Firestore.firestore()
                .collection("users")
                .document(result.user.uid)
                .setData(
                [
                   "userID": ownerID,
                   "fullname": fullname,
                   "email": email,
                   "fridgeID": newFridgeID,
                   "freezerID": newFreezerID,
                   "pantryID": newPantryID
                ])
            
            await fetchUser()
        }catch{
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
            
        }
    }
    
    func signOut(){
        do{
            try Auth.auth().signOut() // signs out user on backend
            self.userSession = nil // wipes out user session and takes us back to login screen
            self.currentUser = nil // wipes out current user data model
        } catch {
            print("Debug: failed to sign out")
        }
    }
    
    func fetchUser() async{
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else {return}
        
        let userData = snapshot.data()
        let email = userData?["email"] as? String ?? ""
        let userID = userData?["userID"] as? String ?? ""
        let fullname = userData?["fullname"] as? String ?? ""
        let fridgeID = userData?["fridgeID"] as? String ?? ""
        let freezerID = userData?["freezerID"] as? String ?? ""
        let pantryID = userData?["pantryID"] as? String ?? ""
        
        self.currentUser = User(userId: userID, fullname: fullname, email: email, fridgeID: fridgeID, freezerID: freezerID, pantryID: pantryID)
    }
    
    func createFridge(ownerID: String) async throws -> String {
        
        let fridgeID = UUID().uuidString
        
        try await Firestore.firestore().collection("all_fridges").document(fridgeID).setData([
            "name": "My Fridge",
            "owner_id": ownerID
        ])
          print("Fridge successfully written!")
        
        return fridgeID
    }
    
    func createFreezer(ownerID: String) async throws -> String {
        
        let freezerID = UUID().uuidString
        
        try await Firestore.firestore().collection("all_freezers").document(freezerID).setData([
            "name": "My Freezer",
            "owner_id": ownerID
        ])
          print("Freezer successfully created!")
        
        return freezerID
    }
    
    func createPantry(ownerID: String) async throws -> String {
        
        let pantryID = UUID().uuidString
        
        try await Firestore.firestore().collection("all_pantries").document(pantryID).setData([
            "name": "My Pantry",
            "owner_id": ownerID
        ])
          print("Pantry successfully created!")
        
        return pantryID
    }
    
    func addFoodToFridge(productName: String, shelfLifeLength: String, shelfLifeMetric: String) async throws{
        let docRef = try await Firestore.firestore().collection("all_fridges").document(self.currentUser?.fridgeID ?? "unknown frdge id")
            .collection("food_inside_fridge").addDocument(data: [
                "productName": productName,
                "shelfLifeLength": shelfLifeLength,
                "shelfLifeMetric": shelfLifeMetric
        ])
        let foodUUID = docRef.documentID
        
        try await notificationsController.scheduleNotificationsForFood(productName: productName, foodUUID: foodUUID, shelfLifeLength: shelfLifeLength, shelfLifeMetric: shelfLifeMetric)
        
    }
    
    func addFoodToPantry(productName: String, shelfLifeLength: String, shelfLifeMetric: String) async throws{
        let docRef = try await Firestore.firestore().collection("all_pantries").document(self.currentUser?.pantryID ?? "unknown pantry id")
            .collection("food_inside_pantry").addDocument(data: [
                "productName": productName,
                "shelfLifeLength": shelfLifeLength,
                "shelfLifeMetric": shelfLifeMetric
        ])
        let foodUUID = docRef.documentID
        try await notificationsController.scheduleNotificationsForFood(productName: productName, foodUUID: foodUUID, shelfLifeLength: shelfLifeLength, shelfLifeMetric: shelfLifeMetric)
    }
    
    func addFoodToFreezer(productName: String, shelfLifeLength: String, shelfLifeMetric: String) async throws{
        let docRef = try await Firestore.firestore().collection("all_freezers").document(self.currentUser?.freezerID ?? "unknown freezer id")
            .collection("food_inside_freezer").addDocument(data: [
                "productName": productName,
                "shelfLifeLength": shelfLifeLength,
                "shelfLifeMetric": shelfLifeMetric
        ])
        let foodUUID = docRef.documentID
        try await notificationsController.scheduleNotificationsForFood(productName: productName, foodUUID: foodUUID, shelfLifeLength: shelfLifeLength, shelfLifeMetric: shelfLifeMetric)
        
    }
    
    func fetchFoodFromFridge(){
        Firestore.firestore().collection("all_fridges").document(self.currentUser?.fridgeID ?? "unknown fridge id")
            .collection("food_inside_fridge").addSnapshotListener{ (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("Gotta go grocery shopping...")
                    return
                }
                
                self.foodInFridge = documents.map{ (queryDocumentSnapshot) -> Food in
                    let data = queryDocumentSnapshot.data()
                    
                    let productName = data["productName"] as? String ?? ""
                    let shelfLifeLength = data["shelfLifeLength"] as? String ?? ""
                    let shelfLifeMetric = data["shelfLifeMetric"] as? String ?? ""
                    
                    return Food(productName: productName, shelfLifeLength: shelfLifeLength, shelfLifeMetric: shelfLifeMetric, foodDocumentID: queryDocumentSnapshot.documentID)
                    
                }
        }
    }
    
    func fetchFoodFromFreezer(){
        Firestore.firestore().collection("all_freezers").document(self.currentUser?.freezerID ?? "unknown freezer id")
            .collection("food_inside_freezer").addSnapshotListener{ (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("Gotta go grocery shopping...")
                    return
                }
                
                self.foodInFreezer = documents.map{ (queryDocumentSnapshot) -> Food in
                    let data = queryDocumentSnapshot.data()
                    
                    let productName = data["productName"] as? String ?? ""
                    let shelfLifeLength = data["shelfLifeLength"] as? String ?? ""
                    let shelfLifeMetric = data["shelfLifeMetric"] as? String ?? ""
                    
                    return Food(productName: productName, shelfLifeLength: shelfLifeLength, shelfLifeMetric: shelfLifeMetric, foodDocumentID: queryDocumentSnapshot.documentID)
                    
                }
        }
    }
    
    func fetchFoodFromPantry(){
        Firestore.firestore().collection("all_pantries").document(self.currentUser?.pantryID ?? "unknown pantry id")
            .collection("food_inside_pantry").addSnapshotListener{ (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("Gotta go grocery shopping...")
                    return
                }
                
                self.foodInPantry = documents.map{ (queryDocumentSnapshot) -> Food in
                    let data = queryDocumentSnapshot.data()
                    
                    let productName = data["productName"] as? String ?? ""
                    let shelfLifeLength = data["shelfLifeLength"] as? String ?? ""
                    let shelfLifeMetric = data["shelfLifeMetric"] as? String ?? ""
                    
                    return Food(productName: productName, shelfLifeLength: shelfLifeLength, shelfLifeMetric: shelfLifeMetric, foodDocumentID: queryDocumentSnapshot.documentID)
                }
        }
    }
    
    func deleteFoodFromFridge(foodDocumentID: String) async throws {
        let docRef =  Firestore.firestore().collection("all_fridges").document(self.currentUser?.fridgeID ?? "unknown fridge id")
            .collection("food_inside_fridge").document(foodDocumentID)
            try await docRef.delete()
    }
    
    func deleteFoodFromFreezer(foodDocumentID: String) async throws {
        let docRef = Firestore.firestore().collection("all_freezers").document(self.currentUser?.freezerID ?? "unknown freezer id")
            .collection("food_inside_freezer").document(foodDocumentID)
        try await docRef.delete()
    }
    
    func deleteFoodFromPantry(foodDocumentID: String) async throws {
        let docRef =  Firestore.firestore().collection("all_pantries").document(self.currentUser?.pantryID ?? "unknown pantry id")
            .collection("food_inside_pantry").document(foodDocumentID)
        try await docRef.delete()
    }
    
}
