//
//  SignInViewController.swift
//  FUMC
//
//  Created by Andrew Branch on 7/31/16.
//  Copyright © 2016 FUMC Pensacola. All rights reserved.
//

import UIKit
import DigitsKit

protocol SignInDelegate {
    func signInViewController(viewController: SignInViewController, grantedKnownUser token: AccessToken)
    func signInViewController(viewController: SignInViewController, grantedUnknownUser token: AccessToken)
    func signInViewControllerCouldNotGrantToken(viewController viewController: SignInViewController)
    func signInViewController(viewController: SignInViewController, failedWith error: NSError)
}

class SignInViewController: UIViewController {

    @IBOutlet var signInButton: UIButton?
    var requestScopes: [API.Scopes]!
    var delegate: SignInDelegate!
    
    override func viewDidLoad() {
        #if DEBUG
            let resetDigitsButton = UIButton(frame: CGRect(x: 40, y: 20, width: 20, height: 20))
            resetDigitsButton.setTitle("Mock Digits Unknown", forState: UIControlState.Normal)
            resetDigitsButton.addTarget(self, action: #selector(SignInViewController.mockDigitsWithUnknownUser), forControlEvents: .TouchUpInside)
            resetDigitsButton.backgroundColor = UIColor.greenColor()
            view.addSubview(resetDigitsButton)
            
            let resetFacebookButton = UIButton(frame: CGRect(x: 20, y: 20, width: 20, height: 20))
            resetFacebookButton.setTitle("Reset Facebook", forState: .Normal)
            resetFacebookButton.addTarget(self, action: #selector(SignInViewController.resetFacebook), forControlEvents: .TouchUpInside)
            resetFacebookButton.backgroundColor = UIColor.blueColor()
            view.addSubview(resetFacebookButton)
        #endif
    }
    
    @IBAction func didTapSignInButton() {
        signInButton!.enabled = false
        Digits.sharedInstance().authenticateWithCompletion { session, error in
            guard error == nil else {
                return self.delegate.signInViewController(self, failedWith: error)
            }
            
            API.shared().getAuthToken(session, scopes: self.requestScopes) { token in
                do {
                    let token = try token.value()
                    API.shared().accessToken = token
                    
                    // Logged in and has permission to read directory.
                    if (token.needsVerification) {
                        // New user, should confirm that identity is correct
                        self.delegate!.signInViewController(self, grantedUnknownUser: token)
                    } else {
                        // Known user, just hide the gate
                        self.delegate.signInViewController(self, grantedKnownUser: token)
                    }
                } catch API.Error.Unauthorized {
                    // Could not grant requested scopes; start access request
                    self.delegate.signInViewControllerCouldNotGrantToken(viewController: self)
                } catch let error as NSError {
                    self.delegate.signInViewController(self, failedWith: error)
                }
            }
        }
    }
    
    func resetFacebook() {
        FBSDKAccessToken.setCurrentAccessToken(nil)
    }
    
    func mockDigitsWithUnknownUser() {
        Digits.sharedInstance().logOut()
        let defaultSession = DGTDebugConfiguration.defaultDebugSession()
        let phone = Array(count: 7, repeatedValue: "").map({ _ in String(arc4random_uniform(10)) }).joinWithSeparator("")
        Digits.sharedInstance().debugOverrides = DGTDebugConfiguration(successStateWithDigitsSession: DGTSession(
            authToken: defaultSession.authToken,
            authTokenSecret: defaultSession.authTokenSecret,
            userID: defaultSession.userID,
            phoneNumber: "+1555\(phone)"
        ))
    }
}
