//
//  OwnerPropertiesView.swift
//  UniversityHousing
//
//  Created by Saikiran Reddy Doddeni on 4/12/23.
//

import SwiftUI
import URLImage

struct OwnerPropertiesView: View {
    var title : String
    var url : URL
    var bedrooms: Int
    var rent: Int
    var furnished : String
    var proprtyId : String
    var ownerID : String
    var onDelete : ((Int) -> Void)
    var index: Int
    @State var isPresented = false
    var body: some View {
        HStack(spacing:20) {
            AsyncImage(url: url){ path in
                switch path {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .frame(width: 100, height: 100)
                default:
                    Image(systemName: "photo")
                        .resizable()
                        .frame(width: 100, height: 100)
                }
                
            }
            VStack(spacing: 10) {
                HStack {
                    Text(title)
                    Spacer()
                    Button(action: {
                        isPresented = true
                    }, label: {
                        Image(systemName: "pencil")
                    })
                    Button(action: {
                        Task(priority: .background){
                            do{
                                try await FirestoreRequests.shared.deleteProperty(proprtyID: proprtyId, userId: ownerID)
                            }
                        }
                        onDelete(index)
                    }, label: {
                        Image(systemName: "trash")
                    })
                    NavigationLink(destination: OwnerPropertyEditView(propertyID: "\(proprtyId)", ownerID: "\(ownerID)"), isActive: $isPresented, label: {
                        EmptyView()
                    })
                }
                HStack {
                    Text("\(bedrooms) BHK")
                    Spacer()
                    Text(furnished)
                    Spacer()
                }
                HStack {
                    Text("$\(rent)")
                        .foregroundColor(.red)
                    Spacer()
                    NavigationLink(destination: PropertyDetailView(propertyID: proprtyId, ownerId: ownerID), label: {
                        Text("Know More")
                            .foregroundColor(.blue)
                    })
                }
            }
            Spacer()
        }
        .padding(.leading)
    }
}

struct OwnerPropertiesView_Previews: PreviewProvider {
    static var previews: some View {
        OwnerPropertiesView(title: "Hi", url: URL(string: "https://www.google.com/imgres?imgurl=https%3A%2F%2Fcdn.pixabay.com%2Fphoto%2F2015%2F04%2F23%2F22%2F00%2Ftree-736885__480.jpg&tbnid=9SPhZ2nyEGps3M&vet=12ahUKEwj77Lu_26P-AhU9Lt4AHXffBSUQMygAegUIARDmAQ..i&imgrefurl=https%3A%2F%2Fpixabay.com%2Fimages%2Fsearch%2Fnature%2F&docid=Ba_eiczVaD9-zM&w=771&h=480&q=images&ved=2ahUKEwj77Lu_26P-AhU9Lt4AHXffBSUQMygAegUIARDmAQ")!, bedrooms: 0, rent: 0, furnished: "Hi", proprtyId: "Hi", ownerID: "Hi", onDelete: {_ in }, index: 0)
    }
}
