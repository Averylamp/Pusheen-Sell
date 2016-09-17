//
//  CaptureViewController.swift
//  HackMIT2016
//
//  Created by Nathan Gitter on 9/17/16.
//  Copyright © 2016 Nathan Gitter. All rights reserved.
//

import UIKit
import AVFoundation

class CaptureViewController: UIViewController, AVCaptureFileOutputRecordingDelegate {
    
    @IBOutlet weak var cameraPreviewView: UIView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var showTabBarButton: UIButton!
    @IBOutlet weak var itemDetailView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Capture VC")
        initializeVideoSession()
    
        
    }
    override func viewDidAppear(_ animated: Bool) {
        setTabBarVisible(visible: false)
    }
    override func viewDidDisappear(_ animated: Bool) {
        setTabBarVisible(visible: true)
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
        self.cameraPreviewView.layer.insertSublayer(loopPreviewLayer, below: self.showTabBarButton.layer)
        
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
    
    func setTabBarVisible(visible:Bool){
        print("Hiding tab bar \(self.tabBarController?.tabBar.frame.origin.y) < \(self.view.frame.maxY)")
        if ((self.tabBarController?.tabBar.frame.origin.y)! < self.view.frame.maxY) == visible {
            print("cancled")
            return
        }
        let height = self.tabBarController!.tabBar.frame.height
        let offset = visible ? -height : height
        print("Offset \(offset)")
//        self.tabBarController!.tabBar.frame.offsetBy(dx: 0, dy: offset)
        UIView.animate(withDuration: 0.5) {
            
            self.tabBarController!.tabBar.frame = CGRect(origin: CGPoint(x:0, y: self.tabBarController!.tabBar.frame.origin.y + offset), size: self.tabBarController!.tabBar.frame.size)
        }
        
    }
    @IBAction func cancelVideoClicked(_ sender: AnyObject) {
        
        self.setTabBarVisible(visible: true)
    }

}


extension String {
    
    func stringByAppendingPathComponent(path: String) -> String {
        
        let nsSt = self as NSString
        
        return nsSt.appendingPathComponent(path)
    }
}
