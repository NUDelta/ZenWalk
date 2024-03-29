//
//  OpportunityManager.swift
//  Zombies Interactive
//
//  Created by Henry Spindell on 11/7/15.
//  Copyright © 2015 Scott Cambo, Henry Spindell, & Delta Lab NU. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit


@objc protocol OpportunityManagerDelegate {

    optional func didUpdateMomentBlockSimpleQueue()
    func attemptInsertMomentBlockSimple()
}

extension CLLocation {
    // In meteres
    class func distance(from: CLLocationCoordinate2D, to:CLLocationCoordinate2D) -> CLLocationDistance {
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return from.distanceFromLocation(to) //gets distance in meters
    }
}

func RadiansToDegrees (value:Double) -> Double {
    return value * 180.0 / M_PI
}

func getAngularDifference(loc1: CLLocationCoordinate2D, loc2: CLLocationCoordinate2D) -> Double
{
    let dLon = loc1.longitude - loc2.longitude
    let y = sin(dLon) * cos(loc2.latitude)
    let x = cos(loc1.latitude) * sin(loc2.latitude) - sin(loc1.latitude) * cos(loc2.latitude) * cos(loc2.longitude)
    let angle = RadiansToDegrees(atan2(y, x));
    return angle;
}


class OpportunityManager: NSObject {
    
    var MomentBlockSimplePool: [MomentBlockSimple]
    
    init(MomentBlockSimplePool: [MomentBlockSimple]) {
        self.MomentBlockSimplePool = MomentBlockSimplePool
    }
    
    func getImmediateInsertMomentBlockSimple(context: Context) -> MomentBlockSimple? {
        print(  "(OpportunityManager::getBestFitMomentBlockSimple)")
        var highestScore: Double = 0
        var highestScoreIdx = -1
        
        //go through all the MomentBlockSimples in the MomentBlockSimple pool and get the
        //MomentBlockSimple with the highest score
        for (idx, MomentBlockSimple) in MomentBlockSimplePool.enumerate() {
            let fitScore = MomentBlockSimpleContextFitScore(context, momentBlockSimple: MomentBlockSimple)
            if fitScore > highestScore {
                highestScore = fitScore
                highestScoreIdx = idx
            }
        }
        if highestScoreIdx == -1 {
            return nil
        }
        return MomentBlockSimplePool[highestScoreIdx]
    }
    
    func getBestFitMomentBlockSimple(context: Context) -> MomentBlockSimple? {
        print(  "(OpportunityManager::getBestFitMomentBlockSimple)")
        var highestScore: Double = 0
        var highestScoreIdx = -1
        
        //go through all the MomentBlockSimples in the MomentBlockSimple pool and get the
        //MomentBlockSimple with the highest score
        for (idx, MomentBlockSimple) in MomentBlockSimplePool.enumerate() {
            let fitScore = MomentBlockSimpleContextFitScore(context, momentBlockSimple: MomentBlockSimple)
            if fitScore > highestScore {
                highestScore = fitScore
                highestScoreIdx = idx
            }
        }
        
        //note: default score is 0, hence if score is not over 0, then highestScore remains -1
        //thus meaning no suitable MomentBlockSimples found.
        if highestScoreIdx == -1 {
            return nil
        }
        
        //MomentBlockSimple with the highest score
        //NOTE: CURRENTLY REMOVING THIS MomentBlockSimple AFTER INSERTION
        //(PERHAPS NOT WHAT IS WANTED)
        return MomentBlockSimplePool.removeAtIndex(highestScoreIdx)
    }
    
    
    func MomentBlockSimpleContextFitScore(context: Context, momentBlockSimple: MomentBlockSimple) -> Double {
        if momentBlockSimple.requirement == nil {
            return 0
        }
        
        // could change this to "score" the MomentBlockSimple by how close it is to satisfying
        // somewhere else a function could map all MomentBlockSimple scores from this fn into a priority queue
        let req = momentBlockSimple.requirement!
        
        for condition in req.conditions {
            switch condition {
            case .MaxSpeed:
                if let maxSpeed = req.speed
                where context.speed > maxSpeed {
                    return 0
                }
                break
            case .MinSpeed:
                if let minSpeed = req.speed
                where context.speed < minSpeed {
                    return 0
                }
                break
            case .TimeElapsed:
                if let necessaryTimeElapsed = req.seconds
                where context.timeElapsed < necessaryTimeElapsed {
                    return 0
                }
                break
                
            case .TimeRemaining:
                if let timeNeeded = req.seconds
                where context.timeRemaining < timeNeeded {
                    return 0
                }
                break
                
            case .InRegion:
                //print("\ncalculating inRegion... (context.location:\(context.location))")
                print("\ncalculating inRegion...")
                if let loc_cur = context.location,
                region_bound = req.region
                {
                    let p1 = MKMapPointForCoordinate((region_bound.center))
                    let p2 = MKMapPointForCoordinate(loc_cur)
                    let dis = MKMetersBetweenMapPoints(p1, p2)
                    let angDif = getAngularDifference((region_bound.center), loc2: loc_cur)
                    print ("distance:\(dis)m, angDif:\(angDif)deg")
                    
                    //higher points needed for shorter distance error
                    if dis == 0 {
                        return Double.infinity
                    }
                    return Double(1/dis)
                }
                return 0
            default:
                break
            }
        }
        
        //Note: as of now, the 'score' returned is just the length of the array
        //(this needs to be changed to get higher score for ex. closer distances)
        return Double(req.conditions.count)
    }
    
}
