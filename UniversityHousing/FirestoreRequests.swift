//
//  FirestoreRequests.swift
//  UniversityHousing
//
//  Created by Saikiran Reddy Doddeni on 4/2/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Firebase


class FirestoreRequests {
    static let shared = FirestoreRequests()
    
    func userSignUP(emailId: String, password: String, userType : String, completion: @escaping(String) -> Void) {
        
        Auth.auth().createUser(withEmail: emailId, password: password) { result,error in
            
            guard let user = result?.user, error == nil else {
                print("Error creating User")
                return
            }
            completion(user.uid)
            print("Entered..")
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
 
    func userSignIn(emailId: String, password: String, completion:  @escaping(String) -> Void){
        Auth.auth().signIn(withEmail: emailId, password: password) { result,error  in
            guard let user = result?.user, error == nil else {
                print("Error while creasting user")
                return
            }
            print("logging in")
            if user.displayName == "Customer" {
                print("Entered Customer")
                completion("Customer")
            }
            else{
                print("Entered Owner")
                completion("Owner")
            }
            
        }
    }
    
    func ownerDetailsSignup(ownerDetails: OwnerDetails, userID: String){
        
        let db = Firestore.firestore()
        db.collection("owner").document(userID).setData(ownerDetails.toDictionary()){error in
            guard error == nil else {
                print("Error signing up owner details \(error)")
                return
            }
            
        }
        
    }
    
    func customerDetailsSignup(customerDetails: CustomerDetails, userID: String){
        
        let db = Firestore.firestore()
        db.collection("customer").document(userID).setData(customerDetails.toDictionary()){error in
            guard error == nil else {
                print("Error signing up owner details \(error)")
                return
            }
            
        }
    }
}

