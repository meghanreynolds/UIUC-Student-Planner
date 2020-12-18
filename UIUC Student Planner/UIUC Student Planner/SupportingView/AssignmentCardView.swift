//
//  AssignmentCardView.swift
//  UIUC Student Planner
//
//  Created by Jeffery Wang on 12/5/20.
//

import SwiftUI


struct AssignmentCardView: View{
    
    @Binding var themeColorIndex: Int
    
    var name = ""
    var due = Date()
    var priority = 0
    var link: URL?
    var point = 0
    
    var themeColor: Color{
        get{
            return Color.Material.palette[self.themeColorIndex]
        }
    }
    
    init(_ assignment: Assignment, _ themeColorIndex: Binding<Int>){
        self._themeColorIndex = themeColorIndex
        self.name = assignment.name!
        self.due = assignment.dueDate!
        self.priority = Int(assignment.priority)
        self.link = assignment.linkToAssignment
        self.point = Int(assignment.points)
    }
    
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 10.0)
                .fill(Color.from(rgbValue: 0xF7F7FC))
            VStack{
                //name, points
                HStack{
                    Text(name)
                        .font(Font.system(size: 20, weight: .bold, design: .default))
                        .foregroundColor(.black)
                    Spacer()
                }
                HStack{
                    Text("points: \(self.point)")
                        .font(.system(size: 16))
                        .foregroundColor(self.themeColor)
                    Spacer()
                }
                .padding(.bottom, 5.0)
                HStack{
                    Image.init(systemName: "calendar")
                        .font(.system(size: 18))
                        .foregroundColor(.white).padding(5)
                        .background(RoundedRectangle(cornerRadius: 7)
                            .aspectRatio(1, contentMode: .fill)
                                        .foregroundColor(self.themeColor))
                    Text(self.due.toString(dateStyle: .short, timeStyle: .short))
                        .padding(.leading, 5)
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                    Spacer()
                }
            }.padding(.all, 10.0)
        }
    }
}
