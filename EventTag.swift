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
    var tags = [String]()
    //Info to hold images
    var iconId = ["8OXtrEEL7c","GawBDHRtfo","XYV5giSlCO"]
    var iconImage = [UIImage(named: "onCampus.png") , UIImage(named: "free.png") , UIImage(named: "food.png")]
    var inActiveImage = [UIImage(named: "oncampus2.png") , UIImage(named: "free2.png") , UIImage(named: "food2.png")]
    var caption = ["On Campus", "Free", "Food"]
    
    var iconId2 = ["Ymclya9lwu","AjosKs2UWi","mch3EIhozC"]
    var iconImage2 = [UIImage(named: "performance.png") , UIImage(named: "byob.png") , UIImage(named: "music.png")]
    var inActiveImage2 = [UIImage(named: "performance2.png") , UIImage(named: "byob2.png") , UIImage(named: "music2.png")]
    var caption2 = ["Performance","B.Y.O.B", "Music"]
    
    var iconId3 = ["V6fIqmoG05","a3pMl70t39","s5XU11BTs3"]
    var iconImage3 = [UIImage(named: "phil.png") , UIImage(named: "outdoors.png") , UIImage(named: "drinking.png")]
    var inActiveImage3 = [UIImage(named: "phil2.png") , UIImage(named: "outdoors2.png") , UIImage(named: "drinking2.png")]
    var caption3 = ["Philanthropy", "Outdoors", "Drinking"]
    
    var iconId4 = ["leITfmSo7E","f8ZpiOF9cg","wLt1TPYiyV"]
    var iconImage4 = [UIImage(named: "party.png") , UIImage(named: "conference.png") , UIImage(named: "religious.png")]
    var inActiveImage4 = [UIImage(named: "party2.png") , UIImage(named: "conference2.png") , UIImage(named: "religous2.png")]
    var caption4 = ["Party","Conference","Religious"]
    
    var iconId5 = ["6IkmbdKMnn","XiWPxYMwEO","D1nxE6j63a"]
    var iconImage5 = [UIImage(named: "meet.png") , UIImage(named: "games.png") , UIImage(named: "dance.png")]
    var inActiveImage5 = [UIImage(named: "meet2.png") , UIImage(named: "games2.png") , UIImage(named: "dance2.png")]
    var caption5 = ["Meet Up","Games","Dance"]
    
    var iconId6 = ["ayCBAVwQ93","u2EAfQk9Lf","BX9RsT3EpW"]
    var iconImage6 = [UIImage(named: "sales.png") , UIImage(named: "intramural.png") , UIImage(named: "tour.png")]
    var inActiveImage6 = [UIImage(named: "sales2.png") , UIImage(named: "intramural2.png") , UIImage(named: "tour2.png")]
    var caption6 = ["Sales Event","Intramural", "Tours"]
    
    var iconId7 = ["8HvnDADGY2","LP5fLvLurL","PvApxif2rw"]
    var iconImage7 = [UIImage(named: "run.png") , UIImage(named: "recruitment.png") , UIImage(named: "popcorn.png")]
    var inActiveImage7 = [UIImage(named: "walk2.png") , UIImage(named: "recruitment2.png") , UIImage(named: "popcorn2.png")]
    var caption7 = ["Walk/Run","Recruitment","Movie"]
    
    
    
    @IBAction func submitData(sender: AnyObject) {
        if tags.count != 3 {
            println("You can only have 3 tags selected")
        } else {
          //  firstIcon = tags[0]
            //secondIcon = tags[1]
            //thirdIcon = tags[2]
            self.performSegueWithIdentifier("event4", sender: self)
        }
    }
    
    
    //Gets data from parse and display images into collection view
    
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
        
        if indexPath.section == 0 {
           
                cell.iconImage.image = inActiveImage[indexPath.row]
               cell.iconCaption.text = caption[indexPath.row]
            
            
        } else {
            if indexPath.section == 1 {
               
                    cell.iconImage.image = inActiveImage2[indexPath.row]
                    cell.iconCaption.text = caption2[indexPath.row]
                
                
            } else {
                if indexPath.section == 2 {
                   
                        cell.iconImage.image = inActiveImage3[indexPath.row]
                        cell.iconCaption.text = caption3[indexPath.row]
                    
                    
                } else {
                    if indexPath.section == 3 {
                       
                            cell.iconImage.image = inActiveImage4[indexPath.row]
                            cell.iconCaption.text = caption4[indexPath.row]
                        
                    } else {
                        if indexPath.section == 4 {
                            
                                cell.iconImage.image = inActiveImage5[indexPath.row]
                                cell.iconCaption.text = caption5[indexPath.row]
                            
                        } else {
                            if indexPath.section == 5 {
                                
                                   cell.iconCaption.text = caption6[indexPath.row]
                                    cell.iconImage.image = inActiveImage6[indexPath.row]
                                
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
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //keepTrack()
        
        var cell:iconCell = tagCollection.cellForItemAtIndexPath(indexPath) as! iconCell
        
        
        //only allows 3 icons to be selected also selects icons
        
        
       if indexPath.section == 0 {
        if cell.iconImage.image == iconImage[indexPath.row] {
            //the icon is already clicked
            cell.iconImage.image = inActiveImage[indexPath.row]
            //find the same tag id then removes it
            for id in tags {
                var count = 0
                if id == iconId[indexPath.row] {
                    self.tags.removeAtIndex(count)
                }
                count++
            }//removes icon id from array
            
            
        } else {
            //the icon is not selected
            if tags.count == 3 {
                println("You can only have 3")
            } else {
                cell.iconImage.image = iconImage[indexPath.row]
                self.tags.append(iconId[indexPath.row])
            }
           
        }
        
        } else {
            if indexPath.section == 1 {
                if cell.iconImage.image == iconImage2[indexPath.row] {
                    //the icon is already clicked
                    cell.iconImage.image = inActiveImage2[indexPath.row]
                    //find the same tag id then removes it
                    for id in tags {
                        var count = 0
                        if id == iconId2[indexPath.row] {
                            self.tags.removeAtIndex(count)
                        }
                        count++
                    }
                    
                    
                    
                } else {
                    //the icon is not selected
                    if tags.count == 3 {
                        println("You can only have 3")
                    } else {
                         self.tags.append(iconId2[indexPath.row])
                         cell.iconImage.image = iconImage2[indexPath.row]
                    }
                   
                    
                }
            } else {
                if indexPath.section == 2 {
                    if cell.iconImage.image == iconImage3[indexPath.row] {
                        //the icon is already clicked
                        cell.iconImage.image = inActiveImage3[indexPath.row]
                        //find the same tag id then removes it
                        for id in tags {
                            var count = 0
                            if id == iconId3[indexPath.row] {
                                self.tags.removeAtIndex(count)
                            }
                            count++
                        }
                        
                        
                    } else {
                        //the icon is not selected
                        if tags.count == 3 {
                            println("You can only have 3")
                        } else {
                            self.tags.append(iconId3[indexPath.row])
                            cell.iconImage.image = iconImage3[indexPath.row]
                        }
                        
                        
                        
                    }
                    
                } else {
                    if indexPath.section == 3 {
                     
                            //Checks if the tag is already selected
                            if cell.iconImage.image == iconImage4[indexPath.row] {
                                //the icon is already clicked
                                cell.iconImage.image = inActiveImage4[indexPath.row]
                                //find the same tag id then removes it
                                for id in tags {
                                    var count = 0
                                    if id == iconId4[indexPath.row] {
                                        self.tags.removeAtIndex(count)
                                    }
                                    count++
                                }
                                    
                                
                            } else {
                                //the icon is not selected
                                if tags.count == 3 {
                                    println("You can only have 3")
                                } else {
                                   self.tags.append(iconId4[indexPath.row])
                                   cell.iconImage.image = iconImage4[indexPath.row]
                                }
                                
                               
                            }
                            
                            
                        
                    } else {
                        if indexPath.section == 4 {
                            if cell.iconImage.image == iconImage5[indexPath.row] {
                                //the icon is already clicked
                                cell.iconImage.image = inActiveImage5[indexPath.row]
                                //find the same tag id then removes it
                                for id in tags {
                                    var count = 0
                                    if id == iconId5[indexPath.row] {
                                        self.tags.removeAtIndex(count)
                                    }
                                    count++
                                }
                                
                                
                            } else {
                                //the icon is not selected
                                if tags.count == 3 {
                                    println("You can only have 3")
                                } else {
                                    self.tags.append(iconId5[indexPath.row])
                                    cell.iconImage.image = iconImage5[indexPath.row]
                                }
                                
                            }
                        } else {
                            if indexPath.section == 5 {
                                if cell.iconImage.image == iconImage6[indexPath.row] {
                                    //the icon is already clicked
                                    cell.iconImage.image = inActiveImage6[indexPath.row]
                                    //find the same tag id then removes it
                                    for id in tags {
                                        var count = 0
                                        if id == iconId6[indexPath.row] {
                                            self.tags.removeAtIndex(count)
                                        }
                                        count++
                                    }
                                    
                                    
                                } else {
                                    //the icon is not selected
                                    if tags.count == 3 {
                                        println("You can only have 3")
                                    } else {
                                        self.tags.append(iconId6[indexPath.row])
                                        cell.iconImage.image = iconImage6[indexPath.row]
                                    }
                                    
                                }
                            } else {
                                if indexPath.section == 6 {
                                    if cell.iconImage.image == iconImage7[indexPath.row] {
                                        //the icon is already clicked
                                        cell.iconImage.image = inActiveImage7[indexPath.row]
                                        //find the same tag id then removes it
                                        for id in tags {
                                            var count = 0
                                            if id == iconId7[indexPath.row] {
                                                self.tags.removeAtIndex(count)
                                            }
                                            count++
                                        }
                                    } else {
                                        //the icon is not selected
                                        if tags.count == 3 {
                                            println("You can only have 3")
                                        } else {
                                            self.tags.append(iconId7[indexPath.row])
                                            cell.iconImage.image = iconImage7[indexPath.row]
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