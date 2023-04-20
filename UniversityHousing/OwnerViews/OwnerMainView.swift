//
//  OwnerMainView.swift
//  UniversityHousing
//
//  Created by Saikiran Reddy Doddeni on 4/11/23.
//

import SwiftUI
import URLImage
struct OwnerMainView: View {
    @EnvironmentObject var user: UserSignin
    @State var propDetails : [OwnerPropertyDetail] = []
    @State var isAddProperty = false
    var body: some View {
        VStack {
            Text("My Properties")
                .font(.title)
            ScrollView {
                ForEach(propDetails, id: \.self) { item in
                    OwnerPropertiesView(title: item.title, url: item.propertyImageURL, bedrooms: item.bedrooms, rent: item.rent, furnished: item.furnished)
                }
            }
            .frame(height: 250)
            Spacer()
            Button("Add Property"){
                isAddProperty = true
            }
            .padding()
            .background(.blue)
            .foregroundColor(.black)
            NavigationLink(destination: AddPropertyDetails(), isActive: $isAddProperty, label: {
                EmptyView()
            })
            Spacer()
        }
        .onAppear(){
            Task(priority: .background){
                do {
                    print("userID is \(user.userId)")
                    let newpropertyDetails = try await FirestoreRequests.shared.getOwnerProperties(userID: user.userId)
                    DispatchQueue.main.async {
                        self.propDetails = newpropertyDetails
                        print("Count is \(self.propDetails.count)")
                    }
                }
            }
        }
    }
}

struct OwnerMainView_Previews: PreviewProvider {
    static var previews: some View {
        OwnerMainView()
            .environmentObject(UserSignin())
    }
}
