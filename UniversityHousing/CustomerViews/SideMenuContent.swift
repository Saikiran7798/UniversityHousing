//
//  SideMenuContent.swift
//  UniversityHousing
//
//  Created by Saikiran Reddy Doddeni on 5/4/23.
//

import SwiftUI

struct SideMenuContent: View {
    @Binding var sideMenutab : Int
    @Binding var presentSidemenu : Bool
    @State var isHomeSelected = false
    @State var isProfileSelected = false
    @State var isFavoriteSelected = false
    var profileImage : UIImage
    var userName : String
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    var body: some View {
        HStack{
            ZStack
            {
                Rectangle()
                    .fill(.white)
                    .frame(width: 270)
                    .shadow(color: .purple.opacity(0.1), radius: 5)
                if horizontalSizeClass == .compact && verticalSizeClass == .compact {
                    VStack(alignment: .center){
                        ScrollView {
                            VStack{
                                Image(uiImage: profileImage)
                                    .resizable()
                                    .clipShape(Circle())
                                    .frame(width: 100)
                                    .frame(height: 100)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 50)
                                            .stroke(.purple.opacity(0.5), lineWidth: 5)
                                    )
                                Text("\(userName)")
                            }
                            .padding()
                            HStack{
                                Button(action: {
                                    sideMenutab = 0
                                    presentSidemenu.toggle()
                                }, label: {
                                    HStack(spacing: 20) {
                                        Image(systemName: "house")
                                        Text("Home")
                                            .foregroundColor(.black)
                                    }
                                    .padding()
                                })
                                Spacer()
                            }
                            .frame(width: 270)
                            .background(LinearGradient(colors: [isHomeSelected ? .purple.opacity(0.8): .white, .white], startPoint: .leading, endPoint: .trailing))
                            HStack{
                                Button(action: {
                                    sideMenutab = 1
                                    presentSidemenu.toggle()
                                }, label: {
                                    HStack(spacing: 20) {
                                        Image(systemName: "heart")
                                        Text("Favorites")
                                            .foregroundColor(.black)
                                    }
                                    .padding()
                                })
                                Spacer()
                            }
                            .frame(width: 270)
                            .background(LinearGradient(colors: [isFavoriteSelected ? .purple.opacity(0.8): .white, .white], startPoint: .leading, endPoint: .trailing))
                            HStack{
                                Button(action: {
                                    sideMenutab = 2
                                    presentSidemenu.toggle()
                                    isProfileSelected = true
                                }, label: {
                                    HStack(spacing: 20) {
                                        Image(systemName: "person.crop.circle")
                                        Text("Profile")
                                            .foregroundColor(.black)
                                    }
                                    .padding()
                                })
                                Spacer()
                            }
                            .frame(width: 270)
                            .background(LinearGradient(colors: [isProfileSelected ? .purple.opacity(0.8): .white, .white], startPoint: .leading, endPoint: .trailing))
                            Spacer()
                        }
                    }
                }
                else {
                    VStack(alignment: .center){
                        VStack{
                            Image(uiImage: profileImage)
                                .resizable()
                                .clipShape(Circle())
                                .frame(width: 100)
                                .frame(height: 100)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 50)
                                        .stroke(.purple.opacity(0.5), lineWidth: 5)
                                )
                            Text("\(userName)")
                        }
                        .padding()
                        HStack{
                            Button(action: {
                                sideMenutab = 0
                                presentSidemenu.toggle()
                            }, label: {
                                    HStack(spacing: 20) {
                                        Image(systemName: "house")
                                        Text("Home")
                                            .foregroundColor(.black)
                                    }
                                    .padding()
                            })
                            Spacer()
                        }
                        .frame(width: 270)
                        .background(LinearGradient(colors: [isHomeSelected ? .purple.opacity(0.8): .white, .white], startPoint: .leading, endPoint: .trailing))
                        HStack{
                            Button(action: {
                                sideMenutab = 1
                                presentSidemenu.toggle()
                            }, label: {
                                    HStack(spacing: 20) {
                                        Image(systemName: "heart")
                                        Text("Favorites")
                                            .foregroundColor(.black)
                                    }
                                    .padding()
                            })
                            Spacer()
                        }
                        .frame(width: 270)
                        .background(LinearGradient(colors: [isFavoriteSelected ? .purple.opacity(0.8): .white, .white], startPoint: .leading, endPoint: .trailing))
                        HStack{
                            Button(action: {
                                sideMenutab = 2
                                presentSidemenu.toggle()
                                isProfileSelected = true
                            }, label: {
                                HStack(spacing: 20) {
                                    Image(systemName: "person.crop.circle")
                                    Text("Profile")
                                        .foregroundColor(.black)
                                }
                                .padding()
                            })
                            Spacer()
                        }
                        .frame(width: 270)
                        .background(LinearGradient(colors: [isProfileSelected ? .purple.opacity(0.8): .white, .white], startPoint: .leading, endPoint: .trailing))
                        Spacer()
                    }
                    .padding(.top, 150)
                }
            }
            Spacer()
        }.onAppear(){
            if sideMenutab == 0 {
                isHomeSelected = true
            }
            if sideMenutab == 1 {
                isFavoriteSelected = true
            }
            if sideMenutab == 2 {
                isProfileSelected = true
            }
        }
    }
}

struct SideMenuContent_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuContent(sideMenutab: Binding.constant(0), presentSidemenu: Binding.constant(false), profileImage: UIImage(systemName: "photo")!, userName: "")
    }
}
