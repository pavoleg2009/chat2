//
//  AuthService.swift
//  chat2
//
//  Created by Oleg Pavlichenkov on 12/12/2016.
//  Copyright © 2016 Oleg Pavlichenkov. All rights reserved.
//

import Foundation
import Firebase

typealias Completion = (_ errMsg: String?, _ data: AnyObject?) -> Void

class AuthService {
    
    private static let _instance = AuthService()
    
    static var instance: AuthService {
        return _instance
    }
    
    
    
    func login(email: String, password: String, onComplete: Completion?) {
        
        
        //FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                if let errorCode = FIRAuthErrorCode(rawValue: (error as! NSError).code) {
                    if errorCode == FIRAuthErrorCode.errorCodeUserNotFound {
                        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                            if error != nil {
                                self.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
                            } else {
                                if user?.uid != nil {
                                    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                                        if error != nil {
                                            self.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
                                            
                                        } else {
                                            // successfully logged in
                                            onComplete?(nil, user)
                                        }
                                    })
                                }
                            }
                        })
                    } else {
                        // handle all other error
                        self.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
                    }
                }
            } else {
                // successfully loged In
                onComplete?(nil, user)
            }
        })
    }
    
    func handleFirebaseError(error: NSError, onComplete: Completion?) {
        print("===[AuthService]\(error.debugDescription)")
        
        if let errorCode = FIRAuthErrorCode(rawValue: error.code) {
            switch errorCode {
            case .errorCodeInvalidEmail:
                onComplete?("Invalid email address", nil)
            case .errorCodeWrongPassword:
                onComplete?("Invalid password", nil)
            case .errorCodeEmailAlreadyInUse:
                onComplete?("Could not create account. Email already in use", nil)
            case .errorCodeAccountExistsWithDifferentCredential:
                onComplete?("Could not create account. Account Exists With Different Credential", nil)
            default:
                onComplete?("Error while authentivating firebase. Try again", nil)
                
            }
        }
    }
    
    func logout(){
        try! FIRAuth.auth()?.signOut()
    }
}

