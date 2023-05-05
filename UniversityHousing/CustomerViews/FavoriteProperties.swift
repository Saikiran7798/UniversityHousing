//
//  FavoriteProperties.swift
//  UniversityHousing
//
//  Created by Saikiran Reddy Doddeni on 5/4/23.
//

import SwiftUI

struct FavoriteProperties: View {
    @State var propertyDetail : [ALlproperties] = []
    @EnvironmentObject var userSignIn : UserSignin
    @Binding var presentSideMenu : Bool
    @State var search = ""
    var body: some View {
        VStack{
            HStack{
                Button(action: {
                    presentSideMenu.toggle()
                }, label: {
                    Image(systemName: "line.3.horizontal")
                })
                SearchBar(searchText: $search)
            }
            if propertyDetail.count == 0 {
                Spacer()
                VStack {
                    Text("You have no Favorite Properties")
                }
                Spacer()
            } else {
                ScrollView{
                    ForEach(propertyDetail.filter({search.isEmpty ? true : $0.title.localizedCaseInsensitiveContains(search)}), id: \.self) { detail in
                        CustomerViewRow(url: detail.propertyImageURL, title: detail.title, bedrooms: detail.bedrooms, rent: detail.rent, furnished: detail.furnished, bathrooms: detail.bathrooms, houseType: detail.houseType, propertyID: detail.propertyID, ownerID: detail.ownerID, userID: "\(userSignIn.userId)")
                    }
                    
                }
                .padding()
            }
        }
        .padding()
        .onAppear(){
            Task(priority: .background){
                let propes = await CustomerFireStoreRequests.shared.getFavProperties(userID: userSignIn.userId)
                DispatchQueue.main.async {
                    self.propertyDetail = propes
                }
            }
        }
    }
}

struct FavoriteProperties_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteProperties(presentSideMenu: Binding.constant(false))
            .environmentObject(UserSignin())
    }
}
