//  Created by Tyler  Chang on 2/5/24.
//
// This is a component View which will be used in the larger InfoCardView. This component handles entering the name of the ingredient

import SwiftUI

struct TextfieldView: View {
    @State var nameInEditMode = false
    @Binding var productName: String
    let imageName: String
    let fontSize: CGFloat

    var body: some View {
        HStack (alignment: .center, spacing: 12) {
            
                Image(imageName).resizable().frame(width: 30, height: 40)

                if nameInEditMode {
                    TextField("Name", text: $productName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.leading,10)
                        .font(.system(size: fontSize))
                        .fontWeight(.bold)
                        .disableAutocorrection(true)
                } else {
                    Text(productName)
                        .font(.system(size: fontSize))
                        .fontWeight(.bold)
                }

                Button(action: {
                    self.nameInEditMode.toggle()
                }) {
                    
                    Image(nameInEditMode ? "check" : "pencil")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
        }.padding(10)
    }
}
