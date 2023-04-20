//
//  CustomerView.swift
//  UniversityHousing
//
//  Created by Saikiran Reddy Doddeni on 4/14/23.
//

import SwiftUI

struct CustomerView: View {
    @State var propertyDetail : [ALlproperties] = []
    @State var allProperties : [ALlproperties] = []
    @EnvironmentObject var filter : Filters
    @State var isFilter = false
    @State var search = ""
    var body: some View {
        VStack {
            HStack{
                SearchBar(searchText: $search)
                NavigationLink(destination: ProfileView()){
                    Image(systemName: "photo")
                        .clipShape(Circle())
                }
            }
            HStack{
                Button("Filter"){
                    isFilter = true
                }
                .fullScreenCover(isPresented: $isFilter, onDismiss: {
                    if filter.dismissAction == "Apply" {
                        propertyDetail = allProperties
                        propertyFilters(filter: filter)
                    }
                    if filter.dismissAction == "Reset" {
                        propertyDetail = allProperties
                    }
                }){
                    FiltersView()
                }
                .frame(width: 50, height: 5)
                .padding()
                .background(.blue)
                .foregroundColor(.black)
                Spacer()
            }
            if propertyDetail.count == 0  && allProperties.count == 0 {
                Spacer()
                ProgressView()
                Spacer()
            }
            else if propertyDetail.count == 0 && allProperties.count != 0 {
                Spacer()
                Text("No properties matching given filters")
                    .bold()
                Spacer()
            }
            else{
                ScrollView{
                    ForEach(propertyDetail.filter({search.isEmpty ? true : $0.title.localizedCaseInsensitiveContains(search)}), id: \.self) { detail in
                        NavigationLink(destination: PropertyDetailView(propertyID: detail.propertyID, ownerId: detail.ownerID), label: {
                            CustomerViewRow(url: detail.propertyImageURL, title: detail.title, bedrooms: detail.bedrooms, rent: detail.rent, furnished: detail.furnished, bathrooms: detail.bathrooms, houseType: detail.houseType)
                        })
                    }
                    
                }
            }
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .onAppear(){
            Task(priority: .background){
                do {
                    let propDetails = try await CustomerFireStoreRequests.shared.getAllProperties()
                    DispatchQueue.main.async {
                        self.propertyDetail = propDetails
                        self.allProperties = propDetails
                    }
                }
            }
        }
    }
    
    func propertyFilters(filter: Filters){
        if filter.bathroomsFilter.count != 0 || filter.bedroomsFilter.count != 0 || filter.minRent != 0 || filter.maxRent != 0 {
            if filter.bathroomsFilter.count != 0 {
                for property in propertyDetail {
                    if property.bathrooms < 5 {
                        if !filter.bathroomsFilter.contains("\(property.bathrooms)") {
                            let index = propertyDetail.firstIndex(of: property)
                            propertyDetail.remove(at: index!)
                        }
                    } else {
                        if !filter.bathroomsFilter.contains("4") {
                            let index = propertyDetail.firstIndex(of: property)
                            propertyDetail.remove(at: index!)
                        }
                    }
                }
            }
            if filter.bedroomsFilter.count != 0 {
                for property in propertyDetail {
                    if property.bedrooms < 5 {
                        if !filter.bedroomsFilter.contains("\(property.bedrooms)") {
                            let index = propertyDetail.firstIndex(of: property)
                            propertyDetail.remove(at: index!)
                        }
                    } else {
                        if !filter.bedroomsFilter.contains("4") {
                            let index = propertyDetail.firstIndex(of: property)
                            propertyDetail.remove(at: index!)
                        }
                    }
                }
            }
            if filter.minRent > 0 || filter.maxRent > 0 {
                for property in propertyDetail {
                    if !(property.rent >= filter.minRent && property.rent <= filter.maxRent) {
                        let index = propertyDetail.firstIndex(of: property)
                        propertyDetail.remove(at: index!)
                    }
                }
            }
        } else {
            propertyDetail = allProperties
        }
    }
}

struct CustomerView_Previews: PreviewProvider {
    static var previews: some View {
        CustomerView()
            .environmentObject(Filters())
    }
}
