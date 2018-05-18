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
        // Use your API token and user id to get a token for the user
        let apiToken = "[your_api_token]";
        let userId = 000000; // user id

        let userTokenRequest = buildUserTokenRequest(apiToken: apiToken, userId: userId)
        
        let task = URLSession.shared.dataTask(with: userTokenRequest) { data, response, error in
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 201 {
                print("Bad response: \(response!)")
            } else {
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                    let userToken = (jsonResult["iframe_token"] as? [String: Any])?["token"] as? String
                    DispatchQueue.main.async {
                        let quovoConnect = QuovoConnectSDK()
                        quovoConnect.completionHandler = self.complete
                        quovoConnect.customTitle = "Quovo Connect"
                        quovoConnect.parentViewController = UIApplication.shared.keyWindow!.rootViewController
                        quovoConnect.launch(token: userToken!, options:["testInstitutions":1,"singleSync":1])
                    }
                } catch {
                    print("Token parsing failed")
                }
            }
        }
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buildUserTokenRequest(apiToken: String, userId: Int) -> URLRequest {
        let iframeTokenUrl = URL(string: "https://api.quovo.com/v2/iframe_token");
        var iframeTokenRequest = URLRequest(url:iframeTokenUrl!);
        iframeTokenRequest.httpMethod = "POST";
        iframeTokenRequest.setValue("application/json", forHTTPHeaderField: "Content-Type");
        iframeTokenRequest.setValue("Bearer " + apiToken, forHTTPHeaderField: "Authorization");
        let jsonData = try? JSONSerialization.data(withJSONObject: ["user": userId])
        iframeTokenRequest.httpBody =  jsonData;
        return  iframeTokenRequest;
    }

}

