//
//  ProfileViewController.swift
//  Avoca
//
//  Created by Lakshay Khatter on 8/5/16.
//  Copyright © 2016 Lakshay Khatter. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKCoreKit


class ProfileViewController: UIViewController {
    @IBOutlet weak var name_label: UILabel!
    
    @IBOutlet weak var follower_button: UIButton!
    
    @IBOutlet weak var following_button: UIButton!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Profile"

        self.profileImageView.clipsToBounds = true
        
        if let user = FIRAuth.auth()?.currentUser {
            // User is signed in.
            
            let name = user.displayName
            let email = user.email
            let photoUrl = user.photoURL
            let uid = user.uid; //firebase UID
            
            self.name_label.text = name
            self.name_label.adjustsFontSizeToFitWidth = true
            
            let data = NSData(contentsOfURL: photoUrl!)
            self.profileImageView.image = UIImage(data:data!)
            
            
        } else {
            // No user is signed in.
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func logout(sender: AnyObject) {
        //signs user out of firebase
        try! FIRAuth.auth()!.signOut()
        FBSDKAccessToken.setCurrentAccessToken(nil)
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController: UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("LoginView")
        self.presentViewController(loginViewController, animated: true, completion: nil)

        
        

    }

    


}
