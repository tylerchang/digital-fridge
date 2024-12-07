import SwiftUI
import Firebase

@main
struct Digital_FridgeApp: App {
    
    // When the app is first launched, we need to make sure we connect to the Firebase backend and configure all the proper authentications
    @StateObject var firebaseModel = FirebaseViewModel()
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(firebaseModel)
        }
    }
}

