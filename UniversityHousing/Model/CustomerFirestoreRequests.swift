//
//  CustomerFirestoreRequests.swift
//  UniversityHousing
//
//  Created by Saikiran Reddy Doddeni on 4/13/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import UIKit
import CoreLocation
import MapKit

class CustomerFireStoreRequests {
    static let shared = CustomerFireStoreRequests()
    func getAllOwners() async throws ->[String] {
        let db = Firestore.firestore()
        let ownersRef = db.collection("owners")
        var ownerId : [String] = []
        let group = DispatchGroup()
        do{
            let querySnapshot = try await ownersRef.getDocuments()
            for document in querySnapshot.documents {
                group.enter()
                ownerId.append(document.documentID)
                group.leave()
            }
            group.wait()
        }catch {
            print("Error retireiving owner id's \(error)")
        }
       return ownerId
    }
    
    func getAllProperties() async throws -> [ALlproperties]{
        let db = Firestore.firestore()
        let propRef = db.collection("propertyDetails")
        var customerPropertyDetails : [ALlproperties] = []
        let group = DispatchGroup()
        do {
            let querySnapshot = try await propRef.getDocuments()
            for document in querySnapshot.documents{
                group.enter()
                let documentData = document.data()
                print(document.data())
                let ownerRef = documentData["ownerReference"] as? DocumentReference
                print("Path is \(ownerRef?.documentID)")
                let URL = URL(string: ownerRef?.documentID ?? "nil")
                let ownerID = URL?.lastPathComponent
                let propertyImageURL = try await FirestoreRequests.shared.getPropertyImage(userID: ownerID!, proprtyID: document.documentID)
                let propertyDetails = ALlproperties(ownerID: ownerID!, propertyID: document.documentID, title: documentData["streetAddress"] as! String, propertyImageURL: propertyImageURL, bedrooms: documentData["bedrooms"] as! Int, rent: documentData["rent"] as! Int, furnished: documentData["furnished"] as! String, bathrooms: documentData["bathrooms"] as! Int, houseType: documentData["houseType"] as! String)
                customerPropertyDetails.append(propertyDetails)
                group.leave()
            }
            group.wait()
        }catch {
            print("Error Retrieving Properties")
        }
        return customerPropertyDetails
    }
    
    func getPropertyImages(ownerID: String, propertyId: String) async throws -> [URL]{
        let storageRef = Storage.storage().reference()
        let imageRef = storageRef.child("\(ownerID)/\(propertyId)")
        var downloadURLS : [URL] = []
        let group = DispatchGroup()
        do{
            let result = try await imageRef.listAll()
            for item in result.items {
                group.enter()
                let itemPath = item.fullPath
                let propertyImageRef = storageRef.child("\(itemPath)")
                let downloadURL = try await propertyImageRef.downloadURL()
                downloadURLS.append(downloadURL)
                group.leave()
            }
            group.wait()
        }
        catch{
            print("Error downloading URLs \(error)")
            throw error
        }
        return downloadURLS
    }
    
    func getPropertyDetails(propertyId : String) async throws -> CustomerPropertyDetail?{
        let db = Firestore.firestore()
        let propRef = db.collection("propertyDetails").document("\(propertyId)")
        do {
            let document = try await propRef.getDocument()
            var docData = document.data()
            docData?.removeValue(forKey: "ownerReference")
            let data = try? JSONSerialization.data(withJSONObject: docData ?? [:])
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let propDetails = try decoder.decode(CustomerPropertyDetail.self, from: data!)
            print("propdetails is \(propDetails)")
            return propDetails
        }
        catch{
            print("Error retreiving document \(error)")
            throw error
        }
    }
    func getOwnerDetails(ownerId: String) async throws -> PropertyOwnerDetails? {
        let db = Firestore.firestore()
        let ownerRef = db.collection("owner").document("\(ownerId)")
        do {
            let document = try await ownerRef.getDocument()
            let data = try? JSONSerialization.data(withJSONObject: document.data() ?? [:])
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let propOwnerDetails = try decoder.decode(PropertyOwnerDetails.self, from: data!)
            print("\(propOwnerDetails)")
            return propOwnerDetails
        }catch{
            print("Error downloading owner Details \(error)")
            throw error
        }
    }
    
    func getMapAddress(street: String, city: String, state: String, zipcode: String) async throws -> CLLocationCoordinate2D? {
        var coordinate : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
        let geocoder = CLGeocoder()
        let address = "\(street), \(city), \(state), \(zipcode), United States"
        do {
            let placemarks =  try await geocoder.geocodeAddressString(address)
            var location : CLLocation?
            if  placemarks.count > 0 {
                location = placemarks.first?.location
            }
            if let location = location {
                coordinate = location.coordinate
                print("latitude is \(coordinate.latitude)")
            }
            else{
                print("location can't be found")
            }
            return coordinate
        }catch{
            print("Error retreieving location \(error)")
            throw error
        }
    }
    
    func getCustomerDetails(userId: String) async throws -> CustomerProfile?{
        let db = Firestore.firestore()
        let customerRef = db.collection("customer").document("\(userId)")
        do {
            let document = try await customerRef.getDocument()
            let data = try? JSONSerialization.data(withJSONObject: document.data() ?? [:])
            let decoder = JSONDecoder()
            let customerDetails = try decoder.decode(CustomerProfile.self, from: data!)
            return customerDetails
        }catch{
            print("Error Retrieving Customer \(error)")
            throw error
        }
    }
    
    func uploadCustomerProfileImage(userId : String , photo : Data, completion: @escaping(Bool) -> Void){
        var isUploaded = false
        let storageRef = Storage.storage().reference().child("CustomerProfile/\(userId).jpg")
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        storageRef.putData(photo, metadata: metaData) { _, error in
            if let error = error {
                print("error uploading image: \(error)")
                completion(false)
            }
            else{
                print("uploaded data")
                completion(true)
            }
        }
    }
    
    func getCustomerImage(userId: String) async throws -> URL? {
        let storageRef = Storage.storage().reference().child("CustomerProfile/\(userId).jpg")
        do {
            let url = try await storageRef.downloadURL()
            return url
        } catch{
            print("Eroor getting image")
            return nil
        }
    }
    
}
