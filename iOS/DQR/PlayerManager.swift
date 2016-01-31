//
//  PlayerManager.swift
//  DQR
//
//  Created by Wm. Blake Sullivan on 1/31/16.
//  Copyright © 2016 Team DQR. All rights reserved.
//

import UIKit

class PlayerManager {
    
    var playerList = [
        PlayerItem(name: "Stuart"),
        PlayerItem(name: "Henry"),
        PlayerItem(name: "Hudson"),
        PlayerItem(name: "Sneha"),
        PlayerItem(name: "Jackie"),
        PlayerItem(name: "Nick"),
        PlayerItem(name: "Blake")
    ]
    var thisPlayer:PlayerItem? = nil
    
    func archivePath() -> String? {
        let directoryList = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) //find the one path you can store to/ pull from
        if let documentsPath = directoryList.first {
            return documentsPath + "/ScavengerHuntItems"
        }
        assertionFailure("Could not determine where to store file.") //safety net so app dosen't crash
        return nil
    }
    
    func thisPlayerIsNil() -> Bool {
        return thisPlayer == nil
    }
    
    func addToList(player: PlayerItem) {
        if !thisPlayerIsNil() {
            playerList += [player]
            save()
        }
    }
    
    //save all the current data
    func save() {
        if let theArchivePath = archivePath() {
            if NSKeyedArchiver.archiveRootObject(playerList, toFile: theArchivePath) { //encode and archive to the path
                print("Saved successfully")
            } else {
                assertionFailure("Could not save file") //safety net in case the path can't be found
            }
        }
    }
    
    //unarchive on startup of app
    init() {
        if let theArchivePath = archivePath() {
            if NSFileManager.defaultManager().fileExistsAtPath(theArchivePath) {
                playerList = NSKeyedUnarchiver.unarchiveObjectWithFile(theArchivePath) as! [PlayerItem]
            }
        }
    }
}
