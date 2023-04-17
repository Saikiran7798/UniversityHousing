//
//  PropertyDetailView.swift
//  UniversityHousing
//
//  Created by Saikiran Reddy Doddeni on 4/16/23.
//

import SwiftUI

struct PropertyDetailView: View {
    var propertyID: String
    var ownerId: String
    @State var downLoadURLS : [URL] = []
    var body: some View {
        VStack{
            ScrollView(.horizontal){
                HStack{
                    ForEach(downLoadURLS, id: \.self){ URL in
                        AsyncImage(url: URL){ path in
                            switch path {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .frame(width: 150, height: 150)
                            default:
                                Image(systemName: "photo")
                                    .resizable()
                                    .frame(width: 300, height: 200)
                            }
                        }
                    }
                }
            }
        }
        .onAppear(){
            Task(priority: .background){
                do{
                    let downloadURlS = try await CustomerFireStoreRequests.shared.getPropertyImages(ownerID: ownerId, propertyId: propertyID)
                    DispatchQueue.main.async {
                        self.downLoadURLS = downloadURlS
                    }
                }
                catch{
                    print("Download Images failed")
                }
            }
        }
    }
}

struct PropertyDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PropertyDetailView(propertyID: "", ownerId: "")
    }
}
