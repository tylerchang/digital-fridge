//  Created by Tyler  Chang on 2/5/24.
//
// This serves as the API controller in charge of interacting with our Python ITS server which is responsible for returning shelf life through LLM processe
// Used by both barcode and receipt scanning
// Since barcode and receipt scanning both require different responses from the API / call different paths, there are separate call functions and response objects for each

import Foundation

// BARCODE SCANNING: This is the response struct that will be parsed to when we receive the JSON response from the API (barcode scanning path)
struct ShelfLifeResponse: Codable {
    let length: String
    let metric: String
    let life_type: String
    let closest_product_name: String
    let similarity_percentage: Double
}

// BARCODE SCANNING: This contains a list of the above responses
struct ListOfShelfLifeResponse: Codable {
    let shelfLifeResponse: [ShelfLifeResponseReceipt]

    enum CodingKeys: String, CodingKey {
        case shelfLifeResponse = "list_of_exp"
    }
}

// RECEIPT SCANNING: This is the response struct that will be parsed to when we receive the JSON response from the API (receipt scanning path)
struct ShelfLifeResponseReceipt: Codable, Identifiable {
    let closest_product_name, length, life_type, metric: String
    let product: String
    let similarity_percentage: Double
    let id = UUID()
    
    enum CodingKeys: String, CodingKey {
        case closest_product_name = "closest_product_name"
        case length = "length"
        case life_type = "life_type"
        case metric, product
        case similarity_percentage = "similarity_percentage"
    }
}

class ShelfLifeAPIController {
    
    // Setting up API routing to the ITS server
    let host = "http://10.13.44.27:5000"
    let shelf_life_endpoint = "/getShelfLife?product_name="
    let shelf_life_receipt_endpoint = "/getShelfLifeReceipt?receipt_text="
    var product = "Unknown Product"
    var length = "Unknown Length"
    var metric = "Unknown Metric"
    var life_type = "Unkown Life Type"
    var closest_product_name = "Unknown Closest Product Name"
    var similarity_percentage = 0.0
    var list_of_description: [ShelfLifeResponseReceipt] = []
    
    // Used to call shelf API for the barcode scanning
    public func callShelfLifeAPI(productName: String){
        let targetURL = host + shelf_life_endpoint + productName
        guard let url = URL(string: targetURL) else {return}
        print("HTTP Request sent to: " + url.absoluteString)
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(ShelfLifeResponse.self, from: data)
                    self.length = decodedData.length
                    self.metric = decodedData.metric
                    self.life_type = decodedData.life_type
                    self.closest_product_name = decodedData.closest_product_name
                    self.similarity_percentage = decodedData.similarity_percentage
                } catch {
                    print(String(describing: error))
                }
            } else if let error = error {
                //Print API call error
                print("Error fetching data: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    public func getShelfLifeData()->[String]{
        return [self.length, self.metric, self.life_type]
    }
    // Used to call shelf life API for the receipt scanning
    public func callShelfLifeAPIReceipt(receipt_text: String){
        let targetURL = host + shelf_life_receipt_endpoint + receipt_text
        guard let url = URL(string: targetURL) else {return}
        print("HTTP Request sent to: " + url.absoluteString)
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                    do {
                        let decodedData = try JSONDecoder().decode(ListOfShelfLifeResponse.self, from: data)
                        let shelfLifeResponse = decodedData.shelfLifeResponse
                        self.list_of_description = shelfLifeResponse
                    } catch {
                        print(String(describing: error))
                    }
            } else if let error = error {
                //Print API call error
                print("Error fetching data: \(error.localizedDescription)")
            }
        }.resume()
    }
    
//  not sure if this will be needed for receipt also since it's the same
    public func getShelfLifeDataReceipt()->[ShelfLifeResponseReceipt]{
        return self.list_of_description
    }
    
    
}
