//
//  CourseCard.swift
//  UIUC Student Planner
//
//  Created by Jeffery Wang on 11/28/20.
//

import SwiftUI

struct CourseCard: UIViewRepresentable{
    @Binding var title: String
    @Binding var colorIndex: Int
    
    func makeUIView(context: Context) -> some UIView {
        let vc = CourseCardViewController()
        vc.view.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        vc.data = (self.title, UIColor(Color.Material.palette[colorIndex]))
        return vc.view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
