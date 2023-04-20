//
//  ProfileView.swift
//  UniversityHousing
//
//  Created by Saikiran Reddy Doddeni on 4/19/23.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var user : UserSignin
    @State var customerDetails : CustomerProfile?
    @State var isLoginView = false
    var body: some View {
        VStack(spacing: 10){
            Image(systemName: "photo")
                .resizable()
                .frame(width: 200, height: 200)
                .clipShape(Circle())
                .padding(.bottom, 50)
                .padding(.top, 80)
            HStack{
                Text("Name: \(customerDetails?.firstName ?? "") \(customerDetails?.firstName ?? "")")
                Spacer()
            }
            .padding()
            HStack{
                Text("EmailId: \(customerDetails?.emailId ?? "")")
                Spacer()
            }
            .padding()
            HStack{
                Text("Phone Number: \(customerDetails?.phoneNumber ?? "")")
                Spacer()
            }
            .padding()
            Button("Sign Out") {
                user.reset()
                isLoginView = true
            }
            .foregroundColor(.blue)
            .padding()
            NavigationLink(destination: LoginView(), isActive: $isLoginView) {
                EmptyView()
            }
            Spacer()
        }
        .onAppear(){
            /*Task(priority: .background){
                do{
                    let profile = try await CustomerFireStoreRequests.shared.getCustomerDetails(userId: user.userId)
                    DispatchQueue.main.async {
                        self.customerDetails = profile!
                    }
                }catch{
                    print("Error")
                }
            }*/
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(UserSignin())
    }
}
