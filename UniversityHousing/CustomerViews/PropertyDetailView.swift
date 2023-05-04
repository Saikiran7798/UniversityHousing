//
//  PropertyDetailView.swift
//  UniversityHousing
//
//  Created by Saikiran Reddy Doddeni on 4/16/23.
//

import SwiftUI
import MapKit

struct PropertyDetailView: View {
    var propertyID: String
    var ownerId: String
    @State var downLoadURLS : [URL] = []
    @State var propertyDetail : CustomerPropertyDetail?
    @State var ownerDetails : PropertyOwnerDetails?
    @State var location : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    @State var annotation : Place?
    @State var downloadImages : [UIImage] = []
    @State var showImage = false
    @State var count = 0
    @State var currentIndex = 0
    var body: some View {
        ScrollView{
            if downloadImages.count == 0 {
                ProgressView()
            }
            else{
                VStack(spacing: 30){
                    ScrollView(.horizontal){
                        HStack{
                            ForEach(downloadImages.indices, id: \.self) { index in
                                Image(uiImage: downloadImages[index])
                                    .resizable()
                                    .frame(width: 150, height: 150)
                                    .onTapGesture {
                                        showImage = true
                                        currentIndex = index
                                    }
                                    .fullScreenCover(isPresented: $showImage, content: {
                                        FullImage(propImage: $downloadImages, currentIndex: $currentIndex, viewType: "NoEdit" )
                                    })
                                
                            }
                        }
                    }
                    HStack(){
                        Text(propertyDetail?.streetAddress ?? "")
                            .bold()
                        Spacer()
                        Text("$\(propertyDetail?.rent ?? 0)")
                            .foregroundColor(.blue)
                            .bold()
                        Spacer()
                    }
                    HStack(spacing: 20){
                        HStack{
                            Image(systemName: "square.fill")
                                .foregroundColor(.orange)
                            Text("\(propertyDetail?.bedrooms ?? 0) Bedrooms")
                        }
                        HStack{
                            Image(systemName: "square.fill")
                                .foregroundColor(.orange)
                            Text("\(propertyDetail?.bathrooms ?? 0) Bathrooms")
                        }
                        Spacer()
                    }
                    HStack(spacing: 20){
                        HStack{
                            Image(systemName: "square.fill")
                                .foregroundColor(.orange)
                            Text("\(propertyDetail?.houseType ?? "")")
                        }
                        HStack{
                            Image(systemName: "square.fill")
                                .foregroundColor(.orange)
                            Text("\(propertyDetail?.furnished ?? "")")
                        }
                        Spacer()
                    }
                    if propertyDetail?.petsAllowed ?? false{
                        HStack{
                            Image(systemName: "square.fill")
                                .foregroundColor(.orange)
                            Text("Pets are allowed")
                                .bold()
                        }
                    }
                    else{
                        HStack{
                            Image(systemName: "square.fill")
                                .foregroundColor(.orange)
                            Text("Pets are not Allowed")
                                .bold()
                        }
                    }
                    VStack(spacing: 20){
                        Text("Property Utilities")
                            .bold()
                        ForEach(propertyDetail?.utilities ?? [], id: \.self){ item in
                            HStack{
                                Image(systemName: "square.fill")
                                    .foregroundColor(.orange)
                                Text("\(item)")
                                Spacer()
                            }
                        }
                    }
                    VStack(spacing: 20){
                        HStack{
                            Text("Owner Contact Details")
                                .bold()
                            Spacer()
                        }
                        VStack(spacing: 20){
                            HStack{
                                Text("\(ownerDetails?.firstName ?? "") \(ownerDetails?.lastName ?? "")")
                                Spacer()
                            }
                            HStack{
                                Image(systemName: "envelope")
                                Text("\(ownerDetails?.emailId ?? "")")
                                Spacer()
                            }
                            HStack{
                                Image(systemName: "phone")
                                Text("\(ownerDetails?.phoneNumber ?? "")")
                                Spacer()
                            }
                        }
                    }
                    Button(action: {
                        let appleMapsURL = URL(string: "maps://?saddr=&daddr=\(location.latitude),\(location.longitude)")
                        if let url = appleMapsURL, UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            print("Entered location")
                            } else {
                                print("Error: Invalid URL or Maps app is not installed.")
                            }
                            }) {
                                Map(coordinateRegion: $region, annotationItems: [annotation!]){ place in
                                    MapAnnotation(coordinate: place.coordinate){
                                        Image(systemName: "mappin")
                                                    .foregroundColor(.red)
                                                    .font(.title)
                                    }
                                }
                            }
                            .frame(height: 200)
                    Spacer()
                }
            }
        }
        .padding()
        .onAppear(){
            Task(priority: .background){
                do{
                    //let downloadURlS = try await CustomerFireStoreRequests.shared.getPropertyImages(ownerID: ownerId, propertyId: propertyID)
                    let downLoadImages = try await CustomerFireStoreRequests.shared.getImage(ownerID: ownerId, propertyId: propertyID)
                    let propDetail = try await CustomerFireStoreRequests.shared.getPropertyDetails(propertyId: propertyID)
                    let ownerDetails = try await CustomerFireStoreRequests.shared.getOwnerDetails(ownerId: ownerId)
                    //let loc = try await CustomerFireStoreRequests.shared.getMapAddress(street: propDetail?.streetAddress ?? "", city: propDetail?.city ?? "", state: propDetail?.state ?? "")
                    let loc = await CustomerFireStoreRequests.shared.getPropertyLocation(propertyId: "\(propertyID)")
                    DispatchQueue.main.async {
                        //self.downLoadURLS = downloadURlS
                        self.downloadImages = downLoadImages
                        //self.showImage = Array(repeating: false, count: downLoadImages.count)
                        if let propDetail = propDetail {
                            self.propertyDetail = propDetail
                        }
                        if let ownerDetail = ownerDetails{
                            self.ownerDetails = ownerDetail
                        }
                        if let geoLoc = loc {
                            self.location = CLLocationCoordinate2D(latitude: geoLoc.latitude, longitude: geoLoc.longitude)
                            self.region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
                            self.annotation = Place(name: propDetail?.streetAddress ?? "", coordinate: location)
                        }
                    }
                }
                catch{
                    print("Download Images failed")
                }
            }
        }
    }
}

struct PropertyDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PropertyDetailView(propertyID: "", ownerId: "")
    }
}
