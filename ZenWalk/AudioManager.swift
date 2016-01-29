//
//  AudioManager.swift
//  ZenWalk
//
//  Created by Pamina Lin on 1/15/16.
//  Copyright © 2016 Scott Cambo. All rights reserved.
//

import Foundation

class AudioManager {
    
    var queue: AVQueuePlayer

    init() {
        self.queue = AVQueuePlayer()
    }
    
    func createPlayerItemFromFile(filename: String) -> AVPlayerItem {
        let fileURL:NSURL = NSBundle.mainBundle().URLForResource(filename, withExtension: "mp3")!
        //let error: NSError?
        return AVPlayerItem(URL: fileURL)
    }
    
    func setUpQueuePlayer(fileNames: [String]) {
        self.queue.removeAllItems()
        
        for f in fileNames {
            let item = createPlayerItemFromFile(f)
            queue.insertItem(item, afterItem: nil)
        }
    }
}