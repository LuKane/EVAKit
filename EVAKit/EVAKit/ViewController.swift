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
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let vc = TestController()
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
