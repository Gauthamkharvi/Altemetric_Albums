//
//  UIViewControllerExtension.swift
//  Altimetric
//
//  Created by gautham kharvi on 05/09/20.
//  Copyright © 2020 gautham kharvi. All rights reserved.
//

import UIKit

extension UIViewController {
    
    static func instatiate<T>() -> T {
        let storyBoard = UIStoryboard(name: "Main", bundle: .main)
        let vc = storyBoard.instantiateViewController(identifier: "\(T.self)") as! T
        return vc
    }
}
