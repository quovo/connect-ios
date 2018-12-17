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
    
    func error(errorType: String, errorCode: Int, errorMessage: String) {
        print(errorMessage)
    }
    
    @IBAction func launch(_ sender: Any) {
        // Use your API token and user id to get a token for the user
        let apiToken = "d0423077f6954e4f38e3556d1dab5b9cfc7e7fc5a8bb08a536809e192a94433f"
        let userId = 7498 // user id

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
                        quovoConnect.errorHandler = self.error
                        quovoConnect.parentViewController = UIApplication.shared.keyWindow!.rootViewController
                        quovoConnect.launch(token: userToken!, options:["testInstitutions":1])
                        // Customize navigation bar  with paramaters 1) Transparency  2) Color  3) Title
                        quovoConnect.customizeNavigationBarApperance(isTranslucent: true, backGroundColor: UIColor.white, customTitle: "Quovo Connect")
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

