//
//  CircleImage.swift
//  UIUC Student Planner
//
//  Created by Jathin Nama on 10/21/20.
//

import SwiftUI

struct CircleImage: View {
    var body: some View {
        Image("Logo")
            .clipShape(Circle())
            .overlay(
                Circle().stroke(Color.black, lineWidth: 6))
            .shadow(radius: 10)
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage()
    }
}
