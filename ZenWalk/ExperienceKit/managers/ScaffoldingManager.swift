//
//  ScaffoldingManager.swift
//  ExperienceTestSingle
//
//  Created by Hyung-Soon on 5/12/16.
//  Copyright © 2016 Hyung-Soon. All rights reserved.
//

import Foundation
import Parse

class ScaffoldingManager: NSObject {

    var curPulledObject: PFObject?
    var _experienceManager: ExperienceManager
    var insertableMomentBlocks: [MomentBlockSimple] = []
    var evaluatingObjects: [PFObject] = []
    
    init(experienceManager: ExperienceManager, insertableMomentBlocks: [MomentBlockSimple]=[] ) {
        self._experienceManager = experienceManager
        self.insertableMomentBlocks = insertableMomentBlocks
        super.init()
    }
    
    func getPossibleInsertion(withInformation: Any?) -> MomentBlockSimple? {
        //parse out user defined filters
        var label: String?
        if let infoDict = withInformation as? [String : String] {
            label = infoDict["label"]
        }
        //query possible scaffolding opportunities within x meters
        var curGeoPoint = PFGeoPoint(location: _experienceManager.dataManager!.currentLocation!)
        var query = PFQuery(className: "WorldObject")
        query = query.whereKey("location", nearGeoPoint: curGeoPoint, withinKilometers: 10)
        
        //make sure object aligns with user defined parameters
        if (label != nil) {
            query = query.whereKey("label", equalTo: label!)
        }
        
        let objects = query.findObjects()
        if objects == nil {
            return nil
        }
        if objects?.count <= 0 {
            return nil
        }
        evaluatingObjects = objects as! [PFObject]
        let object = objects![0] as! PFObject
        print("query result: \(query)")
        print("object result: \(object)")
        curPulledObject = object //save pulled object for potential reuse
        
        //get best MomentBlock for insertion (from pool)
        let bestMomentBlock = getBestMomentBlock(label!)
        if bestMomentBlock != nil {
            print("--possible insertion:\(bestMomentBlock!.title)--")
            return bestMomentBlock
        }
        return nil
    }
    
    //TODO) ALSO NEED TO RANK THE OBJECTS THAT WERE PULLED 
    //(IN CASE THERE ARE MULTIPLE THAT MATCH THE CONDITIONS)
    
    
    //rank the possible insertable MomentBlocks
    func getBestMomentBlock(label:String) -> MomentBlockSimple? {
        var highestIdx = -1
        var highestScore = -1
        var currentScore = -1
        for (idx, momentBlock) in insertableMomentBlocks.enumerate() {
            currentScore = -1
            //evaluate score of current
            if ( momentBlock.requirement?.objectLabel == label ) {

                //CONDITION: variation
                //currently just giving back the interaction with the highest variation precondition
                if momentBlock.requirement?.variationNumber == nil {
                    currentScore = 5
                }
                else {
                    for pulledObject in evaluatingObjects {
                        //var worldObj = pulledObject as! WorldObject
                        //calculate validRatio (valid / invalid)
                        var valTimes = pulledObject.objectForKey("validatedTimes") as? Double ?? 0
                        var invalTimes = pulledObject.objectForKey("invalidatedTimes") as? Double ?? 0
                        if valTimes == 0 {
                            valTimes = 1
                        }
                        if invalTimes == 0 {
                            invalTimes = 1
                        }
                        let validRatio = valTimes / invalTimes
                        //make sure the varation precondition exists
                        if let variation = pulledObject.objectForKey("variation") as? Int
                        where variation == momentBlock.requirement?.variationNumber && validRatio >= 1.5 {
                            currentScore = (momentBlock.requirement?.variationNumber as! Int + 1) * 10
                        }
                    }
                }
            }
            //update refernece to highest score
            if currentScore > highestScore {
                highestIdx = idx
                highestScore = currentScore
            }
        }
        if highestIdx == -1 {
            return nil
        }
        print("(getBestMomentBlock) highest-idx:\(highestIdx)")
        return insertableMomentBlocks[highestIdx]
    }
    
}