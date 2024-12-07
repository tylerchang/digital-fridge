//  Created by Simay Cural on 1/29/24.
//  
//  This class allows users to scan receipts, extract text, retrieve shelf life information for scanned products, and display the information using InfoCardViewReceipt views.

import Foundation
import SwiftUI
import UIKit


struct ReceiptScannerView: View {
    @State private var showScannerSheet = false
    @State var isPresentingScanner = true
    @State var scannedSuccess = false
    
    @State private var texts:[ScanData] = []
    @State var productLabel: String = ""
    @State var estimatedShelfLife: [String] = []
    let shelfLifeAPIController = ShelfLifeAPIController()
    @State var list_of_description: [ShelfLifeResponseReceipt] = []
    @State var infoCardViews: [InfoCardViewReceipt] = []
    
    var body: some View {
            NavigationView{
                VStack{
                    if texts.count > 0{
                        // Pulls up infocards to add to inventory when scanned
                        if scannedSuccess{
                            List{
                            ForEach(self.infoCardViews){ card in
                                if !card.addedToInv  {
                                    NavigationLink(
                                        destination: card) {
                                            Text(card.productName).lineLimit(1)
                                        }
                                }
                                else{ Text(card.productName) }
                            }
                            
                        }.navigationTitle("Items Found")
                        }
                        // Loading screen
                        else{
                            ProgressView{
                                Image(systemName: "refrigerator").resizable().frame(width:50, height: 70).tint(.cyan)
                            }.tint(.cyan).controlSize(.large).navigationTitle("Detecting Groceries!")
                        }
                    }
                else {
                        Text("No scan yet").font(.title)
                    }
                }
                .navigationTitle("Scan Receipt")
                .navigationBarItems(trailing:
                                        Button(action: {
                    self.showScannerSheet = true
                }, label: {
                    Image(systemName: "doc.text.viewfinder")
                        .font(.title)
                })
                    .sheet(isPresented: $showScannerSheet, content: {
                        self.makeScannerView()
                    })
                )
            }
        }
    
    private func makeScannerView()-> ScannerView {
        ScannerView(completion: {
            textPerPage in
            if let outputText = textPerPage?.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines){
                let newScanData = ScanData(content: outputText)
                self.texts.append(newScanData)
            }
            // Calling shelf lifeAPI 
            for text in texts{
                shelfLifeAPIController.callShelfLifeAPIReceipt(receipt_text: text.content)
                DispatchQueue.main.asyncAfter(deadline: .now() + 40.0) {
                    let shelfLifeData = shelfLifeAPIController.getShelfLifeDataReceipt()
                    self.list_of_description = shelfLifeData
                    self.scannedSuccess = true
                    self.infoCardViews = addToInfoCardList()
                }
            }
            self.showScannerSheet = false
        })
    }
    
    private func addToInfoCardList()->[InfoCardViewReceipt]{
        for food in self.list_of_description{
            self.infoCardViews.append(InfoCardViewReceipt(productName: food.product, barcode: "", shelfLife: food.length, shelfLifeMetric: food.metric, shelfLifeType: food.life_type, addedToInv: false, isPresentingScanner: $isPresentingScanner, scannedSuccess: $scannedSuccess))
        }
        return self.infoCardViews
    }
    
    struct ReceiptScannerView_Previews: PreviewProvider {
        static var previews: some View {
            ReceiptScannerView()
        }
    }
}
