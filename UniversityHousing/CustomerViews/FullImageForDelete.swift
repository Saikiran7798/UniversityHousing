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
    @Binding var imageWithpaths : [String : UIImage]
    @Binding var key : String
    @Binding var index : Int
    @State var showAlert = false
    var onDelete : ((String) -> Void)
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Label("Property", systemImage: "chevron.left")
                    })
                    Spacer()
                    Button(action: {
                        if imageWithpaths.count == 1 {
                            showAlert = true
                        }
                        else {
                            imageWithpaths.removeValue(forKey: key)
                            onDelete(key)
                            if index < imageWithpaths.count - 1 {
                                index += 1
                            }
                            else {
                                index -= 1
                            }
                            withAnimation{
                                key = Array(imageWithpaths.keys)[index]
                            }
                        }
                    }, label: {
                        Image(systemName: "trash")
                    })
                }
                .padding()
                Spacer()
                Image(uiImage: imageWithpaths[key]!)
                    .resizable()
                    .scaledToFit()
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
        FullImageForDelete(propetyId : "", ownerID: "", imageWithpaths: Binding.constant(["Hi": UIImage(systemName: "photo")!]), key: Binding.constant("Hi"), index: Binding.constant(0), onDelete: {_ in })
    }
}
