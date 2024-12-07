//  Created by Tyler  Chang on 2/13/24.
//
// This View serves as what the user will see when they actually click into a recipe from the recommendations page
// Main functionalities include a displaying a larger image, a description of the recipe, ingredients used and missing, and calling another Spoonacular API to get a quick summary of the recipe

import Foundation

import SwiftUI

struct RecipeDisplayView: View {
    
    // Setting up Spoonacular API routing to get the summary of recipe
    var recipe: Recipe
    let noImageURL = "https://previews.123rf.com/images/grgroup/grgroup1711/grgroup171100136/88886590-plate-cartoon-character.jpg"
    let spoonacularURLEndPoint = "https://api.spoonacular.com/recipes/"
    let apiKey = "cfd68829aa4a4fc0bd8b651556a2ed52"
    @State var recipeSummary = "Summary Unavailable"
    
    // Calls the API to retrieve the summary, decodes it into a RecipeSummary object, and stores it
    func getAdditionalInformation(){
        let targetURL = spoonacularURLEndPoint + "\(recipe.id ?? 0)" + "/summary?" + "&apiKey=" + apiKey
        guard let url = URL(string: targetURL) else {return}
        print("HTTP Request sent to: " + url.absoluteString)
        URLSession.shared.dataTask(with: url) {data, _, error in
            if let data = data {
                    do {
                        let decodedData = try JSONDecoder().decode(RecipeSummary.self, from: data)
                        recipeSummary = decodedData.summary ?? ""
                        print(recipeSummary)
                    } catch {
                        print(String(describing: error))
                    }
            } else if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    // UI to display recipe data, summmary, and needed and used ingredients
    var body: some View {
        
        List{
            VStack{
                Spacer()
                HStack(){
                    Spacer()
                    
                    AsyncImage(url: URL(string: recipe.image ?? noImageURL)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 200, height: 200)
                    .shadow(radius: 5)
                    
                    Spacer()
                }
                
                Text(recipe.title ?? "Recipe Title")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                
                
                if self.recipeSummary == "Summary Unavailable"{
                    ProgressView()
                }else{
                    Text(self.recipeSummary.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "")).padding(20)
                }
                
                
                Section("Using"){
                    List(recipe.usedIngredients ?? []){ingredient in
                        HStack{
                            Text(ingredient.name ?? "")
                            Spacer()
                            Text(String(ingredient.amount ?? 0.0)).foregroundStyle(.secondary)
                            Text(ingredient.unit ?? "").foregroundStyle(.secondary)
                        }
                    }
                }
                
                Section("Missing"){
                    List(recipe.missedIngredients ?? []){ingredient in
                        HStack{
                            Text(ingredient.name ?? "")
                            Spacer()
                            Text(String(ingredient.amount ?? 0.0)).foregroundStyle(.secondary)
                            Text(ingredient.unit ?? "").foregroundStyle(.secondary)
                        }
                    }
                }
                
            }.onAppear(){
                getAdditionalInformation()
            }
        }
    }
}
