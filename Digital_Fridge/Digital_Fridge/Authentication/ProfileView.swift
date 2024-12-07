//  Created by Tyler  Chang on 1/30/24.
//
// This is simple profile page that displays user data from Firebase as well as an option to sign out

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var firebaseModel: FirebaseViewModel
    var body: some View {
        if let user = firebaseModel.currentUser {
            List{
                Section {
                    HStack{
                        Text(user.initials)
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 72, height: 72)
                            .background(Color(.systemGray3))
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 4){
                            Text(user.fullname)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .padding(.top, 4)
                            
                            Text(user.email)
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    
                }
                Section("Account"){
                    Button{
                        firebaseModel.signOut()
                    } label: {
                        Text("Sign Out").foregroundColor(.red)
                    }
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
