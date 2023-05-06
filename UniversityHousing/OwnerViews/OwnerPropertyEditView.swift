//
//  OwnerPropertyEdit.swift
//  UniversityHousing
//
//  Created by Saikiran Reddy Doddeni on 5/3/23.
//

import SwiftUI
import PhotosUI

struct OwnerPropertyEditView: View {
    @State var ownerproperty : OwnerPropertyEdit = OwnerPropertyEdit()
    var propertyID : String
    var ownerID : String
    @State var updatedData : [String : Any] = [:]
    @State var isAlert = false
    @State var currentIndex = 0
    @State var downloadedImagesWithPath : [String : UIImage] = [:]
    @State var showImage = false
    @State var imagekey = ""
    @State var deletedImagesPaths : [String] = []
    @State var photoPickerItem = [PhotosPickerItem]()
    @State var photoPickerData = [Data]()
    @State var newImages : [UIImage] = []
    @State var deletedImagesCount = 0
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
                        .onChange(of: ownerproperty.furnished){ newValue in
                            updatedData["furnished"] = newValue
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
                        .onChange(of: ownerproperty.houseType){ newValue in
                            updatedData["houseType"] = newValue
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
                        .onChange(of: ownerproperty.petsAllowed){ newValue in
                            updatedData["petsAllowed"] = newValue
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
                
                VStack{
                    PhotosPicker(selection: $photoPickerItem, matching: .images) {
                        Text("Select new Images to upload")
                    }
                    .onChange(of: photoPickerItem){ _ in
                        photoPickerData.removeAll()
                        newImages.removeAll()
                        for item in photoPickerItem {
                            item.loadTransferable(type: Data.self){ result in
                                switch result {
                                case .success(let data):
                                    if let data = data {
                                        photoPickerData.append(data)
                                        newImages.append(UIImage(data: data)!)
                                    }
                                case .failure(let error):
                                    print("failed \(error.localizedDescription)")
                                }
                            }
                        }
                    }
                }
                if newImages.count != 0 {
                    Text("Newly Added Images")
                    ScrollView(.horizontal){
                        HStack {
                            ForEach(newImages, id: \.self){ item in
                                Image(uiImage: item)
                                    .resizable()
                                    .frame(width: 150, height: 150)
                            }
                        }
                    }
                }
                VStack {
                    Button(action: {
                        if updatedData.isEmpty && newImages.count == 0 {
                           isAlert = true
                        }
                        else {
                            print("entered")
                            Task(priority: .background){
                                await FirestoreRequests.shared.editPropertyDetails(propertyId : "\(propertyID)", updateData : updatedData, deletedImages: deletedImagesPaths)
                                if newImages.count != 0 {
                                    await FirestoreRequests.shared.uploadNewImages(ownerID: "\(ownerID)", propertyId: "\(propertyID)", imageItems: photoPickerData)
                                }
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
                        self.deletedImagesCount = downloadedImagesWithPath.count
                        print("count is \(deletedImagesCount)")
                        print("download count is \(downloadedImagesWithPath.count)")
                        print("count of dict is \(updatedData.count)")
                        self.updatedData = [:]
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
