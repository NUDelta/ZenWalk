//
//  ContinuousMoment.swift
//  ExperienceTestSingle
//
//  Created by Hyung-Soon on 5/9/16.
//  Copyright © 2016 Hyung-Soon. All rights reserved.
//
import Foundation

//conditional branching of moments based upon a true/false function
//condition function is triggered every second
//reason: so that location data, etc. has a chance to update
class ContinuousMoment: Moment {
    /// The types of data that should be collected for the duration (i.e. Location, Motion).
    var sensors: [Sensor]
    /// The thing you hope to find by recording data.
    var dataLabel: String
    var conditionFunc: ()->Bool
    var _timer: NSTimer?
    
    init(fileNames: [String]=[], title:String?=nil, conditionFunc:()->Bool, dataLabel:String, sensors:[Sensor]){
        self.sensors = sensors
        self.dataLabel = dataLabel
        self.conditionFunc = conditionFunc
        super.init(title: title ?? "continuous-moment")
    }
    
    override func play(){
        //start a timer that checks the conditinoFunc every second
        _timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(ContinuousMoment.checkCondition), userInfo: nil, repeats: true)
        super.play()
    }
    
    func checkCondition() {
        //conditionFunc: true, just keep running
        if conditionFunc() {
            return
        }
        //conditionFunc: false, stop
        //stop the timer from running
        _timer?.invalidate()
        super.finished()
    }
    
    override func pause(){
        _timer?.invalidate()
        super.pause()
    }
    
    override func finished(){
        //nothing
        super.finished()
    }
}