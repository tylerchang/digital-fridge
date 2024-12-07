//  Created by Tyler  Chang on 1/30/24.
//
// This is the registration page whhich contains all necessary forms/inputs for a user to be created
// There is also a button which takes this info and sends it to Firebase to process the new account

import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var fullname = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var firebaseModel: FirebaseViewModel
    
    var body: some View {
        VStack{
            //image
            Image("preserve_logo")
                .resizable()
                .scaledToFit()
                .frame(width: 400, height: 200)
            
            VStack(spacing: 24){
                InputView(text: $email,
                          title: "Email Address",
                          placeholder: "name@example.com")
                .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                
                InputView(text: $fullname,
                          title: "Full Name",
                          placeholder: "Enter your name")
                InputView(text: $password,
                          title: "Password",
                          placeholder: "Enter your password",
                          isSecureField: true)
                
                ZStack(alignment: .trailing){
                    InputView(text: $confirmPassword,
                              title: "Confirm Password",
                              placeholder: "Confirm your password",
                              isSecureField: true)
                    
                    if !password.isEmpty && !confirmPassword.isEmpty{
                        if password == confirmPassword{
                            Image("check")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                        }else{
                            Image("x-icon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                        }
                    }
                }
            }
            
        }
        .padding(.horizontal)
        .padding(.top, 12)
        
        
        //sign up buttton
        Button{
            Task{
                try await firebaseModel.createUser(withEmail: email, password: password, fullname: fullname)
            }
        }label: {
            HStack{
                Text("SIGN UP")
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .frame(width: UIScreen.main.bounds.width - 32, height: 48)
        }
        .background(Color(.systemBlue))
        .disabled(!formIsValid)
        .opacity(formIsValid ? 1.0 : 0.5)
        .cornerRadius(10)
        .padding(.top, 24)
        
        Spacer()
        
        Button{
            dismiss()
        } label: {
            HStack(spacing: 3){
                Text("Already have a fridge?")
                Text("Sign in")
                    .fontWeight(.bold)
            }
            .font(.system(size: 14))
        }
        
    }
    }



// check forms and make sure inputs adhere to standards and protocols
extension RegistrationView: AuthenticationFormProtocol{
    var formIsValid: Bool{
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
        && password == confirmPassword
        && !fullname.isEmpty
    }
}


#Preview {
    RegistrationView()
}
