//
//  MediaWebViewController.swift
//  FUMCApp
//
//  Created by Andrew Branch on 10/30/14.
//  Copyright (c) 2014 FUMC Pensacola. All rights reserved.
//

import UIKit

class MediaWebViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet var webView: UIWebView?
    
    var url: NSURL?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView!.delegate = self
        
        if let url = self.url {
            var request = NSURLRequest(URL: url)
            self.webView!.loadRequest(request)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}