//
//  SettingsTableViewController.swift
//  Breakout
//
//  Created by Jeroen Schonenberg on 16/05/15.
//  Copyright (c) 2015 private. All rights reserved.
//

import UIKit
import AVFoundation

class SettingsTableViewController: UITableViewController, AVCaptureMetadataOutputObjectsDelegate{

    @IBOutlet weak var levelSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var paddleWidthSegmentedControl: UISegmentedControl!
    @IBOutlet weak var controlByTiltingSwitch: UISwitch!
    
    @IBOutlet weak var ballCountLabel: UILabel!
    @IBOutlet weak var ballCountStepper: UIStepper!
    @IBOutlet weak var ballSpeedModifierSlider: UISlider!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.sharedApplication().statusBarStyle = .Default
        self.tabBarController?.tabBar.tintColor = UIColor.blackColor()
        self.tabBarController?.tabBar.barTintColor = UIColor.whiteColor()
    }
    
    @IBAction func levelChanged(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 3 {
            captureQRCode()
        } else {
            Settings.level = Levels.levels[sender.selectedSegmentIndex]
            Settings.ResetRequired = true
        }
    }
    
    @IBAction func ballCountChanged(sender: UIStepper)
    {
        Settings.ballCount = Int(ballCountStepper.value)
        ballCountLabel.text = "\(Int(ballCountStepper.value))"
        Settings.UpdateRequired = true
    }
    
    @IBAction func ballSpeedModifierChanged(sender: UISlider) {
    }
    
    let session = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    func captureQRCode() {
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        let input = AVCaptureDeviceInput.deviceInputWithDevice(device, error: nil) as! AVCaptureDeviceInput
        session.addInput(input)
        
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        session.addOutput(output)
        output.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: session)
        let bounds = self.view.layer.bounds
        self.previewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.previewLayer!.bounds = bounds
        self.previewLayer!.position = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds))
        
        self.view.layer.addSublayer(previewLayer)
        session.startRunning()
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        for item in metadataObjects {
            if let metadataObject = item as? AVMetadataMachineReadableCodeObject {
                if metadataObject.type == AVMetadataObjectTypeQRCode {
                    var QRstr = metadataObject.stringValue
                    var rows = QRstr.componentsSeparatedByCharactersInSet(.whitespaceAndNewlineCharacterSet())
                    
                    var level: Array<[Int]> = Array<[Int]>()
                    for row in rows {
                        level.append( map(row) { String($0).toInt() ?? 0 } )
                    }
                    
                    Settings.level = level
                    Settings.ResetRequired = true
                    
                    
                    
                    // stop scanning
                    session.stopRunning()
                    previewLayer?.removeFromSuperlayer()
                }
            }
        }
    }
}
