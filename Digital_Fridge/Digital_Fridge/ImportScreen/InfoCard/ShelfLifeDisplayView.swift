//
//  QuantitySelectionView.swift
//  Digital_Fridge
//
//  Created by Tyler  Chang on 2/5/24.
//

import SwiftUI

// This is a component View which will be used in the larger InfoCardView. This component consists of entering shelf life data and units

struct ShelfLifeDisplayView: View {
    
    func forTrailingZero(_ temp: Double) -> String {
        return String(format: "%g", temp)
    }
    
    @Binding var selectedMetric: String
    @Binding var shelfLifeLength: String
    
    var body: some View {
        
        HStack(){
            
            Image("calendar")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
            
            TextField("Length", text: $shelfLifeLength)
                .padding(.leading,10)
                .fontWeight(.bold)
                .disableAutocorrection(true)
            
            Picker("", selection: $selectedMetric) {
                Text("Day(s)").tag("Days")
                Text("Week(s)").tag("Weeks")
                Text("Month(s)").tag("Months")
                Text("Year(s)").tag("Years")
            }.foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
        }
    }
}


