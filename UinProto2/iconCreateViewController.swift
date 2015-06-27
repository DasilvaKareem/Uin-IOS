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
    
    var iconId5 = [Int]()
    var iconImage5 = [UIImage]()
    var inActiveImage5 = [UIImage]()
    var caption5 = [String]()
    
    var iconId6 = [Int]()
    var iconImage6 = [UIImage]()
    var inActiveImage6 = [UIImage]()
    var caption6 = [String]()
    
    
    
    @IBAction func submitData(sender: AnyObject) {
        self.performSegueWithIdentifier("event4", sender: self)
    }

    
    //Gets data from parse and display images into collection view
    func getIcons(){
        var query = PFQuery(className: "kareem")
        query.fromLocalDatastore()
        query.findObjectsInBackgroundWithBlock({
            (objects:[AnyObject]! , error: NSError!) -> Void in
            if error == nil {
                
                var placeHolder = (PFFile)()
                println("got objects")
                for object in objects {
                    println(object)
                    if self.iconId.count > 3 {
                        if self.iconId2.count > 3 {
                            if self.iconId3.count > 3 {
                                if self.iconId4.count > 3 {
                                    self.iconId5.append(object["tagid"] as! Int)
                                }
                                self.iconId4.append(object["tagid"] as! Int)
                            }
                              self.iconId3.append(object["tagid"] as! Int)
                            
                        }
                         self.iconId2.append(object["tagid"] as! Int)
                    }
                    self.iconId.append(object["tagid"] as! Int) //Get tag id
           
                    if self.caption.count > 3 {
                        if self.caption2.count > 3 {
                            if self.caption3.count > 3 {
                                if self.caption4.count > 3 {
                                    if self.caption5.count > 3 {
                                        self.caption6.append(object["caption"] as! String)
                                    }
                                    self.caption5.append(object["caption"] as! String)
                                }
                                self.caption4.append(object["caption"] as! String)
                            }
                            self.caption3.append(object["caption"] as! String)
                        }
                            self.caption2.append(object["caption"] as! String)
                    } else {
                            self.caption.append(object["caption"] as! String)
                    }
                


                    //Gets the inactive from parse and makes into an image
                    placeHolder = object["inactiveImage"] as! PFFile
                   placeHolder.getDataInBackgroundWithBlock({
                        (imageData: NSData!, error: NSError!) -> Void in
                        if error == nil {
                            
                            if self.inActiveImage.count > 3 {
                                if self.inActiveImage2.count > 3 {
                                    self.inActiveImage3.append(UIImage(data: imageData)!)
                                }
                                self.inActiveImage2.append(UIImage(data: imageData)!)
                            }
                          
                          
                            self.inActiveImage.append(UIImage(data: imageData)!)

                        }
                    })
                    
                   
                }
                //println(self.iconId)
                println(self.caption)
               self.iconCollection.reloadData()
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
        
      
        println(indexPath.section)
        
        if indexPath.section == 0 {
            if caption.count != 0 {
                 cell.iconImage.image = inActiveImage[indexPath.row]
              cell.iconCaption.text = caption[indexPath.row]
            }
            
        } else {
            if indexPath.section == 1 {
                if caption2.count != 0 {
                    cell.iconImage.image = inActiveImage2[indexPath.row]
                    cell.iconCaption.text = caption2[indexPath.row]
                }
                
            } else {
                if indexPath.section == 2 {
                    if caption3.count != 0 {
                      cell.iconImage.image = inActiveImage3[indexPath.row]
                        cell.iconCaption.text = caption3[indexPath.row]
                    }
                    
                } else {
                    if indexPath.section == 3 {
                        if caption4.count != 0 {
                            cell.iconCaption.text = caption4[indexPath.row]
                        }
                    } else {
                        if indexPath.section == 4 {
                            if caption5.count != 0 {
                                cell.iconCaption.text = caption5[indexPath.row]
                            }
                        } else {
                            if indexPath.section == 5 {
                                if caption6.count != 0 {
                                   // cell.iconCaption.text = caption6[indexPath.row]
                                }
                            }

                        }

                    }
                }
            }
        }
       
        
       // cell.iconCaption.text = caption[2]
        
       
        return cell
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        return 3
    }
    
     func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    
        return 7
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
