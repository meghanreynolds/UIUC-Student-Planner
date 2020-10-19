//
//  DetailView.swift
//  UIUC Student Planner
//
//  Created by Faraz Siddiqi on 10/15/20.
//

import SwiftUI

struct DetailView: View {
    @Binding var showingDetail: Bool
    var body: some View {
        Button("test") {
            self.showingDetail = false
        }
        .padding()
        .background(Color.red)
        .cornerRadius(10)
        
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(showingDetail: <#T##Binding<Bool>#>)
    }
}
