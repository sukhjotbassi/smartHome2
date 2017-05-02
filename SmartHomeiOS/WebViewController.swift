//
//  WebViewController.swift
//  SmartHomeiOS
//
//  Created by Sukhjot Bassi on 5/1/17.
//  Copyright © 2017 Sukhjot Bassi. All rights reserved.
//

import Foundation
import UIKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var webViewTutorial: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let url = URL(string: "http://192.168.0.100/")

        if let unwrappedURL = url {
            
            let request = URLRequest(url: unwrappedURL)
            let session = URLSession.shared
            
            let task = session.dataTask(with: request) { (data, response, error) in
                
                if error == nil {
                    
                    self.webViewTutorial.loadRequest(request)
                    
                } else {
                    
                    print("ERROR: \(error)")
                    
                }
                
            }
            
            task.resume()
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

