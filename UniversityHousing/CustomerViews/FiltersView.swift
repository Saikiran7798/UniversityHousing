//
//  FiltersView.swift
//  UniversityHousing
//
//  Created by Saikiran Reddy Doddeni on 4/18/23.
//

import SwiftUI

struct FiltersView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var filter : Filters
    @State var isBathroom : Bool = false
    @State var isBedroom : Bool = false
    @State var minRent : Double = 0.0
    @State var maxRent : Double = 0.0
    @State var isBathroomBool = Array(repeating: false, count: 4)
    @State var isBedroomBool = Array(repeating: false, count: 4)
    @State var bathroomsFilter : [String] = []
    @State var bedroomsFilter : [String] = []
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    var body: some View {
        VStack{
            if horizontalSizeClass == .compact && verticalSizeClass == .compact {
                ScrollView{
                    HStack{
                        Button(){
                            filter.dismissAction = "xmark"
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(systemName: "xmark.app.fill")
                                .foregroundColor(.black)
                        }
                        Spacer()
                    }
                    .padding()
                    Button(){
                        withAnimation(.easeInOut(duration: 0.3)){
                            isBathroom.toggle()
                        }
                    } label: {
                        HStack{
                            Text("Bathrooms")
                                .foregroundColor(.black)
                                .bold()
                            Spacer()
                            if isBathroom{
                                Image(systemName: "chevron.down.circle.fill")
                                    .foregroundColor(.blue)
                            }
                            else{
                                Image(systemName: "chevron.up.circle.fill")
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding()
                    }
                    if isBathroom {
                        VStack{
                            HStack(spacing: 140){
                                Checkbox(title: "1", selected: isBathroomBool[0]){
                                    isBathroomBool[0].toggle()
                                    if isBathroomBool[0]{
                                        bathroomsFilter.append("1")
                                        print("\(bathroomsFilter)")
                                    }
                                    else{
                                        if bathroomsFilter.contains("1") {
                                            let index = bathroomsFilter.firstIndex(of: "1")
                                            bathroomsFilter.remove(at: index!)
                                            print("\(bathroomsFilter)")
                                        }
                                    }
                                }
                                Checkbox(title: "3", selected: isBathroomBool[2]){
                                    isBathroomBool[2].toggle()
                                    if isBathroomBool[2]{
                                        bathroomsFilter.append("3")
                                        print("\(bathroomsFilter)")
                                    }
                                    else{
                                        if bathroomsFilter.contains("3") {
                                            let index = bathroomsFilter.firstIndex(of: "3")
                                            bathroomsFilter.remove(at: index!)
                                            print("\(bathroomsFilter)")
                                        }
                                    }
                                }
                                Spacer()
                            }
                            .padding()
                            HStack(spacing: 125){
                                Checkbox(title: "2", selected: isBathroomBool[1]){
                                    isBathroomBool[1].toggle()
                                    if isBathroomBool[1]{
                                        bathroomsFilter.append("2")
                                        print("\(bathroomsFilter)")
                                    }
                                    else{
                                        if bathroomsFilter.contains("2") {
                                            let index = bathroomsFilter.firstIndex(of: "2")
                                            bathroomsFilter.remove(at: index!)
                                            print("\(bathroomsFilter)")
                                        }
                                    }

                                }
                                Checkbox(title: ">=4", selected: isBathroomBool[3]){
                                    isBathroomBool[3].toggle()
                                    if isBathroomBool[3]{
                                        bathroomsFilter.append("4")
                                        print("\(bathroomsFilter)")
                                    }
                                    else{
                                        if bathroomsFilter.contains("4") {
                                            let index = bathroomsFilter.firstIndex(of: "4")
                                            bathroomsFilter.remove(at: index!)
                                            print("\(bathroomsFilter)")
                                        }
                                    }

                                }
                                Spacer()
                            }
                            .padding()
                        }
                    }
                    Button(){
                        withAnimation(.easeInOut(duration: 0.5)){
                            isBedroom.toggle()
                        }
                    } label: {
                        HStack{
                            Text("Bedrooms")
                                .foregroundColor(.black)
                                .bold()
                            Spacer()
                            if isBedroom{
                                Image(systemName: "chevron.down.circle.fill")
                                    .foregroundColor(.blue)
                            }
                            else{
                                Image(systemName: "chevron.up.circle.fill")
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding()
                    }
                    if isBedroom {
                        VStack{
                            HStack(spacing: 140){
                                Checkbox(title: "1", selected: isBedroomBool[0]){
                                    isBedroomBool[0].toggle()
                                    if isBedroomBool[0]{
                                        bedroomsFilter.append("1")
                                        print("\(bedroomsFilter)")
                                    }
                                    else{
                                        if bedroomsFilter.contains("1") {
                                            let index = bedroomsFilter.firstIndex(of: "1")
                                            bedroomsFilter.remove(at: index!)
                                            print("\(bedroomsFilter)")
                                        }
                                    }
                                }
                                Checkbox(title: "3", selected: isBedroomBool[2]){
                                    isBedroomBool[2].toggle()
                                    if isBedroomBool[2]{
                                        bedroomsFilter.append("3")
                                        print("\(bedroomsFilter)")
                                    }
                                    else{
                                        if bedroomsFilter.contains("3") {
                                            let index = bedroomsFilter.firstIndex(of: "3")
                                            bedroomsFilter.remove(at: index!)
                                            print("\(bedroomsFilter)")
                                        }
                                    }
                                }
                                Spacer()
                            }
                            .padding()
                            HStack(spacing: 125){
                                Checkbox(title: "2", selected: isBedroomBool[1]){
                                    isBedroomBool[1].toggle()
                                    if isBedroomBool[1]{
                                        bedroomsFilter.append("2")
                                        print("\(bedroomsFilter)")
                                    }
                                    else{
                                        if bedroomsFilter.contains("2") {
                                            let index = bedroomsFilter.firstIndex(of: "2")
                                            bedroomsFilter.remove(at: index!)
                                            print("\(bedroomsFilter)")
                                        }
                                    }

                                }
                                Checkbox(title: ">=4", selected: isBedroomBool[3]){
                                    isBedroomBool[3].toggle()
                                    if isBedroomBool[3]{
                                        bedroomsFilter.append("4")
                                        print("\(bedroomsFilter)")
                                    }
                                    else{
                                        if bedroomsFilter.contains("4") {
                                            let index = bedroomsFilter.firstIndex(of: "4")
                                            bedroomsFilter.remove(at: index!)
                                            print("\(bedroomsFilter)")
                                        }
                                    }

                                }
                                Spacer()
                            }
                            .padding()
                        }
                    }
                    SliderView(minRent: $minRent, maxRent: $maxRent)
                        .onChange(of: maxRent){ newValue in
                            filter.maxRent = Int(newValue)
                        }
                        .onChange(of: minRent){ newValue in
                            filter.minRent = Int(newValue)
                        }
                    HStack(spacing: 100){
                        Button("Reset"){
                            filter.reset()
                            filter.dismissAction = "Reset"
                        }
                        .frame(width: 80, height: 50)
                        .foregroundColor(.blue)
                        .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 2)
                            .foregroundColor(.blue))
                        Button("Apply"){
                            filter.bedroomsFilter = bedroomsFilter
                            filter.bathroomsFilter = bathroomsFilter
                            filter.bedroomsBool = isBedroomBool
                            filter.bathroomsBool = isBathroomBool
                            filter.dismissAction = "Apply"
                            presentationMode.wrappedValue.dismiss()
                        }
                        .frame(width: 80, height: 50)
                        .foregroundColor(.blue)
                        .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 2)
                            .foregroundColor(.blue))
                    }
                    .padding()
                }
            }
            else {
                HStack{
                    Button(){
                        filter.dismissAction = "xmark"
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark.app.fill")
                            .foregroundColor(.black)
                    }
                    Spacer()
                }
                .padding()
                Button(){
                    withAnimation(.easeInOut(duration: 0.3)){
                        isBathroom.toggle()
                    }
                } label: {
                    HStack{
                        Text("Bathrooms")
                            .foregroundColor(.black)
                            .bold()
                        Spacer()
                        if isBathroom{
                            Image(systemName: "chevron.down.circle.fill")
                                .foregroundColor(.blue)
                        }
                        else{
                            Image(systemName: "chevron.up.circle.fill")
                                .foregroundColor(.blue)
                        }
                    }
                    .padding()
                }
                if isBathroom {
                    VStack{
                        HStack(spacing: 140){
                            Checkbox(title: "1", selected: isBathroomBool[0]){
                                isBathroomBool[0].toggle()
                                if isBathroomBool[0]{
                                    bathroomsFilter.append("1")
                                    print("\(bathroomsFilter)")
                                }
                                else{
                                    if bathroomsFilter.contains("1") {
                                        let index = bathroomsFilter.firstIndex(of: "1")
                                        bathroomsFilter.remove(at: index!)
                                        print("\(bathroomsFilter)")
                                    }
                                }
                            }
                            Checkbox(title: "3", selected: isBathroomBool[2]){
                                isBathroomBool[2].toggle()
                                if isBathroomBool[2]{
                                    bathroomsFilter.append("3")
                                    print("\(bathroomsFilter)")
                                }
                                else{
                                    if bathroomsFilter.contains("3") {
                                        let index = bathroomsFilter.firstIndex(of: "3")
                                        bathroomsFilter.remove(at: index!)
                                        print("\(bathroomsFilter)")
                                    }
                                }
                            }
                            Spacer()
                        }
                        .padding()
                        HStack(spacing: 125){
                            Checkbox(title: "2", selected: isBathroomBool[1]){
                                isBathroomBool[1].toggle()
                                if isBathroomBool[1]{
                                    bathroomsFilter.append("2")
                                    print("\(bathroomsFilter)")
                                }
                                else{
                                    if bathroomsFilter.contains("2") {
                                        let index = bathroomsFilter.firstIndex(of: "2")
                                        bathroomsFilter.remove(at: index!)
                                        print("\(bathroomsFilter)")
                                    }
                                }

                            }
                            Checkbox(title: ">=4", selected: isBathroomBool[3]){
                                isBathroomBool[3].toggle()
                                if isBathroomBool[3]{
                                    bathroomsFilter.append("4")
                                    print("\(bathroomsFilter)")
                                }
                                else{
                                    if bathroomsFilter.contains("4") {
                                        let index = bathroomsFilter.firstIndex(of: "4")
                                        bathroomsFilter.remove(at: index!)
                                        print("\(bathroomsFilter)")
                                    }
                                }

                            }
                            Spacer()
                        }
                        .padding()
                    }
                }
                Button(){
                    withAnimation(.easeInOut(duration: 0.5)){
                        isBedroom.toggle()
                    }
                } label: {
                    HStack{
                        Text("Bedrooms")
                            .foregroundColor(.black)
                            .bold()
                        Spacer()
                        if isBedroom{
                            Image(systemName: "chevron.down.circle.fill")
                                .foregroundColor(.blue)
                        }
                        else{
                            Image(systemName: "chevron.up.circle.fill")
                                .foregroundColor(.blue)
                        }
                    }
                    .padding()
                }
                if isBedroom {
                    VStack{
                        HStack(spacing: 140){
                            Checkbox(title: "1", selected: isBedroomBool[0]){
                                isBedroomBool[0].toggle()
                                if isBedroomBool[0]{
                                    bedroomsFilter.append("1")
                                    print("\(bedroomsFilter)")
                                }
                                else{
                                    if bedroomsFilter.contains("1") {
                                        let index = bedroomsFilter.firstIndex(of: "1")
                                        bedroomsFilter.remove(at: index!)
                                        print("\(bedroomsFilter)")
                                    }
                                }
                            }
                            Checkbox(title: "3", selected: isBedroomBool[2]){
                                isBedroomBool[2].toggle()
                                if isBedroomBool[2]{
                                    bedroomsFilter.append("3")
                                    print("\(bedroomsFilter)")
                                }
                                else{
                                    if bedroomsFilter.contains("3") {
                                        let index = bedroomsFilter.firstIndex(of: "3")
                                        bedroomsFilter.remove(at: index!)
                                        print("\(bedroomsFilter)")
                                    }
                                }
                            }
                            Spacer()
                        }
                        .padding()
                        HStack(spacing: 125){
                            Checkbox(title: "2", selected: isBedroomBool[1]){
                                isBedroomBool[1].toggle()
                                if isBedroomBool[1]{
                                    bedroomsFilter.append("2")
                                    print("\(bedroomsFilter)")
                                }
                                else{
                                    if bedroomsFilter.contains("2") {
                                        let index = bedroomsFilter.firstIndex(of: "2")
                                        bedroomsFilter.remove(at: index!)
                                        print("\(bedroomsFilter)")
                                    }
                                }

                            }
                            Checkbox(title: ">=4", selected: isBedroomBool[3]){
                                isBedroomBool[3].toggle()
                                if isBedroomBool[3]{
                                    bedroomsFilter.append("4")
                                    print("\(bedroomsFilter)")
                                }
                                else{
                                    if bedroomsFilter.contains("4") {
                                        let index = bedroomsFilter.firstIndex(of: "4")
                                        bedroomsFilter.remove(at: index!)
                                        print("\(bedroomsFilter)")
                                    }
                                }

                            }
                            Spacer()
                        }
                        .padding()
                    }
                }
                SliderView(minRent: $minRent, maxRent: $maxRent)
                    .onChange(of: maxRent){ newValue in
                        filter.maxRent = Int(newValue)
                    }
                    .onChange(of: minRent){ newValue in
                        filter.minRent = Int(newValue)
                    }
                HStack(spacing: 100){
                    Button("Reset"){
                        filter.reset()
                        filter.dismissAction = "Reset"
                    }
                    .frame(width: 80, height: 50)
                    .foregroundColor(.blue)
                    .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.blue))
                    Button("Apply"){
                        filter.bedroomsFilter = bedroomsFilter
                        filter.bathroomsFilter = bathroomsFilter
                        filter.bedroomsBool = isBedroomBool
                        filter.bathroomsBool = isBathroomBool
                        filter.dismissAction = "Apply"
                        presentationMode.wrappedValue.dismiss()
                    }
                    .frame(width: 80, height: 50)
                    .foregroundColor(.blue)
                    .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.blue))
                }
                .padding()
            }
        }
        .onAppear(){
            minRent = Double(filter.minRent)
            maxRent = Double(filter.maxRent)
            bathroomsFilter = filter.bathroomsFilter
            bedroomsFilter = filter.bedroomsFilter
            isBedroomBool = filter.bedroomsBool
            isBathroomBool = filter.bathroomsBool
        }
    }
}

struct FiltersView_Previews: PreviewProvider {
    static var previews: some View {
        FiltersView()
            .environmentObject(Filters())
    }
}
