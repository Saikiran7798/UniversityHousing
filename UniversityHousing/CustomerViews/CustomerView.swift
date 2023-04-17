//
//  CustomerView.swift
//  UniversityHousing
//
//  Created by Saikiran Reddy Doddeni on 4/14/23.
//

import SwiftUI

struct CustomerView: View {
    @State var propertyDetail : [customerPropertyDetail] = []
    var body: some View {
        VStack {
            if propertyDetail.count == 0 {
                ProgressView()
            } else {
                List{
                    ForEach(propertyDetail, id: \.self) { detail in
                        NavigationLink(destination: PropertyDetailView(propertyID: detail.propertyID, ownerId: detail.ownerID), label: {
                            CustomerViewRow(url: detail.propertyImageURL, title: detail.title, bedrooms: detail.bedrooms, rent: detail.rent, furnished: detail.furnished, bathrooms: detail.bathrooms, houseType: detail.houseType)
                        })
                    }

                }
            }
        }
        .padding()
        .onAppear(){
            Task(priority: .background){
                do {
                    let propDetails = try await CustomerFireStoreRequests.shared.getAllProperties()
                    DispatchQueue.main.async {
                        self.propertyDetail = propDetails
                    }
                }
            }
        }
    }
}

struct CustomerView_Previews: PreviewProvider {
    static var previews: some View {
        CustomerView()
    }
}
