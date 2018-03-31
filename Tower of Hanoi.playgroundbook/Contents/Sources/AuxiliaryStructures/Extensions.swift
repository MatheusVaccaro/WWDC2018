//
//  Extensions.swift
//  Hanoi
//
//  Created by Matheus Vaccaro on 20/03/18.
//  Copyright © 2018 Matheus Vaccaro. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static func random() -> UIColor {
        let red = CGFloat(arc4random()) / CGFloat(UINT32_MAX)
        let green = CGFloat(arc4random()) / CGFloat(UINT32_MAX)
        let blue = CGFloat(arc4random()) / CGFloat(UINT32_MAX)
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
}
