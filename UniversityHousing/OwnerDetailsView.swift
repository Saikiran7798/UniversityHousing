//
//  OwnerDetailsView.swift
//  UniversityHousing
//
//  Created by Saikiran Reddy Doddeni on 4/4/23.
//

import SwiftUI

struct OwnerDetailsView: View {
    @EnvironmentObject var ownerDetails : OwnerDetails
    @EnvironmentObject var user: User
    @Environment(\.presentationMode) var presentationMode
    @State var isthankYouView = false
    var body: some View {
            VStack(spacing: 10){
                TextField("Enter First Name", text: $ownerDetails.firstName)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 2)
                            .foregroundColor(.black))
                TextField("Enter Last Name", text: $ownerDetails.lastName)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 2)
                            .foregroundColor(.black))
                TextField("Enter Phone Number", text: $ownerDetails.phoneNumber)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 2)
                            .foregroundColor(.black))
                HStack{
                    Text("Address")
                    Spacer()
                }
                TextField("Enter Street Address", text: $ownerDetails.street)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 2)
                            .foregroundColor(.black))
                HStack{
                    Text("Apt no")
                    Spacer()
                }
                TextField("Enter Apt no", text: $ownerDetails.aptNo)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 2)
                            .foregroundColor(.black))
                HStack{
                    VStack {
                        Text("City")
                        TextField("Enter City", text: $ownerDetails.city)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(lineWidth: 2)
                                    .foregroundColor(.black))
                    }
                    VStack {
                        Text("State")
                        TextField("Enter State", text: $ownerDetails.state)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(lineWidth: 2)
                                    .foregroundColor(.black))
                    }
                    VStack {
                        Text("Zipcode")
                        TextField("Enter Zipcode", text: $ownerDetails.zipcode)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(lineWidth: 2)
                                    .foregroundColor(.black))
                    }
                }
                Button("Next"){
                    FirestoreRequests.shared.ownerDetailsSignup(ownerDetails: ownerDetails, userID: user.userId)
                    print("Value of user is \(user.userId)")
                            isthankYouView = true
                }
                .padding()
                .background(.blue)
                .foregroundColor(.black)
                NavigationLink(destination: ThankyouView(), isActive : $isthankYouView){
                        Text("").hidden()
                }
            }
            .padding()
            .navigationBarBackButtonHidden(true)
    }
}

struct OwnerDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        OwnerDetailsView().environmentObject(OwnerDetails())
            .environmentObject(User())
    }
}
