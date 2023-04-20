//
//  CustomerViewRow.swift
//  UniversityHousing
//
//  Created by Saikiran Reddy Doddeni on 4/14/23.
//

import SwiftUI
import URLImage
import MapKit

struct CustomerViewRow: View {
    var url : URL
    var title : String
    var bedrooms : Int
    var rent : Int
    var furnished : String
    var bathrooms: Int
    var houseType: String
    var body: some View {
        VStack(spacing: 20){
            AsyncImage(url: url){ path in
                switch path {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .frame(height: 150)
                default:
                    Image(systemName: "photo")
                        .resizable()
                        .frame(width: 300, height: 200)
                }
            }
            HStack{
                Text(title)
                    .bold()
                Spacer()
            }
            HStack {
                HStack{
                    Image(systemName: "square.fill")
                        .frame(width: 10, height: 10)
                        .foregroundColor(.orange)
                    Text("\(bedrooms) bedrooms")
                        .foregroundColor(.gray)
                }
                HStack{
                    Image(systemName: "square.fill")
                        .frame(width: 10, height: 10)
                        .foregroundColor(.orange)
                    Text("\(bathrooms) bathrooms")
                        .foregroundColor(.gray)
                }
            }
            HStack{
                Image(systemName: "square.fill")
                    .frame(width: 10, height: 10)
                    .foregroundColor(.orange)
                Text("\(furnished)")
                    .foregroundColor(.gray)
                Image(systemName: "square.fill")
                    .frame(width: 10, height: 10)
                    .foregroundColor(.orange)
                Text("House Type: \(houseType)")
                    .foregroundColor(.gray)
            }
            HStack{
                Spacer()
                Text("$\(rent)")
                    .foregroundColor(Color.blue.opacity(0.8))
                    .bold()
            }

        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.gray.opacity(0.1))
    }
}

struct CustomerViewRow_Previews: PreviewProvider {
    static var previews: some View {
        CustomerViewRow(url: URL(string: "https://www.google.com/imgres?imgurl=https%3A%2F%2Fcdn.pixabay.com%2Fphoto%2F2015%2F04%2F23%2F22%2F00%2Ftree-736885__480.jpg&tbnid=9SPhZ2nyEGps3M&vet=12ahUKEwj77Lu_26P-AhU9Lt4AHXffBSUQMygAegUIARDmAQ..i&imgrefurl=https%3A%2F%2Fpixabay.com%2Fimages%2Fsearch%2Fnature%2F&docid=Ba_eiczVaD9-zM&w=771&h=480&q=images&ved=2ahUKEwj77Lu_26P-AhU9Lt4AHXffBSUQMygAegUIARDmAQ")!, title: "Hi", bedrooms: 0, rent: 0, furnished: "Hi", bathrooms: 0, houseType: "Hi")
    }
}
