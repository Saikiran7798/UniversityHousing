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
    var body: some View {
        HStack(spacing:20) {
            /*Image(systemName: "photo")
                .resizable()
                .frame(width: 100, height: 100)*/
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
                }
                HStack {
                    Text("\(bedrooms) BHK")
                    Spacer()
                    Text(furnished)
                    Spacer()
                }
                HStack {
                    Text("$\(rent)")
                        .foregroundColor(.blue)
                    Spacer()
                }
            }
            Spacer()
        }
        .padding(.leading)
    }
}

struct OwnerPropertiesView_Previews: PreviewProvider {
    static var previews: some View {
        OwnerPropertiesView(title: "Hi", url: URL(string: "https://www.google.com/imgres?imgurl=https%3A%2F%2Fcdn.pixabay.com%2Fphoto%2F2015%2F04%2F23%2F22%2F00%2Ftree-736885__480.jpg&tbnid=9SPhZ2nyEGps3M&vet=12ahUKEwj77Lu_26P-AhU9Lt4AHXffBSUQMygAegUIARDmAQ..i&imgrefurl=https%3A%2F%2Fpixabay.com%2Fimages%2Fsearch%2Fnature%2F&docid=Ba_eiczVaD9-zM&w=771&h=480&q=images&ved=2ahUKEwj77Lu_26P-AhU9Lt4AHXffBSUQMygAegUIARDmAQ")!, bedrooms: 0, rent: 0, furnished: "Hi")
    }
}
