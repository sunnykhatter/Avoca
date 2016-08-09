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
                
                
                if (error == nil) {
                    
                    let storage = FIRStorage.storage()
                        
                    let storageRef = storage.referenceForURL("gs://avoca-7815d.appspot.com")
                    
                    let profilePicRef = storageRef.child(user!.uid + "/profile_pic_small.jpg")
                    
                    let userID = user?.uid

                    let databaseRef = FIRDatabase.database().reference()
                    
                    databaseRef.child("users")
                    
                    databaseRef.child("users").child(userID!).child("profile_pic_small").observeSingleEventOfType(.Value, withBlock: {
                        (snapshot) in
                        
                        let profile_pic = snapshot.value as? String?
                        
                        if (profile_pic == nil) {
                            if let imageData = NSData(contentsOfURL: user!.photoURL!) {
                                let uploadTask = profilePicRef.putData(imageData, metadata:nil){
                                    metadata, error in
                                    
                                    if (error == nil){
                                        let downloadURL = metadata!.downloadURL
                                        databaseRef.child("users").child("\(user!.uid)/profile_pic_small").setValue(downloadURL()!.absoluteString)
                                    } else {
                                        print("error in downloading image")
                                    }
                                }
                            }
                            
                            
                            var emptyDictionary = [String: String]()
                            databaseRef.child("users").child("\(user!.uid)/name").setValue(user?.displayName)
                            databaseRef.child("users").child("\(user!.uid)/followers").setValue(0)
                            databaseRef.child("users").child("\(user!.uid)/following").setValue(0)
                            
                            
                        }
                        
                        
                    })
                    
                        
                        
    
                
                    
                }
                
            }
        }
        
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User did log out")
    }


}
