//
//  ViewController.swift
//  EVAKit
//
//  Created by LuKane on 2022/11/25.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.orange
        
        let gesture = EVAGestureRecognizer.init()
        gesture.gestureActionBlock { gesture, state in
            
        }
        view.addGestureRecognizer(gesture)
    }
}
