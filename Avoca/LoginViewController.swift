//
//  LoginViewController.swift
//  Avoca
//
//  Created by Lakshay Khatter on 8/5/16.
//  Copyright © 2016 Lakshay Khatter. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase



class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var loginButton: FBSDKLoginButton = FBSDKLoginButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginButton.hidden = true
        
        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
            if let user = user {
                // User is signed in. Redirect them
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let homeViewController: UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("HomeView")
                self.presentViewController(homeViewController, animated: true, completion: nil)
                
                
            } else {
                // No user is signed in.
                self.loginButton.center = self.view.center
                self.loginButton.readPermissions = ["public_profile", "email", "user_friends"]
                self.loginButton.delegate = self
                self.view!.addSubview(self.loginButton)
                self.loginButton.hidden = false
            }
        }


        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        self.loginButton.hidden = true
        spinner.startAnimating()
        
        if (error != nil) {
            // Handle errors here
            self.loginButton.hidden = false
            spinner.stopAnimating()
        } else if (result.isCancelled) {
            self.loginButton.hidden = false
            spinner.stopAnimating()
        } else {
            print("User loggedin!")
            let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
            
            
            FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
                print("user logged into firebase app")
            }
        }
        
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User did log out")
    }


}
