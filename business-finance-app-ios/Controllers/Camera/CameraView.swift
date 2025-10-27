//
//  CameraView.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 08/06/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import UIKit
import AVFoundation

var isSimulator: Bool {
    #if targetEnvironment(simulator)
        return true
    #else
        return false
    #endif
}

enum FlashMode {
    case on
    case off
    case auto
    
    var systemValue: AVCaptureDevice.FlashMode {
        switch self {
        case .on: return .on
        case .off: return .off
        case .auto: return .auto
        }
    }
}

//do {
//    try device.lockForConfiguration()
//    if device.flashMode == .on {
//        device.flashMode = .off
//    } else if device.flashMode == .off {
//        device.flashMode = .on
//    } else {
//        device.flashMode = .on
//    }
//    device.unlockForConfiguration()

public typealias CameraShotCompletion = (UIImage?) -> Void

public class CameraView: UIView {
    
    var session: AVCaptureSession!
    var input: AVCaptureDeviceInput!
    var device: AVCaptureDevice!
    var imageOutput: AVCapturePhotoOutput!
    var preview: AVCaptureVideoPreviewLayer!
    
    let cameraQueue = DispatchQueue(label: "com.zero.ALCameraViewController.Queue", attributes: .concurrent)
    
    private var currentFlashMode: FlashMode = .off
    public var currentPosition: AVCaptureDevice.Position = .back
    
    public func startSession() {
        cameraQueue.sync {
            self.createSession()
            self.session?.startRunning()
        }
    }
    
    public func stopSession() {
        cameraQueue.sync {
            self.session?.stopRunning()
            self.preview?.removeFromSuperlayer()
            
            self.session = nil
            self.input = nil
            self.imageOutput = nil
            self.preview = nil
            self.device = nil
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        preview?.frame = bounds
    }
    
    public func configureFocus() {
        
        if let gestureRecognizers = gestureRecognizers {
            gestureRecognizers.forEach({ removeGestureRecognizer($0) })
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(focus(gesture:)))
        addGestureRecognizer(tapGesture)
        isUserInteractionEnabled = true
    }
    
    @objc internal func focus(gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: self)
        guard focusCamera(toPoint: point) else { return }
    }
    
    private func createSession() {
        guard !isSimulator else { return }
        
        session = AVCaptureSession()
        session.sessionPreset = AVCaptureSession.Preset.photo
        DispatchQueue.main.async() {
            self.createPreview()
        }
    }
    
    private func createPreview() {
        device = cameraWithPosition(position: currentPosition)
        currentFlashMode = .off
        
        
        do {
            input = try AVCaptureDeviceInput(device: device)
        } catch let error as NSError {
            input = nil
            print("Error: \(error.localizedDescription)")
            return
        }
        
        if session.canAddInput(input) {
            session.addInput(input)
        }
        
        imageOutput = AVCapturePhotoOutput()
        //        imageOutput.outputSettings = outputSettings
        
        session.addOutput(imageOutput)
        
        preview = AVCaptureVideoPreviewLayer(session: session)
        preview.videoGravity = .resizeAspectFill
        preview.frame = bounds
        
        layer.addSublayer(preview)
    }
    
    private func cameraWithPosition(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let devices = AVCaptureDevice.devices(for: AVMediaType.video)
        return devices.filter { $0.position == position }.first
    }
    
    public func capturePhoto(completion: @escaping CameraShotCompletion) {
        isUserInteractionEnabled = false
        cameraQueue.sync {
//            let orientation = AVCaptureVideoOrientation(rawValue: UIDevice.current.orientation.rawValue)!
            let outputSettings = [
                AVVideoCodecKey: AVVideoCodecJPEG
            ]
            let settings = AVCapturePhotoSettings(format: outputSettings)
            settings.flashMode = currentFlashMode.systemValue
            imageOutput.capturePhoto(with: settings, delegate: self)
//
//            takePhoto(self.imageOutput, videoOrientation: orientation, cropSize: self.frame.size) { image in
//                DispatchQueue.main.async() {
//                    self.isUserInteractionEnabled = true
//                    completion(image)
//                }
//            }
        }
    }
    
    public func focusCamera(toPoint: CGPoint) -> Bool {
        
        guard let device = device, device.isFocusModeSupported(.continuousAutoFocus) else {
            return false
        }
        
        do { try device.lockForConfiguration() } catch {
            return false
        }
        
        // focus points are in the range of 0...1, not screen pixels
        let focusPoint = CGPoint(x: toPoint.x / frame.width, y: toPoint.y / frame.height)
        
        device.focusMode = AVCaptureDevice.FocusMode.continuousAutoFocus
        device.exposurePointOfInterest = focusPoint
        device.exposureMode = AVCaptureDevice.ExposureMode.continuousAutoExposure
        device.unlockForConfiguration()
        
        return true
    }
    
    public func cycleFlash() {
        guard let device = device, device.hasFlash else {
            return
        }
        
        if self.currentFlashMode == .on {
            self.currentFlashMode = .off
        } else if self.currentFlashMode == .off {
            self.currentFlashMode = .auto
        } else {
            self.currentFlashMode = .on
        }
    }
    
    public func swapCameraInput() {
        
        guard let session = session, let input = input else {
            return
        }
        
        session.beginConfiguration()
        session.removeInput(input)
        
        if input.device.position == AVCaptureDevice.Position.back {
            currentPosition = AVCaptureDevice.Position.front
            device = cameraWithPosition(position: currentPosition)
        } else {
            currentPosition = AVCaptureDevice.Position.back
            device = cameraWithPosition(position: currentPosition)
        }
        
        guard let i = try? AVCaptureDeviceInput(device: device) else {
            return
        }
        
        self.input = i
        
        session.addInput(i)
        session.commitConfiguration()
    }
    
    public func rotatePreview() {
        
        guard preview != nil else {
            return
        }
        switch UIApplication.shared.statusBarOrientation {
        case .portrait:
            preview?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
            break
        case .portraitUpsideDown:
            preview?.connection?.videoOrientation = AVCaptureVideoOrientation.portraitUpsideDown
            break
        case .landscapeRight:
            preview?.connection?.videoOrientation = AVCaptureVideoOrientation.landscapeRight
            break
        case .landscapeLeft:
            preview?.connection?.videoOrientation = AVCaptureVideoOrientation.landscapeLeft
            break
        default: break
        }
    }
}

extension CameraView: AVCapturePhotoCaptureDelegate {
    public func photoOutput(_ output: AVCapturePhotoOutput,
                            didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?,
                            previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?,
                            resolvedSettings: AVCaptureResolvedPhotoSettings,
                            bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
//        if let error = error {
//            print(error.localizedDescription)
//        }
//
//        if let sampleBuffer = photoSampleBuffer,
//            let previewBuffer = previewPhotoSampleBuffer,
//            let dataImage = AVCapturePhotoOutput.jpegPhotoDataRepresentation(
//                forJPEGSampleBuffer: sampleBuffer,
//                previewPhotoSampleBuffer: previewBuffer
//            ),
//            let image = UIImage(data: dataImage) {
        
//            print("GOT IMAGE")
            
//            print(UIImage(data: dataImage).size) // Your Image
//        }
//
        
    }
}
