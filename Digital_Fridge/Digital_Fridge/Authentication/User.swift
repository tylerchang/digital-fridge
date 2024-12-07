//  Created by Tyler  Chang on 1/30/24.
//
// This is a User object that we use to store data about the currently logged in user

import Foundation

struct User{
    let userId: String
    let fullname: String
    let email: String
    let fridgeID: String
    let freezerID: String
    let pantryID: String
    
    var initials: String{
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullname){
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        
        return ""
    }
}
