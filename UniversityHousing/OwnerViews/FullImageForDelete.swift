//
//  FullImageForDelete.swift
//  UniversityHousing
//
//  Created by Saikiran Reddy Doddeni on 5/3/23.
//

import SwiftUI

struct FullImageForDelete: View {
    var propetyId : String
    var ownerID: String
    var houseTitle : String
    @Binding var imageWithpaths : [String : UIImage]
    @Binding var key : String
    @Binding var index : Int
    @State var showAlert = false
    @State var oldkey = ""
    var onDelete : ((String) -> Void)
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Label("\(houseTitle)", systemImage: "chevron.left")
                    })
                    Spacer()
                    Button(action: {
                        if imageWithpaths.count == 1 {
                            showAlert = true
                        }
                        else {
                            print("Index before deleting \(index)")
                            oldkey = key
                            imageWithpaths.removeValue(forKey: oldkey)
                            if index < imageWithpaths.count - 1 || index == 0 {
                                if index != 0 {
                                    index += 1
                                    key = Array(imageWithpaths.keys)[index]
                                }
                                else {
                                    index = 0
                                    key = Array(imageWithpaths.keys)[index]
                                }
                            }
                            else {
                                index -= 1
                                key = Array(imageWithpaths.keys)[index]
                            }
                            print("Index after deleting is \(index)")
                            print("image count \(imageWithpaths.count)")
                            print("new key is \(key)")
                            print("old key is \(oldkey)")
                            onDelete(oldkey)
                        }
                    }, label: {
                        Image(systemName: "trash")
                    })
                }
                .padding()
                Spacer()
                if let image = imageWithpaths[key]{
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                }
                else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                }
                Spacer()
            }
            .alert(isPresented: $showAlert, content: {
                Alert(title: Text("Error"), message: Text("You should have atleast One Image , Can't Delete Image"))
            })
            .gesture(
                DragGesture()
                    .onEnded(){ gesture in
                        let width = UIScreen.main.bounds.width
                        withAnimation{
                            if gesture.predictedEndTranslation.width < -width/2, index < imageWithpaths.count - 1 {
                                index += 1
                                key = Array(imageWithpaths.keys)[index]
                            } else if gesture.predictedEndTranslation.width > width/2, index > 0 {
                                index -= 1
                                key = Array(imageWithpaths.keys)[index]
                            }
                        }
                    }
            )
        }
    }
}

struct FullImageForDelete_Previews: PreviewProvider {
    static var previews: some View {
        FullImageForDelete(propetyId : "", ownerID: "", houseTitle: "", imageWithpaths: Binding.constant(["Hi": UIImage(systemName: "photo")!]), key: Binding.constant("Hi"), index: Binding.constant(0), onDelete: {_ in })
    }
}
