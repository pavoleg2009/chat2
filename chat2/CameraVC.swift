//
//  ViewController.swift
//  chat2
//
//  Created by Oleg Pavlichenkov on 08/12/2016.
//  Copyright © 2016 Oleg Pavlichenkov. All rights reserved.
//

import UIKit
import Firebase

class CameraVC: CameraViewController, CameraVCDelegate {
//extension CameraViewController {
    
    @IBOutlet weak var preView: PreviewView!
    @IBOutlet weak var livePhotoModeButton: UIButton!
    
    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var capturingLivePhotoLabel: UILabel!
    
    @IBOutlet weak var cameraUnavailableLabel: UILabel!
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var captureModeControl: UISegmentedControl!
    
    override func viewDidLoad() {
        
        self._previewView = preView
        self._livePhotoModeButton = livePhotoModeButton
        self._resumeButton = resumeButton
        self._cameraUnavailableLabel = cameraUnavailableLabel
        self._capturingLivePhotoLabel = capturingLivePhotoLabel
        self._recordButton = recordButton
        self._photoButton = photoButton
        self._cameraButton = cameraButton
        self._captureModeControl = captureModeControl
        
        super.viewDidLoad()
        
        
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard FIRAuth.auth()?.currentUser != nil  else {
            //load login VC
            performSegue(withIdentifier: "LoginVC", sender: nil)
            return
        }
    }
    
    @IBAction func toggleCaptureModeTapped(_ sender: UISegmentedControl) {
        self.toggleCaptureMode(sender)
    }
    
    @IBAction func changeCameraTapped(_ sender: UIButton) {
        
        self.changeCamera(sender)
    }

    @IBAction func toggleMovieRecordingTapped(_ sender: UIButton) {
        self._toggleMovieRecording(sender)
    }
    @IBAction func resumeInterruptedSesionTapped(_ sender: UIButton) {
        self.resumeInterruptedSession(sender)
    }
    
    @IBAction func capturePhotoTapped(_ sender: UIButton) {
        self.capturePhoto(sender)
    }
    
    @IBAction func focusAndExposeTapTapped(_ sender: UITapGestureRecognizer) {
        self.focusAndExposeTap(sender)
    }
    @IBAction func toggleLivePhotoModeTapped(_ sender: UIButton) {
        self.toggleLivePhotoModeTapped(sender)
    }
    @IBAction func logoutButtonTapped(_ sender: Any) {
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "LoginVC", sender: nil)
    }
    
    func videoRecordingComplete(videoURL: URL?) {
        
        performSegue(withIdentifier: "UsersVC", sender: ["videoURL": videoURL])
        
    }
    
    func videoRecordingFailed() {
        
    }
    
    func snapshotTaken(imageData: Data?) {
        performSegue(withIdentifier: "UsersVC", sender: ["imageData": imageData])
    }
    
    func snapshotFailed() {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let usersVC = segue.destination as? UserVC {
            if let videoDict = sender as?[String: URL] {
                let url = videoDict["videoURL"]
                usersVC.videoURL = url
            } else if let imageDict = sender as? [String: Data] {
                let imageData = imageDict["imageData"]
                usersVC.imageData = imageData
                
            }
        }
    }
    
}

