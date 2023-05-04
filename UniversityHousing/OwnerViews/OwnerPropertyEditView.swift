//
//  OwnerPropertyEdit.swift
//  UniversityHousing
//
//  Created by Saikiran Reddy Doddeni on 5/3/23.
//

import SwiftUI

struct OwnerPropertyEditView: View {
    @ObservedObject var ownerproperty : OwnerPropertyEdit = OwnerPropertyEdit()
    var propertyID : String
    var ownerID : String
    @State var updatedData : [String : Any] = [:]
    @State var isAlert = false
    @State var currentIndex = 0
    @State var downloadedImagesWithPath : [String : UIImage] = [:]
    @State var showImage = false
    @State var imagekey = ""
    @State var deletedImagesPaths : [String] = []
    var body: some View {
        ScrollView{
            VStack(spacing : 20) {
                VStack{
                    HStack{
                        Text("Bedrooms")
                        Spacer()
                    }
                    TextField("Bedrooms", value: $ownerproperty.bedrooms, formatter: NumberFormatter())
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 2))
                        .onChange(of: ownerproperty.bedrooms){ newValue in
                            updatedData["bedrooms"] = Int(newValue)
                        }
                }
                VStack{
                    HStack{
                        Text("Bathrooms")
                        Spacer()
                    }
                    TextField("Bathrooms", value: $ownerproperty.bathrooms, formatter : NumberFormatter())
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 2))
                        .onChange(of: ownerproperty.bathrooms){ newValue in
                            updatedData["bathrooms"] = Int(newValue)
                        }
                }
                VStack{
                    HStack{
                        Text("Rent")
                        Spacer()
                    }
                    TextField("Rent", value: $ownerproperty.rent, formatter : NumberFormatter())
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 2))
                        .onChange(of: ownerproperty.rent){ newValue in
                            updatedData["rent"] = Int(newValue)
                        }
                }
                VStack(spacing : 20) {
                    HStack {
                        Text("Furnish Status")
                        Spacer()
                        Picker("Furnish Status", selection: $ownerproperty.furnished) {
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
                        Picker("Property Type", selection: $ownerproperty.houseType) {
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
                        Picker("Pets", selection: $ownerproperty.petsAllowed) {
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
                VStack {
                    HStack{
                        Text("Your Property Images are")
                        Spacer()
                    }
                    .padding()
                    if downloadedImagesWithPath.isEmpty {
                        ProgressView()
                    }
                    else {
                        ScrollView(.horizontal){
                            HStack {
                                ForEach(Array(downloadedImagesWithPath), id: \.key){ key, value in
                                    Image(uiImage: downloadedImagesWithPath[key]!)
                                        .resizable()
                                        .frame(width: 150, height: 150)
                                        .onTapGesture {
                                            withAnimation{
                                                showImage = true
                                                imagekey = key
                                                currentIndex = Array(downloadedImagesWithPath).firstIndex(where: { $0.key == key})!
                                            }
                                        }
                                        .fullScreenCover(isPresented: $showImage, content: {
                                            FullImageForDelete(propetyId: "\(propertyID)", ownerID: "\(ownerID)", imageWithpaths: $downloadedImagesWithPath, key: $imagekey, index: $currentIndex, onDelete: { delKey in
                                                deletedImagesPaths.append(delKey)
                                            })
                                        })
                                }
                            }
                        }
                    }
                }
                
                VStack {
                    Button(action: {
                        if updatedData.isEmpty {
                           isAlert = true
                        }
                        else {
                            Task(priority: .background){
                                await FirestoreRequests.shared.editPropertyDetails(propertyId : "\(propertyID)", updateData : updatedData, deletedImages: deletedImagesPaths)
                            }
                        }
                    }, label: {
                        Text("Update Property")
                    })
                    .padding()
                    .alert(isPresented: $isAlert, content: {
                        Alert(title: Text("Alert") , message: Text("Please change the data to Update property"), dismissButton: .default(Text("OK")))
                    })
                }
            }
        }
        .padding()
        .onAppear(){
            Task(priority: .background){
                let propDetail = try await CustomerFireStoreRequests.shared.getPropertyDetails(propertyId: propertyID)
                let images = try await FirestoreRequests.shared.getImageWithId(ownerID: "\(ownerID)", propertyId: "\(propertyID)")
                DispatchQueue.main.async {
                    if let propDetail = propDetail {
                        self.ownerproperty.bedrooms = propDetail.bedrooms
                        self.ownerproperty.bathrooms = propDetail.bathrooms
                        self.ownerproperty.rent = propDetail.rent
                        self.ownerproperty.furnished = propDetail.furnished
                        self.ownerproperty.houseType = propDetail.houseType
                        self.downloadedImagesWithPath = images
                    }
                }
            }
        }
    }
}

struct OwnerPropertyEditView_Previews: PreviewProvider {
    static var previews: some View {
        OwnerPropertyEditView(propertyID: "", ownerID: "")
    }
}
