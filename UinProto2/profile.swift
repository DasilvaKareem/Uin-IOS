//
//  profile.swift
//  UinProto2
//
//  Created by Kareem Dasilva on 1/5/15.
//  Copyright (c) 2015 Kareem Dasilva. All rights reserved.
//

import UIKit

class profile: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var profilePic: UIImageView!
    
    var photoSelected:Bool! = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoSelected = true
        
        profilePic.image = UIImage(named: "315px-Blank_woman_placeholder.svg")

        // Do any additional setup after loading the view.
    }

    
    @IBAction func upload(sender: AnyObject) {
        
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        
        self.presentViewController(image, animated: true, completion: nil)
        
    }
    
    
    @IBAction func post(sender: AnyObject) {
        
        

        
        var profile = PFUser.currentUser()
        let imageData = UIImagePNGRepresentation(self.profilePic.image)
        
        let imageFile = PFFile(name: "image.png", data: imageData)
        
        profile["profilepic"] = imageFile
        profile.saveInBackgroundWithBlock{
            (success:Bool!, profileError:NSError!) -> Void in
            
            if success == false {
                println("fail")
                
            }  else {
               
                self.photoSelected = true
                
                self.profilePic.image = UIImage(named: "315px-Blank_woman_placeholder.svg")
                println("gj")
                
            }
            
            
        }
        
        
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        println("Image selected")
        self.dismissViewControllerAnimated(true, completion: nil)
        
        profilePic.image = image
        
        photoSelected = true
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
