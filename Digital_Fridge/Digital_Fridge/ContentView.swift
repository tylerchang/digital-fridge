//  Created by Tyler  Chang on 1/28/24.

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var firebaseModel: FirebaseViewModel
    
    // Display the proper screen based on if the user is detected to be logged in or not
    var body: some View {
        Group{
            if firebaseModel.userSession != nil{
                HomeScreenView()
            }else{
                LoginView()
            }
        }.onAppear(){
            // Prompt the user for permission to allow notifications which the app will later need when items are about to go back
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                if success {
                    print("Permission approved!")
                } else if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
