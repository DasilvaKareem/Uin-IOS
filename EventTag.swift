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
    
    @IBOutlet weak var tagCollection: UICollectionView!
    //Counter setup
    var counter = 0
    
    func keepTrack(){
        var tags = [Int]()
        
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
    
    var iconId7 = [Int]()
    var iconImage7 = [UIImage]()
    var inActiveImage7 = [UIImage]()
    var caption7 = [String]()
    
    
    
    @IBAction func submitData(sender: AnyObject) {
        if tags.count != 3 {
            println("You can only have 3 tags selected")
        } else {
            firstIcon = tags[0]
            secondIcon = tags[1]
            thirdIcon = tags[2]
            self.performSegueWithIdentifier("event4", sender: self)
        }
    }
    
    
    //Gets data from parse and display images into collection view
    func getIcons(){
        var query = PFQuery(className: "tagCollection")
        query.fromLocalDatastore().fromPinWithName("tags")
        query.orderByAscending("tagId")
        var objects = query.findObjects()
        
        
        var placeHolder = (PFFile)()
        println("got objects")
        for object in objects {
            
            if self.iconId.count > 2 {
                if self.iconId2.count > 2 {
                    if self.iconId3.count > 2 {
                        if self.iconId4.count > 2 {
                            if self.iconId5.count > 2  {
                                if self.iconId6.count > 2  {
                                    self.iconId7.append(object["tagid"] as! Int)
                                }
                                self.iconId6.append(object["tagid"] as! Int)
                            }
                            self.iconId5.append(object["tagid"] as! Int)
                        }
                        self.iconId4.append(object["tagid"] as! Int)
                    }
                    self.iconId3.append(object["tagid"] as! Int)
                    
                }
                self.iconId2.append(object["tagid"] as! Int)
            } else {
                self.iconId.append(object["tagid"] as! Int) //Get tag id
            }
            
            
            if self.caption.count > 2  {
                if self.caption2.count > 2 {
                    if self.caption3.count > 2 {
                        if self.caption4.count > 2 {
                            if self.caption5.count > 2 {
                                if self.caption6.count > 2 {
                                    self.caption7.append(object["caption"] as! String)
                                }
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
            
            if self.inActiveImage.count >= 3 {
                
                if self.inActiveImage2.count >= 3 {
                    if self.inActiveImage3.count >= 3 {
                        if self.inActiveImage4.count >= 3 {
                            if self.inActiveImage5.count >= 3 {
                                if self.inActiveImage6.count >= 3 {
                                    self.inActiveImage7.append(UIImage(data: object["inactiveImage"] as! NSData)!)
                                }
                                self.inActiveImage6.append(UIImage(data: object["inactiveImage"] as! NSData)!)
                            }
                            self.inActiveImage5.append(UIImage(data: object["inactiveImage"] as! NSData)!)
                        }
                        self.inActiveImage4.append(UIImage(data: object["inactiveImage"] as! NSData)!)
                    }
                    self.inActiveImage3.append(UIImage(data: object["inactiveImage"] as! NSData)!)
                }
                
                self.inActiveImage2.append(UIImage(data: object["inactiveImage"] as! NSData)!)
            } else {
                self.inActiveImage.append(UIImage(data:object["inactiveImage"] as! NSData)!)
            }
            
           // println(inActiveImage.count)
            
            
            
            
            
            if self.iconImage.count >= 3 {
                
                if self.iconImage2.count >= 3 {
                    if self.iconImage3.count >= 3 {
                        if self.iconImage4.count >= 3 {
                            if self.iconImage5.count >= 3 {
                                if self.iconImage6.count >= 3 {
                                    self.iconImage7.append(UIImage(data: object["activeImage"] as! NSData)!)
                                }
                                self.iconImage6.append(UIImage(data: object["activeImage"] as! NSData)!)
                            }
                            self.iconImage5.append(UIImage(data: object["activeImage"] as! NSData)!)
                        }
                        self.iconImage4.append(UIImage(data: object["activeImage"] as! NSData)!)
                    }
                    self.iconImage3.append(UIImage(data: object["activeImage"] as! NSData)!)
                }
                
                self.iconImage2.append(UIImage(data: object["activeImage"] as! NSData)!)
            } else {
                self.iconImage.append(UIImage(data:object["activeImage"] as! NSData)!)
            }
            
            
            
        }
      
        self.tagCollection.reloadData()
        
    }
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
       // getIcons()
        //self.iconCollection.reloadData()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:iconCell = tagCollection.dequeueReusableCellWithReuseIdentifier("icon", forIndexPath: indexPath) as! iconCell
        
        
        //println(caption3.count)
        println("HEY DUDE")
        println(indexPath.row)
        if indexPath.section == 0 {
            if caption.count != 0 {
                cell.iconImage.image = inActiveImage[indexPath.row]
                cell.iconCaption.text = "pooooop"
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
                            cell.iconImage.image = inActiveImage4[indexPath.row]
                            cell.iconCaption.text = caption4[indexPath.row]
                        }
                    } else {
                        if indexPath.section == 4 {
                            if caption5.count != 0 {
                                cell.iconImage.image = inActiveImage5[indexPath.row]
                                cell.iconCaption.text = caption5[indexPath.row]
                            }
                        } else {
                            if indexPath.section == 5 {
                                if caption6.count != 0 {
                                    cell.iconCaption.text = caption6[indexPath.row]
                                    cell.iconImage.image = inActiveImage6[indexPath.row]
                                }
                            } else {
                                if indexPath.section == 6 {
                                    cell.iconCaption.text = caption7[indexPath.row]
                                    cell.iconImage.image = inActiveImage7[indexPath.row]
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
    var tags = [Int]()
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //keepTrack()
        
        var cell:iconCell = tagCollection.cellForItemAtIndexPath(indexPath) as! iconCell
        
        
        //only allows 3 icons to be selected also selects icons
        
        
        if indexPath.section == 0 {
            if caption.count != 0 {
                //Checks if the tag is already selected
                if cell.iconImage.image == iconImage[indexPath.row] {
                    //the icon is already clicked
                    cell.iconImage.image = inActiveImage[indexPath.row]
                    //find the same tag id then removes it
                    var i = 0
                    for tag in tags {
                        if tag == iconId[indexPath.row] {
                            tags.removeAtIndex(i)
                        }
                        i++
                    }
                } else {
                    //the icon is not selected
                    cell.iconImage.image = iconImage[indexPath.row]
                    tags.append(self.iconId[indexPath.row])
                }
                
                
            }
            
        } else {
            if indexPath.section == 1 {
                if caption.count != 0 {
                    //Checks if the tag is already selected
                    if cell.iconImage.image == iconImage2[indexPath.row] {
                        //the icon is already clicked
                        cell.iconImage.image = inActiveImage2[indexPath.row]
                        //find the same tag id then removes it
                        var i = 0
                        for tag in tags {
                            if tag == iconId2[indexPath.row] {
                                tags.removeAtIndex(i)
                            }
                            i++
                        }
                    } else {
                        //the icon is not selected
                        cell.iconImage.image = iconImage2[indexPath.row]
                        tags.append(self.iconId[indexPath.row])
                    }
                    
                    
                }
                
            } else {
                if indexPath.section == 2 {
                    if caption.count != 0 {
                        //Checks if the tag is already selected
                        if cell.iconImage.image == iconImage3[indexPath.row] {
                            //the icon is already clicked
                            cell.iconImage.image = inActiveImage3[indexPath.row]
                            //find the same tag id then removes it
                            var i = 0
                            for tag in tags {
                                if tag == iconId3[indexPath.row] {
                                    tags.removeAtIndex(i)
                                }
                                i++
                            }
                        } else {
                            //the icon is not selected
                            cell.iconImage.image = iconImage3[indexPath.row]
                            tags.append(self.iconId3[indexPath.row])
                        }
                        
                        
                    }
                    
                } else {
                    if indexPath.section == 3 {
                        if caption.count != 0 {
                            //Checks if the tag is already selected
                            if cell.iconImage.image == iconImage4[indexPath.row] {
                                //the icon is already clicked
                                cell.iconImage.image = inActiveImage4[indexPath.row]
                                //find the same tag id then removes it
                                var i = 0
                                for tag in tags {
                                    if tag == iconId[indexPath.row] {
                                        tags.removeAtIndex(i)
                                    }
                                    i++
                                }
                            } else {
                                //the icon is not selected
                                cell.iconImage.image = iconImage4[indexPath.row]
                                tags.append(self.iconId4[indexPath.row])
                            }
                            
                            
                        }
                    } else {
                        if indexPath.section == 4 {
                            if caption.count != 0 {
                                //Checks if the tag is already selected
                                if cell.iconImage.image == iconImage5[indexPath.row] {
                                    //the icon is already clicked
                                    cell.iconImage.image = inActiveImage5[indexPath.row]
                                    //find the same tag id then removes it
                                    var i = 0
                                    for tag in tags {
                                        if tag == iconId5[indexPath.row] {
                                            tags.removeAtIndex(i)
                                        }
                                        i++
                                    }
                                } else {
                                    //the icon is not selected
                                    cell.iconImage.image = iconImage5[indexPath.row]
                                    tags.append(self.iconId[indexPath.row])
                                }
                                
                                
                            }
                        } else {
                            if indexPath.section == 5 {
                                if caption.count != 0 {
                                    //Checks if the tag is already selected
                                    if cell.iconImage.image == iconImage6[indexPath.row] {
                                        //the icon is already clicked
                                        cell.iconImage.image = inActiveImage6[indexPath.row]
                                        //find the same tag id then removes it
                                        var i = 0
                                        for tag in tags {
                                            if tag == iconId6[indexPath.row] {
                                                tags.removeAtIndex(i)
                                            }
                                            i++
                                        }
                                    } else {
                                        //the icon is not selected
                                        cell.iconImage.image = iconImage6[indexPath.row]
                                        tags.append(self.iconId6[indexPath.row])
                                    }
                                    
                                    
                                }
                            } else {
                                if indexPath.section == 6 {
                                    if caption.count != 0 {
                                        //Checks if the tag is already selected
                                        if cell.iconImage.image == iconImage7[indexPath.row] {
                                            //the icon is already clicked
                                            cell.iconImage.image = inActiveImage7[indexPath.row]
                                            //find the same tag id then removes it
                                            var i = 0
                                            for tag in tags {
                                                if tag == iconId7[indexPath.row] {
                                                    tags.removeAtIndex(i)
                                                }
                                                i++
                                            }
                                        } else {
                                            //the icon is not selected
                                            cell.iconImage.image = iconImage7[indexPath.row]
                                            tags.append(self.iconId7[indexPath.row])
                                        }
                                        
                                        
                                    }
                                }
                            }
                            
                        }
                        
                    }
                }
            }
        }
        
        
        println(tags)
        
        
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