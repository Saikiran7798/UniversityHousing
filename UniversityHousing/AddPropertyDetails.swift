//
//  AddPropertyDetails.swift
//  UniversityHousing
//
//  Created by Saikiran Reddy Doddeni on 4/8/23.
//

import SwiftUI
import PhotosUI
import FirebaseFirestore

struct AddPropertyDetails: View {
    @EnvironmentObject var user: UserSignin
    @EnvironmentObject var propertyDetails : PropertyDetailsSignUp
    @State var selectedItem =  [PhotosPickerItem]()
    @State var selectedItemData =  [Data]()
    @State var isOwnerView = false
    @State var isprogressView = false
    var body: some View {
        if isprogressView {
            ProgressView()
        } else
        {
            ScrollView{
                Text("Add Property Details")
                    .font(.title)
                    .padding()
                VStack {
                    HStack{
                        Text("Street Address")
                        Spacer()
                    }
                    TextField("Enter Property Street Address", text: $propertyDetails.streetAddress)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 2)
                                .foregroundColor(.black))
                    HStack{
                        Text("Apt No")
                        Spacer()
                    }
                    TextField(" Enter Apt no(Optional)", text: $propertyDetails.aptNo)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 2)
                                .foregroundColor(.black))
                    HStack{
                        VStack{
                            HStack {
                                Text("City")
                                Spacer()
                            }
                            TextField(" Enter City", text: $propertyDetails.city)
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(lineWidth: 2)
                                        .foregroundColor(.black))
                        }
                        Spacer()
                        VStack{
                            HStack {
                                Text("State")
                                Spacer()
                            }
                            TextField(" Enter State", text: $propertyDetails.state)
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(lineWidth: 2)
                                        .foregroundColor(.black))
                        }
                    }
                    VStack{
                        HStack {
                            Text("Zipcode")
                            Spacer()
                        }
                        TextField(" Enter Zipcode", text: $propertyDetails.zipcode)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(lineWidth: 2)
                                    .foregroundColor(.black))
                    }
                    HStack {
                        VStack{
                            HStack{
                                Text("Bedrooms")
                                Spacer()
                            }
                            TextField(" Enter Bedrooms", value: $propertyDetails.bedrooms, formatter: NumberFormatter())
                                .keyboardType(.numberPad)
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(lineWidth: 2)
                                        .foregroundColor(.black))
                        }
                        Spacer()
                        VStack{
                            HStack{
                                Text("Bathrooms")
                                Spacer()
                            }
                            TextField(" Enter Bedrooms", value: $propertyDetails.bathrooms, formatter: NumberFormatter())
                                .keyboardType(.numberPad)
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(lineWidth: 2)
                                        .foregroundColor(.black))
                        }
                    }
                    HStack{
                        Text("Rent")
                        Spacer()
                    }
                    TextField("Enter Rent", value: $propertyDetails.rent, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 2)
                                .foregroundColor(.black))
                    VStack {
                        HStack {
                            Text("Furnish Status")
                            Spacer()
                            Picker("Furnish Status", selection: $propertyDetails.furnished) {
                                Text("Fully Furnished").tag("Fully Furnished")
                                Text("Semi Furnished").tag("Semi Furnished")
                                Text("Not Furnished").tag("Not Furnished")
                            }
                        }
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 2)
                                .foregroundColor(.black))
                        HStack {
                            Text("Property Type")
                            Spacer()
                            Picker("Property Type", selection: $propertyDetails.houseType) {
                                Text("Apartment").tag("Apartment")
                                Text("Studio").tag("Studio")
                                Text("Individual House").tag("Individual House")
                            }
                        }
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 2)
                                .foregroundColor(.black))
                        HStack {
                            Text("Pets")
                            Spacer()
                            Picker("Pets", selection: $propertyDetails.petsAllowed) {
                                Text("Yes").tag(true)
                                Text("No").tag(false)
                            }
                        }
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 2)
                                .foregroundColor(.black))
                    }
                    .pickerStyle(.menu)
                    .padding()
                }
                VStack{
                    HStack{
                        Text("Description of the Property")
                        Spacer()
                    }
                    TextField("Enter Property Description", text: $propertyDetails.description)
                        .padding()
                        .padding(.bottom, 100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 2)
                                .foregroundColor(.black))
                }
                PhotosPicker( selection: $selectedItem, matching: .images, preferredItemEncoding: .automatic, photoLibrary: .shared()){
                    Text("Select Property photos")
                        .padding()
                }
                .onChange(of: selectedItem){ newItems in
                    for item in selectedItem {
                        item.loadTransferable(type: Data.self) { result in
                            switch result {
                            case .success(let data):
                                if let data = data {
                                    self.selectedItemData.append(data)
                                }
                            case .failure(let failure):
                                print("Error \(failure.localizedDescription)")
                            }
                        }
                    }
                }
                Button("Submit") {
                    isprogressView = true
                    Task {
                        do {
                            let propID = try await FirestoreRequests.shared.uploadPropertyDetails(propetyDetails: propertyDetails, userID: user.userId, selectedDataItem: selectedItemData)
                            DispatchQueue.main.async {
                                self.propertyDetails.reset()
                                if propID {
                                    isOwnerView = true
                                    isprogressView = false
                                }
                            }
                        } catch {
                            print("Error: \(error)")
                        }
                    }
                }
                .padding()
                .background(.blue)
                .foregroundColor(.black)
                NavigationLink(destination: OwnerMainView(), isActive: $isOwnerView, label: {
                    EmptyView()
                })
                
            }
            .padding()
        }
    }
}

struct AddPropertyDetails_Previews: PreviewProvider {
    static var previews: some View {
        AddPropertyDetails()
            .environmentObject(UserSignUp())
            .environmentObject(PropertyDetailsSignUp())
            .environmentObject(OwnerDetailsSignUp())
    }
}
