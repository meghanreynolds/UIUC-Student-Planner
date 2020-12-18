//
//  Settings.swift
//  UIUC Student Planner
//
//  Created by Meghan Reynolds on 11/11/20.
//

import SwiftUI
struct Settings: View {
    @State var courseName: String = ""
    var body: some View {
        NavigationView {
            Form {
                Section {
                    NavigationLink(destination: TagSettings()){
                        HStack {
                            Image(systemName: "tag.fill")
                                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                            Text("Tags")
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
