//
//  Event.swift
//  UinProto2
//
//  Created by Ismael Alonso on 2/6/15.
//  Copyright (c) 2015 Kareem Dasilva. All rights reserved.
//

import Foundation

public class Event{
    //Event attributes
    private var onCampus: Bool
    private var paid: Bool
    private var food: Bool
    private var title: String
    private var author: String
    private var location: String
    private var startDate: String
    private var endDate: String
    private var startTime: String
    private var endTime: String
    
    
    //Initialiser
    init(object: PFObject){
        onCampus = object["location"] as Bool
        paid = object["paid"] as Bool
        food = object["food"] as Bool
        title = object["sum"] as String
        author = object["user"] as String
        location = object["title"] as String
        startDate = object["startdate"] as String
        endDate = object["endDate"] as String
        startTime = object["starttime"] as String
        endTime = object["endTime"] as String
    }
    
    //Setters
    func setOnCampus(onCampus: Bool){
        self.onCampus = onCampus
    }
    
    func setPaid(paid: Bool){
        self.paid = paid
    }
    
    func setFood(food: Bool){
        self.food = food
    }
    
    func setTitle(title: String){
        self.title = title
    }
    
    func setLocation(location: String){
        self.location = location
    }
    
    func setStartDate(startDate: String){
        self.startDate = startDate
    }
    
    func setEndDate(endDate: String){
        self.endDate = endDate
    }
    
    func setStartTime(startTime: String){
        self.startTime = startTime
    }
    
    func setEndTime(endTime: String){
        self.endTime = endTime
    }
    
    //Getters
    public func getOnCampus() -> Bool{
        return onCampus
    }
    
    public func getPaid() -> Bool{
        return paid
    }
    
    public func getFood() -> Bool{
        return food
    }
    
    public func getTitle() -> String{
        return title
    }
    
    public func getAuthor() -> String{
        return author
    }
    
    public func getLocation() -> String{
        return location
    }
    
    public func getStartDate() -> String{
        return startDate
    }
    
    public func getEndDate() -> String{
        return endDate
    }
    
    public func getStartTime() -> String{
        return startTime
    }
    
    public func getEndTime() -> String{
        return endTime
    }
}