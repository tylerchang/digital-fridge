//  Created by Tyler  Chang on 2/13/24.
//
// The Recipe response from Spoonacular does not contain information about a quick summary of the recipe itself
// This information is instead obtained from another Spoonacular API call, thus we need this object to parse the response into


import Foundation

struct RecipeSummary: Codable, Identifiable{
    let id: Int?
    let summary: String?
    let title: String?
}
