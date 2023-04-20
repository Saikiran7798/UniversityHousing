//
//  OwnerProfile.swift
//  UniversityHousing
//
//  Created by Saikiran Reddy Doddeni on 4/20/23.
//

import SwiftUI

struct OwnerProfile: View {
    @EnvironmentObject var user : UserSignin
    @State var ownerDetails : OwnerProfileDetails?
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
                Text("Name: \(ownerDetails?.firstName ?? "") \(ownerDetails?.firstName ?? "")")
                Spacer()
            }
            .padding()
            HStack{
                Text("EmailId: \(ownerDetails?.emailId ?? "")")
                Spacer()
            }
            .padding()
            HStack{
                Text("Phone Number: \(ownerDetails?.phoneNumber ?? "")")
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
                    let profile = try await FirestoreRequests.shared.getOwnerDetails(userId: user.userId)
                    let url = try await FirestoreRequests.shared.getOwnerImage(userId: user.userId)
                    DispatchQueue.main.async {
                        self.ownerDetails = profile!
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

struct OwnerProfile_Previews: PreviewProvider {
    static var previews: some View {
        OwnerProfile()
            .environmentObject(UserSignin())
    }
}
