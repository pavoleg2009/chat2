//
//  UserVC.swift
//  chat2
//
//  Created by Oleg Pavlichenkov on 13/12/2016.
//  Copyright © 2016 Oleg Pavlichenkov. All rights reserved.
//

import UIKit
import Firebase

class UserVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var users = [User]()
    private var selectedUsers = [String: User]()
    
    private var _imageData: Data?
    private var _videoURL: URL?
    
    var imageData: Data? {
        get {
            return _imageData
        } set {
            _imageData = newValue
        }
    }
    
    var videoURL: URL? {
        get {
            return _videoURL
        } set {
            _videoURL = newValue
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsMultipleSelection = true
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        DataService.instance.userRef.observeSingleEvent(of: .value, with: { (snap) in
            if let users = snap.value as? [String: AnyObject] {
                for (key, value) in users {
                    if let dict = value as? [String: AnyObject] {
                        if let profile = dict["profile"] as? [String: AnyObject] {
                            if let firstName = profile["firstName"] as? String {
                                let uid = key
                                let user = User(uid: uid, firstName: firstName)
                                self.users.append(user)
                            }
                        }
                    }
                }
            }
            print(self.users)
            self.tableView.reloadData()
        })
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as! UserCell
        let user = users[indexPath.row]
        cell.updateUI(user: user)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationItem.rightBarButtonItem?.isEnabled = true
        let cell = tableView.cellForRow(at: indexPath) as! UserCell
        cell.setCheckmark(selected: true)
        let user = users[indexPath.row]
        selectedUsers[user.uid] = user
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! UserCell
        cell.setCheckmark(selected: false)
        let user = users[indexPath.row]
        selectedUsers[user.uid] = nil
        
        if selectedUsers.count == 0 {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    
    
    
    @IBAction func sendPRButtonTapped(_ sender: Any) {
        
        if let url = _videoURL {
            let videoName = "\(UUID().uuidString)" //"\(UUID())\(url)"
            let ref = DataService.instance.videosStorageRef.child(videoName)
            
            ref.putFile(url, metadata: nil, completion: { (meta: FIRStorageMetadata?, error: Error?) in
                if error != nil {
                    print("===[UserVC].sendPRButtonTapped() Error uploading video : \(error.debugDescription)")
                } else {
                    let downloadURL = meta!.downloadURL()
                    // save this somethere
                    self.dismiss(animated: true, completion: nil)
                }
            })
        } else if let image = _imageData {
            let ref = DataService.instance.imagesStorageRef.child("\(UUID().uuidString)")
            
            ref.put(image, metadata: nil, completion: { (meta, error) in
                if error != nil {
                    print("===[UserVC].sendPRButtonTapped() Error uploading image : \(error.debugDescription)")
                } else {
                    let downloadURL = meta!.downloadURL()
                    // save this somethere
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
    }
    
}
