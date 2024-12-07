//  Created by Tyler  Chang on 1/23/24.
// BarcodeScannerView is a View utilizing the CodeScanner dependency and can be embedded to perform the barcode scanning import feature and get the product name
// When the code is scanned, the OpenFoodFacts API is called in order to retrieve the name; this name is then passed into the ITS/Python LLM server API to get the shelf life


import SwiftUI
import CodeScanner


struct BarcodeScannerView: View{
    @State var isPresentingScanner = true
    @State var barcode: String = ""
    @State var productName: String = ""
    
    @State var shelfLifeLength: String = ""
    @State var shelfLifeMetric: String = ""
    @State var shelfLifeType: String = ""
    @State var scannedSuccess = false
    
    let openFoodFactsAPIQuery = OpenFoodFactsQuery()
    let shelfLifeAPIController = ShelfLifeAPIController()
    
    var scannerSheet : some View{
        CodeScannerView(
            codeTypes:[.ean13, .ean8, .upce, .code39, .code39Mod43, .code93, .upce, .interleaved2of5, .itf14, .code128],
            completion: { result in
                if case let .success(code) = result{
                    var detectedCode = code.string
                    // Remove the auto-added zero
                    self.isPresentingScanner.toggle()
                    
                    detectedCode.remove(at: detectedCode.startIndex)
                    openFoodFactsAPIQuery.performQueryWithBarcode(scannedBarcode: detectedCode)
                    
                    // Runs after 1.5 seconds to give enough loading time for OpenFoodFacts API
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self.barcode = detectedCode
                        self.productName = openFoodFactsAPIQuery.getProductName()
                        shelfLifeAPIController.callShelfLifeAPI(productName: self.productName)
                    }
                    // Runs after 8 seconds to give enough loading time for ITS/Python LLM API
                    DispatchQueue.main.asyncAfter(deadline: .now() + 8.0) {
                        let shelfLifeData = shelfLifeAPIController.getShelfLifeData()
                        print("shelf life data: ", shelfLifeData)
                        self.shelfLifeLength = shelfLifeData[0]
                        self.shelfLifeMetric = shelfLifeData[1]
                        self.shelfLifeType = shelfLifeData[2]
                        self.scannedSuccess.toggle()
                    }
                    
                }
            }
        )
    }
    // UI
    var body: some View {
        VStack(spacing: 10){
            if scannedSuccess{
                InfoCardView(productName: self.productName, barcode: self.barcode, shelfLife: self.shelfLifeLength, shelfLifeMetric: self.shelfLifeMetric, shelfLifeType: self.shelfLifeType, isPresentingScanner: $isPresentingScanner, scannedSuccess: $scannedSuccess)
            }else{
                ProgressView{
                    Image(systemName: "refrigerator").resizable().frame(width:50, height: 70).tint(.cyan)
                }.tint(.cyan).controlSize(.large)
            }
                                
        }.sheet(isPresented: $isPresentingScanner){
            self.scannerSheet
        }
    }
}

