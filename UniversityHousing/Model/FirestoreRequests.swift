//
//  FirestoreRequests.swift
//  UniversityHousing
//
//  Created by Saikiran Reddy Doddeni on 4/2/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import UIKit


class FirestoreRequests {
    static let shared = FirestoreRequests()
    
    func userSignUP(emailId: String, password: String, userType : String, completion: @escaping(String, String) -> Void) {
        
        Auth.auth().createUser(withEmail: emailId, password: password) { result,error in
            
            guard let user = result?.user, error == nil else {
                print("Error creating User")
                return
            }
            completion(user.uid, user.email!)
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = userType
            changeRequest.commitChanges(completion: { error in
                if (error != nil) {
                    print("Error while setting display name")
                }
                else
                {
                    print("Success...")
                }
            })
        }
    }
    func userSignIn(emailId: String, password: String) async throws -> (String, String){
        var usertype = ""
        var userID = ""
        do {
            let user: AuthDataResult? = try await Auth.auth().signIn(withEmail: emailId, password: password)
            if user?.user.displayName == "Customer" {
                usertype = "Customer"
                userID = user!.user.uid
            }
            else {
                usertype = "Owner"
                userID = user!.user.uid
            }
            
        } catch let error as NSError {
            let authError = error as? AuthErrorCode
            print("Error while signing in \(authError)")
        }
        return (usertype, userID)
    }
    
    func ownerDetailsSignup(ownerDetails: OwnerDetailsSignUp, userID: String){
        
        let db = Firestore.firestore()
        db.collection("owner").document(userID).setData(ownerDetails.toDictionary()){error in
            guard error == nil else {
                print("Error signing up owner details \(error)")
                return
            }
            
        }
        ownerDetails.reset()
        
    }
    
    func customerDetailsSignup(customerDetails: CustomerDetailsSignUp, userID: String){
        
        let db = Firestore.firestore()
        db.collection("customer").document(userID).setData(customerDetails.toDictionary()){error in
            guard error == nil else {
                print("Error signing up owner details \(error)")
                return
            }
            
        }
        customerDetails.reset()
    }
    
    func uploadPropertyDetails(propetyDetails : PropertyDetailsSignUp, userID: String, selectedDataItem: [Data]) async throws -> Bool{
        let db = Firestore.firestore()
        propetyDetails.ownerReference = db.collection("owner").document(userID)
        let propertyRef = db.collection("propertyDetails").document()
        let propId = propertyRef.documentID
        print("New propertyID added is \(propId)")
        try await propertyRef.setData(propetyDetails.toDictionary())
        var count = 0
        let dispatchGroup = DispatchGroup()
        for item in selectedDataItem {
            let storageRef = Storage.storage().reference().child("\(userID)/\(propId)/\(UUID().uuidString).jpg")
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            dispatchGroup.enter()
            storageRef.putData(item, metadata: metaData) { _, error in
                if let error = error {
                    print("error uploading image: \(error)")
                } else {
                    count += 1
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.wait() // Wait for all the upload tasks to complete
        if count == selectedDataItem.count {
            print("count is \(count)")
            return true
        } else {
            print("count is \(count)")
            return false
        }
    }
    func getOwnerProperties(userID: String) async throws -> [OwnerPropertyDetail] {
        let db = Firestore.firestore()
        let ownerRef = db.collection("owner").document(userID)
        var propertyDetailArray : [OwnerPropertyDetail] = []
        do {
            let snapshot = try await db.collection("propertyDetails").whereField("ownerReference", isEqualTo: ownerRef).getDocuments()
            for document in snapshot.documents {
                let data = document.data()
                let url = try await self.getPropertyImage(userID: userID, proprtyID: document.documentID)
                let newPropertyDetail = OwnerPropertyDetail(propertyID: document.documentID, title: data["streetAddress"] as? String ?? "nil", propertyImageURL: url,
                                                       bedrooms: data["bedrooms"] as? Int ?? 0, rent: data["rent"] as? Int ?? 0, furnished : data["furnished"] as? String ?? "nil")
                propertyDetailArray.append(newPropertyDetail)
            }
            
        } catch {
            print("Error retrieving properties \(error)")
        }
        print("property Araay count is \(propertyDetailArray.count)")
        return propertyDetailArray
    }
    
    func getPropertyImage(userID: String, proprtyID: String)async throws -> URL {
        let storageRef = Storage.storage().reference()
        let imageRef = storageRef.child("\(userID)/\(proprtyID)")
        print("property id is \(imageRef.fullPath)")
        var downloadURL : URL?
        do {
            let result =  try await imageRef.listAll()
            let item = result.items.first
            let path = item?.fullPath ?? "nil"
            print("Item path is \(path)")
            let propertyImageRef = storageRef.child("\(path)")
            let url = try await propertyImageRef.downloadURL()
            downloadURL = url
        } catch {
            print("Error in getting images \(error)")
        }
        return downloadURL!
    }
    
    func getOwnerDetails(userId: String) async throws -> OwnerProfileDetails?{
        let db = Firestore.firestore()
        let ownerRef = db.collection("owner").document("\(userId)")
        do {
            let document = try await ownerRef.getDocument()
            let data = try? JSONSerialization.data(withJSONObject: document.data() ?? [:])
            let decoder = JSONDecoder()
            let ownerDetails = try decoder.decode(OwnerProfileDetails.self, from: data!)
            return ownerDetails
        }catch{
            print("Error Retrieving Customer \(error)")
            throw error
        }
    }
    
    func uploadOwnerProfileImage(userId : String , photo : Data, completion: @escaping(Bool) -> Void){
        var isUploaded = false
        let storageRef = Storage.storage().reference().child("OwnerProfile/\(userId).jpg")
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
    
    func getOwnerImage(userId: String) async throws -> URL? {
        let storageRef = Storage.storage().reference().child("OwnerProfile/\(userId).jpg")
        do {
            let url = try await storageRef.downloadURL()
            return url
        } catch{
            print("Eroor getting image")
            return nil
        }
    }

}

