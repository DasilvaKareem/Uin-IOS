//
//  iconCreateViewController.swift
//  Uin
//
//  Created by Sir Lancelot on 6/15/15.
//  Copyright (c) 2015 Kareem Dasilva. All rights reserved.
//

import UIKit

class iconCreateViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {


    
    @IBOutlet weak var iconCollection: UICollectionView!
    
    //Counter setup
    var counter = 0
    
    func keepTrack(){
        if counter != 3 {
            counter++
        }
    }
    //Info to hold images
    var iconId = [Int]()
    var iconImage = [UIImage]()
    var inActiveImage = [UIImage]()
    var caption = [String]()
    
    var iconId2 = [Int]()
    var iconImage2 = [UIImage]()
    var inActiveImage2 = [UIImage]()
    var caption2 = [String]()
    
    var iconId3 = [Int]()
    var iconImage3 = [UIImage]()
    var inActiveImage3 = [UIImage]()
    var caption3 = [String]()
    
    var iconId4 = [Int]()
    var iconImage4 = [UIImage]()
    var inActiveImage4 = [UIImage]()
    var caption4 = [String]()
    
    //Gets data from parse and display images into collection view
    func getIcons(){
        var query = PFQuery(className: "EventTag")
        query.findObjectsInBackgroundWithBlock({
            (objects:[AnyObject]! , error: NSError!) -> Void in
            if error == nil {
                
                var placeHolder = (PFFile)()
                println("got objects")
                for object in objects {
                    if self.iconId.count < 7 {
                        if self.iconId2.count < 7 {
                              self.iconId3.append(object["tagId"] as! Int)
                        }
                         self.iconId2.append(object["tagId"] as! Int)
                    }
                    self.iconId.append(object["tagId"] as! Int) //Get tag id
           
                    if self.caption.count < 7 {
                        if self.caption2.count < 7 {
                            self.caption3.append(object["caption"] as! String)
                        } else {
                            self.caption2.append(object["caption"] as! String)
                        }
                     
                    }
                    self.caption.append(object["caption"] as! String) // get the caption
                    //Gets the active from parse and makes into an image
                    placeHolder = object["activeImage"] as! PFFile
                    placeHolder.getDataInBackgroundWithBlock({
                        (imageData: NSData!, error: NSError!) -> Void in
                        if error == nil {
                            if self.iconImage.count < 7 {
                                if self.iconImage2.count < 7 {
                                    self.iconImage3.append(UIImage(data: imageData)!)
                                }
                                self.iconImage2.append(UIImage(data: imageData)!)
                            }
                          
                            
                           self.iconImage.append(UIImage(data: imageData)!)
                            
                        }
                    })
                    
                    //Gets the inactive from parse and makes into an image
                    placeHolder = object["inactiveImage"] as! PFFile
                    placeHolder.getDataInBackgroundWithBlock({
                        (imageData: NSData!, error: NSError!) -> Void in
                        if error == nil {
                            if self.inActiveImage.count < 7 {
                                if self.inActiveImage2.count < 7 {
                                    self.inActiveImage3.append(UIImage(data: imageData)!)
                                }
                                self.inActiveImage2.append(UIImage(data: imageData)!)
                            }
                          
                          
                            self.inActiveImage.append(UIImage(data: imageData)!)

                        }
                    })
                    
                   
                }
                //println(self.iconId)
                //println(self.caption)
                //self.iconCollection.reloadData()
            } else {
                println(error.debugDescription)
            }
        })
    }
    override func viewDidLoad() {
        getIcons()
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:iconCell = iconCollection.dequeueReusableCellWithReuseIdentifier("icon", forIndexPath: indexPath) as! iconCell
        
        cell.backgroundColor = UIColor.blackColor()
        println(indexPath.section)
        cell.iconCaption.textColor = UIColor.whiteColor()
        if indexPath.section == 0 {
            if caption.count != 0 {
              cell.iconCaption.text = caption[indexPath.row]
            }
            
        }
        if indexPath.section == 1 {
            if caption.count != 0 {
               cell.iconCaption.text = caption2[indexPath.row]
            }
          
        }
        if indexPath.section == 2 {
            if caption.count != 0 {
                cell.iconCaption.text = caption3[indexPath.row]
            }
            
        }
        
       // cell.iconCaption.text = caption[2]
        
       
        return cell
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        return 7
    }
    
     func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    
        return 3
    }


    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        keepTrack()
        println(counter)
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
class iconCell:UICollectionViewCell {
    
    @IBOutlet weak var iconImage: UIImageView!
    
    @IBOutlet weak var iconCaption: UILabel!
    
}
