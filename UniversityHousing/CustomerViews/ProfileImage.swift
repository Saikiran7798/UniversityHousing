//
//  CustomerProfileImage.swift
//  UniversityHousing
//
//  Created by Saikiran Reddy Doddeni on 4/20/23.
//

import SwiftUI
import PhotosUI
import UIKit

struct ProfileImage: View {
    var image : Image
    @State var newImage : Image?
    @State var profileItem : PhotosPickerItem?
    @State var photoData : Data?
    @State var isUploaded = false
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var user: UserSignin
    var body: some View {
        VStack{
            HStack{
                Button(){
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Label("Profile", systemImage: "chevron.left")
                }
                Spacer()
                PhotosPicker(selection: $profileItem, matching: .images){
                    Text("Edit")
                }
                .onChange(of: profileItem){ _ in
                    Task {
                        if let data = try? await profileItem?.loadTransferable(type: Data.self) {
                            if let uiImage = UIImage(data: data) {
                                newImage = Image(uiImage: uiImage)
                                return
                            }
                        }
                        print("failed")
                    }
                }
            }
            .padding()
            Spacer()
            if let newImage = newImage {
                newImage
                    .resizable()
                    .frame(height: 300)
            }
            else{
                image
                    .resizable()
                    .frame(height: 300)
            }
            Spacer()
            Button("Save"){
                if user.userType == "Customer" {
                    if let photoData = photoData {
                        print("Entered inside save")
                        DispatchQueue.global(qos: .background).async {
                            CustomerFireStoreRequests.shared.uploadCustomerProfileImage(userId: user.userId, photo: photoData){ result in
                                DispatchQueue.main.async {
                                    self.isUploaded = result
                                    if isUploaded {
                                        print("upload value is \(isUploaded)")
                                        presentationMode.wrappedValue.dismiss()
                                    }
                                }
                            }
                        }
                    }
                }
                if user.userType == "Owner" {
                    if let photoData = photoData {
                        print("Entered inside save")
                        DispatchQueue.global(qos: .background).async {
                            FirestoreRequests.shared.uploadOwnerProfileImage(userId: user.userId, photo: photoData){ result in
                                DispatchQueue.main.async {
                                    self.isUploaded = result
                                    if isUploaded {
                                        print("upload value is \(isUploaded)")
                                        presentationMode.wrappedValue.dismiss()
                                    }
                                }
                            }
                        }
                    }
                }
            }
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct CustomerProfileImage_Previews: PreviewProvider {
    static var previews: some View {
        ProfileImage(image: Image(systemName: "photo"))
            .environmentObject(UserSignin())
    }
}
