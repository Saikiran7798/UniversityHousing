//
//  SliderView.swift
//  UniversityHousing
//
//  Created by Saikiran Reddy Doddeni on 4/18/23.
//

import SwiftUI

struct SliderView: View {
    @Binding var minRent : Double
    @Binding var maxRent : Double
    var body: some View {
        VStack(spacing: 20){
            Text("Please select Minimum Rent")
            HStack{
                Text("0")
                Slider(value: $minRent, in: 0...1950, step: 25)
                    .frame(width: 250)
                Text("1950")
            }
            Text("Minimum Rent selected is \(Int(minRent))")
                .foregroundColor(.blue)
            
            Text("Please select Maximum Rent")
            HStack{
                Text("\(Int(minRent + 25.0))")
                Slider(value: $maxRent, in: (minRent + 25.0)...2000, step: 25)
                    .frame(width: 250)
                Text("2000")
            }
            Text("Maximum Rent selected is \(Int(maxRent))")
                .foregroundColor(.blue)
        }
    }
}

struct SliderView_Previews: PreviewProvider {
    static var previews: some View {
        SliderView(minRent: Binding.constant(0.0), maxRent: Binding.constant(0.0))
    }
}
