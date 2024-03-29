//
//  WaitForWord.swift
//  ZombieRunX
//
//  Created by Henry Spindell on 10/11/15.
//  Copyright © 2015 Scott Cambo, Henry Spindell, & Delta Lab NU. All rights reserved.
//

import Foundation

class WaitForWord: Interim{
    /* simple actuation moment that does not call finished()
    until "yes" has been said in the MomentBlockSimple MomentBlock
    
    the "length" parameter now acts as a timing out function
    in case the user does not respond
    */
    
    
    // This isn't really working properly, and probably requires some real testing to do so.
    
    var openEarsController : OpenEarsController
    
    init(wordsToRecognize: [String], lengthInSeconds: Float, interruptable:Bool=false, title:String?=nil){
        openEarsController = OpenEarsController(wordsToRecognize: wordsToRecognize)
        super.init(title: title ?? "Wait For \(wordsToRecognize)", isInterruptable:interruptable, lengthInSeconds: lengthInSeconds)
        openEarsController.events.listenTo("heardWord", action: self.heard)
    }
    
    override func play(){
        openEarsController.startListening()
        super.play()
    }
    
    override func pause(){
        openEarsController.stopListening()
        super.pause()
    }
    
    override func finished(){
        openEarsController.stopListening()
        super.finished()
    }
    
    func heard(information:Any?){
        // ?? - H
        self.eventManager.trigger("dataLabel", information: "heardWord")
        finished()
    }
}