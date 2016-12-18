//
//  CameraVCDelegate.swift
//  chat2
//
//  Created by Oleg Pavlichenkov on 13/12/2016.
//  Copyright © 2016 Oleg Pavlichenkov. All rights reserved.
//

import UIKit

protocol CameraVCDelegate {
    func videoRecordingComplete(videoURL: URL?)
    func videoRecordingFailed()
    func photoCaptureComplete(imageData: Data?)
    func snapshotFailed()
}
