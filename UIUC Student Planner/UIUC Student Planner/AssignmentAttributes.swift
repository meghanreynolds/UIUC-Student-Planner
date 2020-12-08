//
//  AssignmentAttributes.swift
//  UIUC Student Planner
//
//  Created by Faraz Siddiqi on 10/18/20.
//

import SwiftUI

extension Color {
    public init(decimalRed red: Double, green: Double, blue: Double) {
        self.init(red: red / 255, green: green / 255, blue: blue / 255)
    }
    
    public static var flatDarkBackground: Color {
        return Color(decimalRed: 36, green: 36, blue: 36)
    }
    
    public static var CardBackground: Color {
        return Color(decimalRed: 232, green: 74, blue: 39)
    }
}

struct AssignmentAttributes: View {
    var assignment: Assignment
    var body: some View {
        VStack {ZStack(alignment: .leading) {
            Color.CardBackground
            HStack {
                VStack(alignment: .leading) {
                    HStack{
                        Text("\(assignment.name ?? "Unknown")")
                            .font(.headline)
                            .fontWeight(.bold)
                            .lineLimit(2)
                            .padding(.bottom, 5)
                            .foregroundColor(Color.white)
                        Spacer()
                        if(assignment.pinned) {
                            Image(systemName: "pin.fill")
                                .foregroundColor(.white)
                        }
                    }
                    
                    Text("Due Date: \(assignment.dueDate ?? Date(), formatter: dayFormatter)")
                        .padding(.bottom, 5)
                        .foregroundColor(Color.white)
                    
                    HStack(alignment: .center) {
                        Text("Points: \(assignment.points)")
                            .foregroundColor(Color.white)
                    }
                    .padding(.bottom, 5)
                    
                    
                }
                .padding(.horizontal, 5)
            }
            .padding(15)
        }
        }
    }
    private let dayFormatter: DateFormatter = {
        //Starter code, feel free to remove this based on that the assignment entry data has
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MMM d"
        return formatter
    }()
}


struct AssignmentAttributes_Previews: PreviewProvider {
    static var previews: some View {
        AssignmentAttributes(assignment: Assignment(context: PersistenceController.preview.container.viewContext))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
