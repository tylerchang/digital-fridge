//
//  OpenFoodFactsController.swift
//  Digital_Fridge
//
//  Created by Tyler  Chang on 1/24/24.
//

import Foundation
import SwiftUI

// Instances of this class is used when queries need to made to the OpenFoodFacts API
class OpenFoodFactsQuery {
    
    let urlEndPoint = "https://world.openfoodfacts.net/api/v2/product/"
    var productName: String = ""
    
    // Function that performs a GET HTTP request given a barcode and assigns the returned product name to the self.productName variable
    public func performQueryWithBarcode(scannedBarcode: String){
        let targetURL = urlEndPoint + scannedBarcode + "?fields=product_name"
        let backupValue = "Could Not Find Product"
        
        guard let url = URL(string: targetURL) else {return}
        print("HTTP Request sent to: " + url.absoluteString)
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    //Parse JSON based on custom OpenFoodFactsJSONResponseModel
                    @State var decodedData = try JSONDecoder().decode(OpenFoodFactsJSONResponseModel.self, from: data)
                    let scannedName = decodedData.product?.productName
                    self.productName = scannedName ?? backupValue
                } catch {
                    print(String(describing: error))
                }
            } else if let error = error {
                //Print API call error
                print("Error fetching data: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    // Returns the productName if it was assigned a value by the most recent query assigned 
    public func getProductName()->String{
        if self.productName != "" {
            return self.productName
        }
        else{
            return "Empty Product Name. Perform a query to update this value"
        }
        
    }
    

}
