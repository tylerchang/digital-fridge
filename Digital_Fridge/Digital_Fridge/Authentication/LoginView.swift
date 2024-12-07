// Created by Tyler  Chang on 1/30/24.
//
// This is the login page whhich contains all necessary forms/inputs for a user to be logged in
// Button takes this info and sends it to Firebase to log into the account
// Also option to navigate to the sign up page


import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var firebaseModel: FirebaseViewModel
    
    var body: some View {
        NavigationStack{
            VStack{
                //image
                Image("preserve_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 400, height: 200)
                
                //form fields
                VStack(spacing: 24){
                    InputView(text: $email,
                              title: "Email Address",
                              placeholder: "name@example.com")
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    
                    InputView(text: $password,
                              title: "Password",
                              placeholder: "Enter your password",
                              isSecureField: true)
                    
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                //Sign in buttton
                Button{
                    Task{
                        try await firebaseModel.signIn(withEmail: email, password: password)
                    }
                } label: {
                    HStack{
                        Text("SIGN IN")
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
                
                //sign up button
                NavigationLink{
                    RegistrationView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    HStack(spacing: 3){
                        Text("Don't have a fridge?")
                        Text("Sign up")
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 14))
                }
            }
        }
    }
}

// form checks!
extension LoginView: AuthenticationFormProtocol{
    var formIsValid: Bool{
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
    }
}

