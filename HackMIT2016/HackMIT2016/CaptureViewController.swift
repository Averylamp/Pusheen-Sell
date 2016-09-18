//
//  CaptureViewController.swift
//  HackMIT2016
//
//  Created by Nathan Gitter on 9/17/16.
//  Copyright © 2016 Nathan Gitter. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftSpinner

class CaptureViewController: UIViewController, AVCaptureFileOutputRecordingDelegate {
    
    @IBOutlet weak var cameraPreviewView: UIView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var itemDetailView: UIView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var descTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Capture VC")
        self.itemDetailView.alpha = 0
        self.overlayView.alpha = 0
        self.overlayView.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        initializeVideoSession()
        
    }
    
    
    @IBAction func retakeVideoClicked(_ sender: AnyObject) {
        UIView.animate(withDuration: 1.0) {
            self.overlayView.alpha = 0
            self.itemDetailView.alpha = 0
        }
        self.loopPreviewPlayer.pause()
        self.loopPreviewLayer.removeFromSuperlayer()
        
        
    }
    //MARK: - Touches
    
    var cameraTouch: UITouch? = nil
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        if touch.view == cameraPreviewView{
            cameraTouch = touch
            startCameraRecording()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        if cameraTouch == touch{
            endCameraRecording()
        }
    }
    
    //MARK: - Camera Functions
    var videoToLoop = false
    var videoPreviewLayer : AVCaptureVideoPreviewLayer? = nil
    var loopPreviewLayer = AVPlayerLayer()
    var loopPreviewPlayer = AVPlayer()
    var videoOutput = AVCaptureMovieFileOutput()
    var captureSession = AVCaptureSession()
    func initializeVideoSession(){
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        do{
            let input = try AVCaptureDeviceInput(device: AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo))
            captureSession.addInput(input)
        }catch{
            print("UNABLE TO add VIDEO INPUT")
        }
        DispatchQueue.main.async {
            print("Starting camera session")
            if self.videoPreviewLayer != nil {
                self.videoPreviewLayer?.removeFromSuperlayer()
            }
            self.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
            self.videoPreviewLayer?.frame = self.cameraPreviewView.bounds
            self.cameraPreviewView.layer.insertSublayer(self.videoPreviewLayer!, at: 0)
            self.captureSession.addOutput(self.videoOutput)
            self.captureSession.startRunning()
            
        }
        
    }
    
    
    var recordingState = false
    func startCameraRecording(){
            recordingState = true
        videoOutput.startRecording(toOutputFileURL: tempUrlForVideoRecording() , recordingDelegate: self)
        
    }
    
    func tempUrlForVideoRecording()->URL{
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docDirectoryPath = paths.first!
        let path = "tempVideo.mp4"
        let pathCameraInput = docDirectoryPath.stringByAppendingPathComponent(path: path)
        let url = URL(fileURLWithPath: pathCameraInput)
        return url
    }
    
    func endCameraRecording(){
        recordingState = false
        videoOutput.stopRecording()
    }
    
    func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
        if error != nil{
            print("Error recording \(error)")
        }
        print("Finished recording")
        loopPreviewLayer.removeFromSuperlayer()
        loopPreviewPlayer = AVPlayer(url: tempUrlForVideoRecording())
        loopPreviewLayer = AVPlayerLayer(player: loopPreviewPlayer)
        loopPreviewLayer.frame = self.view.bounds
        self.cameraPreviewView.layer.addSublayer(loopPreviewLayer)
        
        loopPreviewPlayer.play()
        loopPreviewPlayer.actionAtItemEnd = .none
        NotificationCenter.default.addObserver(self, selector: #selector(CaptureViewController.loopPlayerDidEnd), name: .AVPlayerItemDidPlayToEndTime, object: self.loopPreviewPlayer.currentItem!)
        UIView.animate(withDuration: 1.0) { 
            self.overlayView.alpha = 0.5
            self.itemDetailView.alpha = 1.0
        }
        
        
    }
    func loopPlayerDidEnd(){
        self.loopPreviewPlayer.seek(to: kCMTimeZero)
        self.loopPreviewPlayer.play()
    }
    
    @IBAction func cancelVideoClicked(_ sender: AnyObject) {
        //
    }
    
    @IBAction func postPressed(_ sender: UIButton) {
        //
        SwiftSpinner.show("Uploading \(nameTextField.text!)")
        
        Fireb.addItem(withTitle: nameTextField.text!, desciption: descTextView.text, Price: priceTextField.text!){
            (key) in
            
            SwiftSpinner.hide()
            self.dismiss(animated: true, completion: { 
                print("Dissmissed VC")
            })
        }
        
        
    }

}


extension String {
    
    func stringByAppendingPathComponent(path: String) -> String {
        
        let nsSt = self as NSString
        
        return nsSt.appendingPathComponent(path)
    }
}
