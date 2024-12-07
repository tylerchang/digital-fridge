//
//  InputView.swift
//  Digital_Fridge
//
//  Created by Tyler  Chang on 1/30/24.
//
// This is a component View which is used in both login and registration views
// Contains formatting properties, placeholder option, and secure field option for the input textfield

import SwiftUI

struct InputView: View {
    @Binding var text: String
    let title: String
    let placeholder: String
    
    // a secure field is used for the password field where characters appear censored
    var isSecureField = false
    
    
    var body: some View {
        VStack(alignment: .leading, spacing:12){
            Text(title)
                .foregroundColor(Color(.darkGray))
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .font(.system(size: 17))
            
            if isSecureField{
                SecureField(placeholder, text: $text)
                    .font(.system(size: 17))
            }else{
                TextField(placeholder, text: $text)
                    .font(.system(size: 17))
            }
            Divider()
            
        }
    }
}


struct InputView_Preview: PreviewProvider{
    static var previews: some View {
        InputView(text: .constant(""), title: "Email Address", placeholder: "name@example.com")
    }
}

