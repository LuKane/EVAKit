//
//  TestController.swift
//  EVAKit
//
//  Created by LuKane on 2022/11/26.
//

import UIKit

class TestController: UIViewController {
    private var timerID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.green
        
        timerID = EVATimer.timer(delay: 5, time: 3, mainThread: true, repeats: true, block: { 
            print("timer run")
        })
    }
    
    deinit {
        print("deinit")
        EVATimer.cancelEVATime(timerID: timerID)
    }
}
