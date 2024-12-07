//  Created by Simay Cural on 2/1/24.
//
// This is View is displayed when the user navigates to the import tab of the application
// There are 3 buttons, each leading to one of the 3 import features

import Foundation
import SwiftUI

struct ImportScreenView: View {
    @State private var isReceiptScannerPresented = false
    @State private var isBarcodeScannerPresented = false
    @State private var isManualEntryPresented = false
    
    var body: some View {
            VStack {
                // Receipt scanning
                Button(action: {
                    isReceiptScannerPresented = true
                    }) {
                    HStack(spacing: 3) {
                        Text("Import With Receipt Scanner")
                        }
                        .font(.system(size: 14))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                    }
                    .background(Color(.systemBlue))
                    .cornerRadius(10)
                    .padding(.top, 24)
                    .sheet(isPresented: $isReceiptScannerPresented) {
                            ReceiptScannerView()
                            .navigationBarBackButtonHidden(true)
                        }
                

                // Barcode scanning
                Button(action: {
                    isBarcodeScannerPresented = true
                    }) {
                    HStack(spacing: 3) {
                        Text("Import With Barcode Scanner")
                    }
                    .font(.system(size: 14))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                    }
                    .background(Color(.systemBlue))
                    .cornerRadius(10)
                    .sheet(isPresented:
                            $isBarcodeScannerPresented) {
                            BarcodeScannerView()
                            .navigationBarBackButtonHidden(true)
                        }
                // Manual entry
                Button(action: {
                    isManualEntryPresented = true
                    }) {
                    HStack(spacing: 3) {
                        Text("Import With Manual Entry")
                    }
                    .font(.system(size: 14))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                    }
                    .background(Color(.systemBlue))
                    .cornerRadius(10)
                    .sheet(isPresented: $isManualEntryPresented) {
                        InfoCardViewManual(productName: "Product Name", barcode: "", shelfLife: "5", shelfLifeMetric: "Days", shelfLifeType: "Fridge", isShowing: $isManualEntryPresented)
                            .navigationBarBackButtonHidden(true)
                        }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("bg"))
        }
}

struct ImportScreenView_Preview: PreviewProvider{
    static var previews: some View{
        ImportScreenView()
    }
}
