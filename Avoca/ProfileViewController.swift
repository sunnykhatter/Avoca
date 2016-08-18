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
    
    @IBOutlet weak var follow: UIButton!
    
    @IBOutlet weak var logout_button: UIBarButtonItem!
    
    var receivedString : String! = nil

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Profile"
        
        
    
        
        self.profileImageView.clipsToBounds = true


        if (receivedString == nil) {
            
        
        
        if let user = FIRAuth.auth()?.currentUser {
            // User is signed in.
            
            
            
            let name = user.displayName
            let email = user.email
            let photoUrl = user.photoURL
            let uid = user.uid; //firebase UID
            self.follow.hidden = true
            
            self.name_label.text = name
            self.name_label.adjustsFontSizeToFitWidth = true
            self.name_label.font = UIFont(name: "Montserrat-Regular",size:18)

            //Firebase References
            let storage = FIRStorage.storage()
            
            let storageRef = storage.referenceForURL("gs://avoca-7815d.appspot.com")
            
            let profilePicRef = storageRef.child(user.uid+"/profile_pic")

            
            
            profilePicRef.dataWithMaxSize(1 * 1024 * 1024) { (data, error) -> Void in
                if (error != nil) {
                    // Uh-oh, an error occurred!
                    print("unable to download images")
                    
                } else {
                    // Data for "images/island.jpg" is returned
                    // ... let islandImage: UIImage! = UIImage(data: data!)
                    
                    if (data != nil) {
                        self.profileImageView.image = UIImage(data:data!)
                    }
                }
            }
            
            if (self.profileImageView.image == nil) {
            
            var profilePic = FBSDKGraphRequest(graphPath: "me/picture", parameters: ["height":300, "width":300,"redirect":false ], HTTPMethod: "GET")
           
            
            profilePic.startWithCompletionHandler({ (connection, result, error) in
                
                if (error == nil) {
                    let dictionary = result as? NSDictionary
                    let data = dictionary?.objectForKey("data")
                    
                    let urlPic = data?.objectForKey("url")! as! String
                    
                    if let imageData = NSData(contentsOfURL: NSURL(string:urlPic)!) {
                        
                        let uploadTask = profilePicRef.putData(imageData, metadata:nil) {
                            metadata, error in
                            
                            if (error == nil) {
                                // Can receive zie, content type or the download URL
                                let downloadURL = metadata!.downloadURL
                                
                            } else {
                                print("error in downloading image")
                            }
                        }
                        
                        self.profileImageView.image = UIImage(data:imageData)
                    }
                    
                    
                    
                }
                
                
            })
        }
        
        
        
        } else {
            //no user is signed in
      
        }
        
        } else {
            // set the images to the frame
            print(receivedString)
            self.follow.hidden = false
            self.navigationItem.rightBarButtonItems = nil

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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        
//        var databaseRef = FIRDatabase.database().reference()
//        
//        databaseRef.child("users/evYMXgumxOUXwKMY6yXQjyHQuHL2").observeEventType( .Value) { (snapshot) in
//            print(snapshot)
//        }
        
        var segueID = segue.identifier
        let secondViewController = segue.destinationViewController as! Followers_FollowingTableViewController

        if (segueID == "Followers") {
            secondViewController.receivedString = "Followers"
            
            
        } else if (segueID == "Following"){
            secondViewController.receivedString = "Following"

        }
        
        
        
       
        
      
    }

    


}
