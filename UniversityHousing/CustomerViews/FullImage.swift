//
//  FullImage.swift
//  UniversityHousing
//
//  Created by Saikiran Reddy Doddeni on 5/3/23.
//

import SwiftUI

struct FullImage: View {
    @Binding var propImage : [UIImage]
    @Binding var currentIndex : Int
    @Environment(\.presentationMode) var presentationMode
    var viewType : String
    var body: some View {
        VStack {
            VStack {
                if viewType == "NoEdit" {
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Label("Property", systemImage: "chevron.left")
                        })
                        Spacer()
                    }
                    .padding()
                    Spacer()
                    Image(uiImage: propImage[currentIndex])
                        .resizable()
                        .scaledToFit()
                    Spacer()
                }
            }
            .gesture(
                DragGesture()
                        .onEnded(){ gesture in
                        let width = UIScreen.main.bounds.width
                        withAnimation{
                            if gesture.predictedEndTranslation.width < -width/2, currentIndex < propImage.count - 1 {
                                currentIndex += 1
                                print("currentIndec value in \(currentIndex)")
                            } else if gesture.predictedEndTranslation.width > width/2 , currentIndex > 0 {
                                currentIndex -= 1
                                print("currentIndec value in \(currentIndex)")
                            }
                        }
                    }
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct FullImage_Previews: PreviewProvider {
    static var previews: some View {
        FullImage(propImage: Binding.constant([UIImage(systemName: "photo")!]),  currentIndex: Binding.constant(0), viewType: "NoEdit")
    }
}
