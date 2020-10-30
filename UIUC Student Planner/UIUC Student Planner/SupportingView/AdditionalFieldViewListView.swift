//
//  AdditionalFieldViewListView.swift
//  UIUC Student Planner
//
//  Created by Meghan Reynolds on 10/30/20.
//

import SwiftUI

struct AdditionalFieldViewListView: View {
    var placeholder: String
    var addTxt: String
    @ State var holder: String
    @State var formShowing: Bool = false
    var body: some View {
        List{
            if formShowing {
                HStack {
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                        }
                    }
                    TextField(placeholder, text: $holder)
                }
            }
            Button(action: {formShowing = true}) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.green)
                    Text("Add a \(addTxt)")
                }
            }
        }
    }
}

struct AdditionalFieldViewListView_Previews: PreviewProvider {
    static var previews: some View {
        AdditionalFieldViewListView(placeholder: "Link to Assignment", addTxt: "link", holder: "")
    }
}
