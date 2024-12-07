import UIKit

import SwiftUI

struct ProfileView: View {
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
