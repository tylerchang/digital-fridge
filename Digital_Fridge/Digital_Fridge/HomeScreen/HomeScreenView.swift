//  Created by Simay Cural on 1/31/24.
//
//  This class establishes the home screen for the user to access certain views after logging in.
//  It strings together fridge, pantry, and freezer view along with the items in them.
//  This class also establishes the tabbar visible on all views for easy access to other pages.

import Foundation
import SwiftUI

struct HomeScreenView: View {
    @State var currentTab: Tab = .Fridge
    @EnvironmentObject var firebaseModel: FirebaseViewModel

    // Hide native bar
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    // Matched geometry of pop-up animation
    @Namespace var animation
    
    var body: some View {
        if let user = firebaseModel.currentUser {
            TabView(selection: $currentTab){
                VStack(){
                    HStack(spacing: 3){
                        Text("Welcome to your digital fridge, ").foregroundStyle(.secondary)
                        Text(user.fullname)
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 16))
                    FridgeInventoryView()
                    Divider()
                    FreezerInventoryView()
                    Divider()
                    PantryInventoryView()
                }.padding().tag(Tab.Fridge)
                
                ImportScreenView()
                    .tag(Tab.Import)
                
                RecipeRecommenderView()
                    .tag(Tab.Recipe)
                
                ProfileView()
                    .tag(Tab.Profile)
            }
            
            .overlay(
                HStack(spacing: 0){
                    ForEach (Tab.allCases, id: \.rawValue){ tab in
                        TabButton(tab: tab)
                    }
                    
                    .padding(.vertical)
                    .padding(.bottom, getSafeArea().bottom == 0 ? 5:
                                (getSafeArea().bottom - 15))
                    
                    .background(Color(UIColor.systemBackground))
                }
                ,
                alignment: .bottom
            ).ignoresSafeArea(.all, edges: .bottom)
        }
    }
    
    func TabButton(tab: Tab) -> some View{
        GeometryReader {proxy in
            Button(action: {
                withAnimation(.spring()) {
                    currentTab = tab
                }
            }, label: {
                
                VStack(spacing: 0){
                    Image(systemName: currentTab == tab ? tab.rawValue + ".fill" : tab.rawValue)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    
                        .foregroundColor(currentTab == tab ? .primary :
                                .secondary)
                        .padding(currentTab == tab ? 15 : 0)
                    
                        .background(ZStack {
                            if currentTab == tab {
                                MaterialEffect(style: .light)
                                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                                    .matchedGeometryEffect(id: "TAB", in: animation)

                            }
                        }
                        )
                        .contentShape(Rectangle())
                        .offset(y: currentTab == tab ? -35 :0)
                        .background(Color(UIColor.systemBackground))
                    }
                
                })
        }
        .frame(height: 25)
        }
}

struct HomeScreenView_Preview: PreviewProvider{
    static var previews: some View{
        HomeScreenView()
    }
}

// Tabbar enumeration
enum Tab: String, CaseIterable{
    case Fridge = "refrigerator"
    case Import = "camera"
    case Recipe = "carrot"
    case Profile = "person"
    
    var tabName: String{
        switch self{
        case .Fridge:
            return "Fridge"
        case .Import:
            return "Import"
        case .Profile:
            return "Profile"
        case .Recipe:
            return "Recipe"
        }
        
    }
}

// Safe area to keep tabbar icon in place
extension View{
    func getSafeArea() -> UIEdgeInsets{
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else{
            return .zero
        }
        
        guard let safeArea = screen.windows.first?.safeAreaInsets else{
            return .zero
        }
        
        return safeArea
    }
}

struct MaterialEffect: UIViewRepresentable{
    var style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        // Needed for adherring to inheritance
    }
}

