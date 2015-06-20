//
//  QRScannerViewController.swift
//  Breakout
//
//  Created by Jeroen Schonenberg on 18/06/15.
//  Copyright (c) 2015 private. All rights reserved.
//

import UIKit
import AVFoundation

protocol LevelScannerDelegate {
    func LevelScanComplete(level: Array<[Int]>)
    func LevelScanCancelled()
}

class LevelScannerViewController : UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var delegate: LevelScannerDelegate?
    
    let session = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        if let input = AVCaptureDeviceInput.deviceInputWithDevice(device, error: nil) as? AVCaptureDeviceInput {
            session.addInput(input)
        
            let output = AVCaptureMetadataOutput()
            output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            session.addOutput(output)
            output.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
            let bounds = self.view.layer.bounds
            self.previewLayer = AVCaptureVideoPreviewLayer(session: session)
            self.previewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
            self.previewLayer!.bounds = bounds
            self.previewLayer!.position = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds))
        
            self.view.layer.addSublayer(previewLayer)
            session.startRunning()
        } else {
            // no camera available (mainly for emulators)
            self.cancel(nil)
        }
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        for item in metadataObjects {
            if let metadataObject = item as? AVMetadataMachineReadableCodeObject {
                if metadataObject.type == AVMetadataObjectTypeQRCode {
                    // construct level from QR code
                    var QRstr = metadataObject.stringValue
                    var rows = QRstr.componentsSeparatedByCharactersInSet(.whitespaceAndNewlineCharacterSet())
                    
                    var level: Array<[Int]> = Array<[Int]>()
                    for row in rows {
                        level.append( map(row) { String($0).toInt() ?? 0 } )
                    }
                    
                    // stop scanning
                    session.stopRunning()
                    previewLayer?.removeFromSuperlayer()
                    delegate?.LevelScanComplete(level)
                    dismissViewControllerAnimated(true, completion: {})
                }
            }
        }
    }
    
    
    @IBAction func cancel(sender: UIBarButtonItem?) {
        delegate?.LevelScanCancelled()
        dismissViewControllerAnimated(true, completion: {})
    }

}
