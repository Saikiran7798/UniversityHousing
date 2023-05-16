//
//  AddPropertyDetails.swift
//  UniversityHousing
//
//  Created by Saikiran Reddy Doddeni on 4/8/23.
//

import SwiftUI
import PhotosUI
import FirebaseFirestore
import MapKit
import CoreLocation
import UIKit

struct AddPropertyDetails: View {
    @EnvironmentObject var user: UserSignin
    @EnvironmentObject var propertyDetails : PropertyDetailsSignUp
    @State var selectedItem =  [PhotosPickerItem]()
    @State var selectedItemData =  [Data]()
    @State var selectedImages : [UIImage] = []
    @State var isOwnerView = false
    @State var isprogressView = false
    @State var utiliTiesArray : [String] = [""]
    @ObservedObject var localSearchCompleter = LocalSearch()
    @State var searchResults : [MKLocalSearchCompletion] = []
    @State var showScrollView = false
    @State var isAlert = false
    @State var distance = 0.0
    @State var isAddRemove : [Bool] = [true]
    @State var isOntapGesture = false
    @State var oldStreetValue = ""
    @State var isButtonDiabled = true
    @State var isAddressError = true
    @State var isAddressAlert = false
    @State var isSelectedImages = false
    @State var finalAlert = false
    var body: some View {
        if isprogressView {
            ProgressView()
        } else
        {
            ScrollView{
                VStack{
                    
                }
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
                        .onChange(of: propertyDetails.streetAddress){ newValue in
                            if !newValue.isEmpty {
                                print("value is \(newValue)")
                                withAnimation(.easeInOut(duration: 0.7)){
                                    if isOntapGesture, oldStreetValue == newValue {
                                        showScrollView = false
                                    }
                                    else {
                                        isAddressError = true
                                        showScrollView = true
                                    }
                                }
                                localSearchCompleter.search(query: newValue)
                                searchResults = localSearchCompleter.searchResults
                            }
                            else {
                                searchResults.removeAll()
                                withAnimation(.easeInOut(duration: 1.0)){
                                    isAddressError = true
                                    showScrollView = false
                                }
                            }
                        }
                    if showScrollView {
                        ScrollView{
                            VStack(spacing: 20){
                                ForEach(searchResults, id: \.self){ result in
                                    HStack{
                                        Text("\(result.title), \(result.subtitle)")
                                            .onTapGesture {
                                                propertyDetails.streetAddress = result.title
                                                let subString = result.subtitle.components(separatedBy: ",")
                                                propertyDetails.city = subString[0]
                                                propertyDetails.state = subString[1]
                                                searchResults = []
                                                isOntapGesture = true
                                                isAddressError = false
                                                oldStreetValue = propertyDetails.streetAddress
                                                Task(priority: .background){
                                                    do {
                                                        let loc =  try await CustomerFireStoreRequests.shared.getMapAddress(street: result.title, city: subString[0], state: subString[1])
                                                        if let loc = loc {
                                                            let clLoc = CLLocation(latitude: loc.latitude, longitude: loc.longitude)
                                                            let zip = await CustomerFireStoreRequests.shared.ReverseGeoCode(location: clLoc)
                                                            DispatchQueue.main.async {
                                                                propertyDetails.zipcode = zip
                                                                propertyDetails.location = GeoPoint(latitude: loc.latitude, longitude: loc.longitude)
                                                            }
                                                        }
                                                    } catch {
                                                        print("Couldn't get location")
                                                    }
                                                }
                                            }
                                        Spacer()
                                    }
                                    .padding(.leading, 10)
                                }
                            }
                        }
                        .frame(height: 150)
                        .frame(maxWidth: .infinity)
                    }
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
                }
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
                VStack{
                    HStack{
                        Text("Please Enter  Property Utilities")
                        Spacer()
                    }
                    ForEach(utiliTiesArray.indices, id:\.self){ index in
                        HStack{
                            TextField("Enter Property Utilities", text: $utiliTiesArray[index])
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(lineWidth: 2)
                                        .foregroundColor(.black))
                            if utiliTiesArray[index] != "" {
                                if isAddRemove[index] {
                                    Button(action: {
                                        isAddRemove[index] = false
                                        isAddRemove.append(true)
                                        utiliTiesArray.append("")
                                        propertyDetails.utilities.append(utiliTiesArray[index])
                                    }, label: {
                                        Text("Add")
                                    })
                                } else {
                                    Button(action: {
                                        isAddRemove.remove(at: index)
                                        utiliTiesArray.remove(at: index)
                                        propertyDetails.utilities.remove(at: index)
                                    }, label: {
                                        Text("remove")
                                    })
                                }
                            }
                        }
                    }
                }
                PhotosPicker( selection: $selectedItem, matching: .images, preferredItemEncoding: .automatic, photoLibrary: .shared()){
                    Text("Select Property photos")
                        .padding()
                }
                .onChange(of: selectedItem){ newItems in
                    selectedItemData.removeAll()
                    selectedImages.removeAll()
                    for item in selectedItem {
                        item.loadTransferable(type: Data.self) { result in
                            switch result {
                            case .success(let data):
                                if let data = data {
                                    self.selectedItemData.append(data)
                                    self.selectedImages.append(UIImage(data: data)!)
                                }
                            case .failure(let failure):
                                print("Error \(failure.localizedDescription)")
                            }
                        }
                    }
                }
                if selectedImages.count != 0 {
                    ScrollView(.horizontal){
                        HStack{
                            ForEach(selectedImages, id: \.self){ item in
                                Image(uiImage: item)
                                    .resizable()
                                    .frame(width: 100, height: 100)
                            }
                        }
                    }
                }
                Button("Submit") {
                    let syrcLoc = CLLocation(latitude: 43.0389, longitude: -76.1341)
                    let propLoc = CLLocation(latitude: propertyDetails.location.latitude, longitude: propertyDetails.location.longitude)
                    let distance = syrcLoc.distance(from: propLoc) * 0.000621371
                    self.distance = distance
                    if distance > 10 {
                        print("entered distance")
                        isAlert = true
                    }
                    else {
                        isAlert = false
                    }
                    if selectedImages.count == 0{
                        isSelectedImages = true
                    }
                    else {
                        isSelectedImages = false
                    }
                    if isAddressError {
                        print("Entered add error")
                        isAddressAlert = true
                    }
                    else {
                        isAddressAlert = false
                    }
                    if isAlert || isSelectedImages || isAddressAlert {
                        finalAlert = true
                    }
                    else {
                        finalAlert = false
                    }
                     if !isAlert && !isSelectedImages && !isAddressError {
                         print("Entered task")
                        isprogressView = true
                        Task {
                            do {
                                let propID = try await FirestoreRequests.shared.uploadPropertyDetails(propetyDetails: propertyDetails, userID: user.userId, selectedDataItem: selectedItemData)
                                DispatchQueue.main.async {
                                    self.propertyDetails.reset()
                                    if propID {
                                        isprogressView = false
                                        isOwnerView = true
                                    }
                                }
                            } catch {
                                print("Error: \(error)")
                            }
                        }
                    }
                }
                .alert(isPresented: $finalAlert, content: {
                    Alert(title: Text("Alert"), message: Text(" Please make sure that Your Property Distance is less than 10 miles from Syracuse University and make sure to select address from the list and make sure to select atleatst one image").foregroundColor(.red), dismissButton: .default(Text("OK")))
                        
                })
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
