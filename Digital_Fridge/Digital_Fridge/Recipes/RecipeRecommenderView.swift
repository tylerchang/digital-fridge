import SwiftUI

// This view serves as the page that displays recipes that could be made based on what is in the user's inventory
// The recipes are retrieved from the Spoonacular API which takes in an input of the user's ingredients and returns doable recipes

struct RecipeRecommenderView: View {
    
    @EnvironmentObject var firebaseModel: FirebaseViewModel
    @State var listOfIngredients: [Food]
    @State var listOfRecipes: [Recipe]
    
    // Setting up the API path
    let spoonacularURLEndPoint = "https://api.spoonacular.com/recipes/findByIngredients?ingredients="
    let apiKey = "cfd68829aa4a4fc0bd8b651556a2ed52"
    let numberOfRecipesToShow = "10"

    
    init(){
        self.listOfIngredients = []
        self.listOfRecipes = []
    }
    
    // Populates the list of ingredients that the user has by retriveving from Firebase, sends it to Spoonacular, and adds the returned recipes to the list of recipes
    func getRecipes(){
        self.listOfIngredients = []
        self.listOfRecipes = []
        
        var allIngredientsAsString = ""
        
        // Fetching all inventory items
        firebaseModel.fetchFoodFromFridge()
        firebaseModel.fetchFoodFromPantry()
        firebaseModel.fetchFoodFromFreezer()
        
        for item in firebaseModel.foodInFridge{
            self.listOfIngredients.append(item)
            allIngredientsAsString += item.productName + ","
        }
        for item in firebaseModel.foodInFreezer{
            self.listOfIngredients.append(item)
            allIngredientsAsString += item.productName + ","
        }
        for item in firebaseModel.foodInPantry{
            self.listOfIngredients.append(item)
            allIngredientsAsString += item.productName + ","
        }
        
        if allIngredientsAsString.last! == ","{
            allIngredientsAsString.remove(at: allIngredientsAsString.index(before: allIngredientsAsString.endIndex))
        }
        
        // API call to Spoonacular, decodes response of recipes into a Recipe object, and adds it to the list of recipes
        let targetURL = spoonacularURLEndPoint + allIngredientsAsString + "&number=" + numberOfRecipesToShow + "&apiKey=" + apiKey
        guard let url = URL(string: targetURL) else {return}
        print("HTTP Request sent to: " + url.absoluteString)
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                    do {
                        let decodedData = try JSONDecoder().decode([Recipe].self, from: data)
                        for recipe in decodedData{
                            self.listOfRecipes.append(recipe)
                        }
                    } catch {
                        print(String(describing: error))
                    }
            } else if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
            }
        }.resume()

}
    
    // UI to display the recipes which calls the above functionalities when first appearing
    var body: some View {
        VStack{
            NavigationStack {
                if self.listOfRecipes.isEmpty{
                    ProgressView{
                        Image(systemName: "refrigerator").resizable().frame(width:50, height: 70).tint(.cyan)
                    }.tint(.cyan).controlSize(.large)
                }else{
                    Text("Swipe Up To Refresh").foregroundStyle(.secondary)
                    List(self.listOfRecipes) {recipe in
                        NavigationLink {
                            RecipeDisplayView(recipe: recipe)
                        } label: {
                            VStack{
                                HStack{
                                    Text(recipe.title ?? "Recipe Title").fontWeight(.bold)
                                    
                                    Spacer()
                                    
                                    AsyncImage(url: URL(string: recipe.image ?? "https://previews.123rf.com/images/grgroup/grgroup1711/grgroup171100136/88886590-plate-cartoon-character.jpg")) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .frame(width: 70, height: 70)
                                    .background(Color.gray)
                                    .clipShape(Circle())
                                    .shadow(radius: 5)
                                }
                            }
                        }
                    }
                    .navigationTitle("Recipes").refreshable {
                        getRecipes()
                    }
                }
            }
        }.onAppear(){
            UIRefreshControl.appearance().tintColor = .blue
            getRecipes()
        }
    }
    
}
