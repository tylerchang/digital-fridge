//  Created by Tyler  Chang on 2/5/24.
//
// This is a component View which will be used in the larger InfoCardView. This component consists of toggling the three collection options


import SwiftUI

struct CollectionPickerView: View {
    
    @Binding var shelfLifeType: String
    
    var body: some View {
        Picker("", selection: $shelfLifeType) {
            
            //Image("fridge")
            Image(systemName: "refrigerator.fill")
                .resizable()
                //.scaledToFit()
                .frame(width: 80, height: 80)
                .tag("Fridge")
            
            //Image("pantry")
            Image(systemName: "stove")
                .resizable()
                //.scaledToFit()
                .frame(width: 80, height: 80)
                .tag("Pantry")
            
            //Image("freezer")
            Image(systemName: "snowflake")
                .resizable()
                //.scaledToFit()
                .frame(width: 80, height: 80)
                .tag("Freezer")
            
        }.pickerStyle(.segmented)
            .scaledToFit()
            .scaleEffect(CGSize(width: 1.5, height: 1.5))
            .frame(width: 240)
    }
}

