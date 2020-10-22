//
//  AssignmentAttributes.swift
//  UIUC Student Planner
//
//  Created by Faraz Siddiqi on 10/18/20.
//

import SwiftUI

extension UIColor {
    
    static let flatDarkBackground = UIColor(red: 36, green: 36, blue: 36)
    static let flatDarkCardBackground = UIColor(red: 46, green: 46, blue: 46)
    
    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: a)
    }
}

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
                     Text("Assignment Name: \(assignment.name ?? "Unknown")")
                        .font(.headline)
                        .fontWeight(.bold)
                        .lineLimit(2)
                        .padding(.bottom, 5)
                        .foregroundColor(Color.white)
                    
                     Text("Due Date: \(assignment.dueDate ?? Date())")
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
}


struct AssignmentAttributes_Previews: PreviewProvider {
    static var previews: some View {
        AssignmentAttributes(assignment: Assignment(context: PersistenceController.preview.container.viewContext))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
