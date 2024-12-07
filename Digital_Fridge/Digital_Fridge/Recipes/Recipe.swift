//  Created by Tyler  Chang on 2/13/24.
//
// This serves as a Recipe object which we will need to decode our JSON response from Spoonacular into
// When given an input of ingredents, the Spoonacular API will return each recipe as a JSON object containing data such as name, image, etc... and
// we use this struct as an object that the data can be parsed into and accessed

import Foundation

struct Recipe: Codable, Identifiable {
    let id: Int?
    let image: String?
    let imageType: String?
    let likes, missedIngredientCount: Int?
    let missedIngredients: [Ingredient]?
    let title: String?
    let unusedIngredients: [Ingredient]?
    let usedIngredientCount: Int?
    let usedIngredients: [Ingredient]?
}

struct Ingredient: Codable, Identifiable {
    let aisle: String?
    let amount: Double?
    let id: Int?
    let image: String?
    let meta: [String]?
    let name, original, originalName, unit: String?
    let unitLong, unitShort, extendedName: String?
}
