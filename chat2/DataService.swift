//
//  DataService.swift
//  chat2
//
//  Created by Oleg Pavlichenkov on 13/12/2016.
//  Copyright © 2016 Oleg Pavlichenkov. All rights reserved.
//

import Foundation
import Firebase

class DataService {
    private static let _instance = DataService()
    
    static var instance: DataService {
        return _instance
    }
    
    var mainRef: FIRDatabaseReference {
        return FIRDatabase.database().reference()
    }
    
    var userRef: FIRDatabaseReference {
        return mainRef.child("users")
    }
    
    var mainStorageRef: FIRStorageReference {
        return FIRStorage.storage().reference()
//        return FIRStorage.storage().reference(forURL: "gs://chat2-dfa49.appspot.com")
    }
    
    var imagesStorageRef: FIRStorageReference {
        return mainStorageRef.child("images")
    }
    
    var videosStorageRef: FIRStorageReference {
        return mainStorageRef.child("videos")
    }
    
    func createEmptyDBUser(uid: String) {
        let profile = ["firstName": "", "lastName": ""]
        userRef.child(uid).child("profile").setValue(profile)
    }
    
    func sendMediaPullRequest(senderUID: String, sendingTo:[String: User], mediaUrl: URL, textSnippet: String?) {
// FIXME: Check pr.sendingTo
        var uids = [String]()
        for uid in sendingTo.keys {
            uids.append(uid)
        }
        let pr: [String: Any] = ["mediaURL": mediaUrl.absoluteString, "userID": senderUID, "openCount": 0, "sendingTo": uids]
        print(pr)
        mainRef.child("pullRequests").childByAutoId().setValue(pr)
        
    }
}
