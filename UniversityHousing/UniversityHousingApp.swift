//
//  UniversityHousingApp.swift
//  UniversityHousing
//
//  Created by Saikiran Reddy Doddeni on 4/2/23.
//

import SwiftUI
import FirebaseCore

@main
struct UniversityHousingApp: App {
    init(){
        FirebaseApp.configure()
    }
    @StateObject private var ownerDetails = OwnerDetailsSignUp()
    @StateObject private var user = UserSignUp()
    @StateObject private var customerDetails = CustomerDetailsSignUp()
    @StateObject private var propertyDetails = PropertyDetailsSignUp()
    @StateObject private var userSignin = UserSignin()
    var body: some Scene {
        WindowGroup {
            LoginView()
                .environmentObject(ownerDetails)
                .environmentObject(user)
                .environmentObject(customerDetails)
                .environmentObject(propertyDetails)
                .environmentObject(userSignin)
        }
    }
}
