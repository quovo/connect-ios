//
//  ViewController.swift
//  QuovoConnectTestProject
//
//  Copyright © 2017 Quovo. All rights reserved.
//

import UIKit
import QuovoConnectSDK

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    func complete(callback: String, response: NSDictionary) {
        print(callback)
        print(response)
    }
    
    @IBAction func launch(_ sender: Any) {
        let quovoConnect = QuovoConnectSDK()
        
        quovoConnect.completionHandler = complete
    quovoConnect.launch(token:"IFRAME TOKEN HERE", options:["testInstitutions":1])
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

