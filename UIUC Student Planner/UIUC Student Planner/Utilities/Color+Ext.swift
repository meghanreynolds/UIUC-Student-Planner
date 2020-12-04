//
//  UIColor+Ext.swift
//  UIUC Student Planner
//
//  Created by Jeffery Wang on 11/28/20.
//

import SwiftUI


extension Color: Identifiable{
    
    var isDarkColor: Bool {
        get{
            var r, g, b, a: CGFloat
            (r, g, b, a) = (0, 0, 0, 0)
            UIColor(self).getRed(&r, green: &g, blue: &b, alpha: &a)
            let lum = 0.2126 * r + 0.7152 * g + 0.0722 * b
            return  lum < 0.75
        }
    }
    
    public static func from(rgbValue: Int, alpha: CGFloat = 1.0) -> Color{
        return Color(UIColor(
            red: ((CGFloat)((rgbValue & 0xFF0000) >> 16)) / 255.0,
            green: ((CGFloat)((rgbValue & 0xFF00) >> 8)) / 255.0,
            blue: ((CGFloat)(rgbValue & 0xFF)) / 255.0,
            alpha: alpha
        ))
    }
    
    public var hexString: String{
        get{
            let components = self.cgColor!.components
                let r: CGFloat = components?[0] ?? 0.0
                let g: CGFloat = components?[1] ?? 0.0
                let b: CGFloat = components?[2] ?? 0.0

                let ret = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
                return ret
        }
    }
    
    public struct Material{
        public static let red = Color.from(rgbValue: 0xf44336)
        public static let pink = Color.from(rgbValue: 0xe91e63)
        public static let purple = Color.from(rgbValue: 0x9c27b0)
        public static let deepPurple = Color.from(rgbValue: 0x673ab7)
        public static let indigo = Color.from(rgbValue: 0x3f51b5)
        public static let lightBlue = Color.from(rgbValue: 0x29b6f6)
        public static let blue = Color.from(rgbValue: 0x2196f3)
        public static let deepBlue = Color.from(rgbValue: 0x0d47a1)
        public static let cyan = Color.from(rgbValue: 0x00bcd4)
        public static let teal = Color.from(rgbValue: 0x009688)
        public static let lightGreen = Color.from(rgbValue: 0x8bc34a)
        public static let green = Color.from(rgbValue: 0x4caf50)
        public static let lime = Color.from(rgbValue: 0xd4e157)
        public static let yellow = Color.from(rgbValue: 0xffeb3b)
        public static let amber = Color.from(rgbValue: 0xffc107)
        public static let orange = Color.from(rgbValue: 0xff9800)
        public static let deepOrange = Color.from(rgbValue: 0xff5722)
        public static let brown = Color.from(rgbValue: 0x795548)
        public static let lightGrey = Color.from(rgbValue: 0xc6c6c6)
        public static let grey = Color.from(rgbValue: 0x9e9e9e)
        public static let blueGrey = Color.from(rgbValue: 0x607d8b)
        public static let black = Color.from(rgbValue: 0x212121)
        
        public static let palette = [Material.red, Material.deepOrange, Material.orange, Material.amber, Material.yellow,
                                     Material.lime, Material.lightGreen, Material.green, Material.teal, Material.cyan,
                                     Material.blue, Material.deepBlue, Material.deepPurple, Material.purple,
                                     Material.pink, Material.grey, Material.black, Material.brown]
    }
    
    //this is to just let Color confirms to Identifiable protocol. You should not use this.
    public var id: UUID {
        UUID()
    }
}

func ==(l: Color, r: Color) -> Bool{
    return l.hexString == r.hexString
}
