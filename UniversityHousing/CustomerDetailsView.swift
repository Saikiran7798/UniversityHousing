//
//  CustomerDetailsView.swift
//  UniversityHousing
//
//  Created by Saikiran Reddy Doddeni on 4/4/23.
//

import SwiftUI

struct CustomerDetailsView: View {
    @EnvironmentObject var customerDetails : CustomerDetails
    @EnvironmentObject var user : User
    @State var isThankyouView = false
    var body: some View {
            VStack(spacing: 10){
                TextField("Enter First Name", text: $customerDetails.firstName)
                    .padding()
                    .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.black))
                TextField("Enter Last Name", text: $customerDetails.lastName)
                    .padding()
                    .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.black))
                TextField("Enter Phone Number", text: $customerDetails.phoneNumber)
                    .padding()
                    .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.black))
                Button("Next"){
                    FirestoreRequests.shared.customerDetailsSignup(customerDetails: customerDetails, userID: user.userId)
                    isThankyouView = true
                }
                .padding()
                .background(.blue)
                .foregroundColor(.black)
                NavigationLink(destination: ThankyouView(), isActive: $isThankyouView, label: {
                    EmptyView()
                })
            }
            .padding()
            .navigationBarBackButtonHidden(true)
    }
}

struct CustomerDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        CustomerDetailsView()
            .environmentObject(CustomerDetails())
            .environmentObject(User())
    }
}
