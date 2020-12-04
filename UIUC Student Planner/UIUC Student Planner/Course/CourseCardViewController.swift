//
//  CourseCardViewController.swift
//  UIUC Student Planner
//
//  Created by Jeffery Wang on 11/28/20.
//

import UIKit

class CourseCardViewController: UIViewController{
    
    var textField = UITextField()
    
    var data: (String, UIColor)?{
        didSet{
            self.view.backgroundColor = self.data!.1
            self.textField.text = self.data!.0
        }
    }
    override func viewDidLoad() {
        self.textField = UITextField(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        self.textField.backgroundColor = .green
    }
}
