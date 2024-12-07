import Foundation

// When we request a product's name given its barcode with the OpenFoodFacts API, the response given is a JSON containing the information. 
// This struct file serves as the JSON equivalent in Swift and will be used for parsing the JSON data into Swift.

struct OpenFoodFactsJSONResponseModel: Codable {
    let code: String?
    let product: Product?
    let status: Int?
    let statusVerbose: String?

    enum CodingKeys: String, CodingKey {
        case code, product, status
        case statusVerbose = "status_verbose"
    }
}

struct Product: Codable {
    let productName: String?

    enum CodingKeys: String, CodingKey {
        case productName = "product_name"
    }
}
