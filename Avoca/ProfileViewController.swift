//
//  ProfileViewController.swift
//  Avoca
//
//  Created by Lakshay Khatter on 8/5/16.
//  Copyright © 2016 Lakshay Khatter. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKCoreKit
import FirebaseDatabase



class ProfileViewController: UIViewController, UICollectionViewDataSource{
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
            self.name_label.font = UIFont(name: "Montserrat-Regular",size:18)
            
            
            
//            follower_button.setTitle("FOLLOWINGS", forState:.Normal)

            let storage = FIRStorage.storage()
            
            let storageRef = storage.referenceForURL("gs://avoca-7815d.appspot.com")
            
            let profilePicReference = storageRef.child(user.uid + "/profile_pic.jpg")

            
            profilePicReference.dataWithMaxSize(1 * 1024 * 1024) { (data, error) -> Void in
                if (error == nil) {
                    print("Uh-oh, an error occurred!")
                    
                } else {
                    
                    if (data != nil){
                        self.profileImageView.image = UIImage(data:data!)
                    }
                    
                }
            }
            
            
            if (self.profileImageView.image == nil) {
                
            var profile_pic: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me/picture", parameters: ["height":100, "width":100,"redirect":false], HTTPMethod: "GET")
            profile_pic.startWithCompletionHandler({(connection, result, error) -> Void in
                
                if (error == nil) {
                    let dictionary = result as? NSDictionary
                    let data = dictionary?.objectForKey("data")
                    
                    let urlPic = (data?.objectForKey("url"))! as? String
                    
                    if let imageData = NSData(contentsOfURL: NSURL(string:urlPic!)!) {
                        
                        let profilePicReference = storageRef.child(user.uid + "/profile_pic.jpg")
                        
                        
                        let uploadTask  = profilePicReference.putData(imageData, metadata: nil, completion: { (metadata, errror) in
                            
                            if (error == nil) {
                                let downloadURL = metadata!.downloadURL
                                
                            } else {
                                print("Error in downloading image")
                            }
                        })

                        self.profileImageView.image = UIImage(data:imageData)
                        
                    }
                }
                
                
            })
        }
            
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
    
    //1
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //2
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    //3
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! UICollectionViewCell
        cell.backgroundColor = UIColor.blackColor()
        // Configure the cell
        return cell
    }

    


}
