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
    
    func getAllProperties() async throws -> [customerPropertyDetail]{
        let db = Firestore.firestore()
        let propRef = db.collection("propertyDetails")
        var customerPropertyDetails : [customerPropertyDetail] = []
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
                let propertyDetails = customerPropertyDetail(ownerID: ownerID!, propertyID: document.documentID, title: documentData["streetAddress"] as! String, propertyImageURL: propertyImageURL, bedrooms: documentData["bedrooms"] as! Int, rent: documentData["rent"] as! Int, furnished: documentData["furnished"] as! String, bathrooms: documentData["bathrooms"] as! Int, houseType: documentData["houseType"] as! String)
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
    
}
