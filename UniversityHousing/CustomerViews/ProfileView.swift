//
//  ProfileView.swift
//  UniversityHousing
//
//  Created by Saikiran Reddy Doddeni on 4/19/23.
//

import SwiftUI
import UIKit
import PhotosUI

struct ProfileView: View {
    @EnvironmentObject var user : UserSignin
    @State var customerDetails : CustomerProfile?
    @State var isLoginView = false
    @State var url : URL?
    @State var isProfileImage = false
    var body: some View {
        VStack(spacing: 10){
            AsyncImage(url: url){ path in
                switch path {
                case .success(let image):
                    NavigationLink(destination: ProfileImage(image: image), label: {
                        image
                            .resizable()
                            .frame(width: 250, height: 250)
                            .clipShape(Circle())
                            .padding(.top, 50)
                            .padding(.bottom,50)
                    })
                default:
                    NavigationLink(destination: ProfileImage(image: Image(systemName: "photo")), label: {
                        Image(systemName: "photo")
                            .resizable()
                            .frame(width: 250, height: 250)
                            .clipShape(Circle())
                            .padding(.top, 50)
                            .padding(.bottom,50)
                    })
                }
                
            }
            HStack{
                Text("Name: \(customerDetails?.firstName ?? "") \(customerDetails?.lastName ?? "")")
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
            Task(priority: .background){
                do{
                    let profile = try await CustomerFireStoreRequests.shared.getCustomerDetails(userId: user.userId)
                    let url = try await CustomerFireStoreRequests.shared.getCustomerImage(userId: user.userId)
                    DispatchQueue.main.async {
                        self.customerDetails = profile!
                        self.url = url ?? nil
                    }
                }catch{
                    print("Error")
                }
            }
            print("Hi")
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(UserSignin())
    }
}
