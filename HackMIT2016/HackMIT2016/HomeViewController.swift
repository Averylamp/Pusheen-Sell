//
//  ViewController.swift
//  HackMIT2016
//
//  Created by Nathan Gitter on 9/17/16.
//  Copyright © 2016 Nathan Gitter. All rights reserved.
//

import UIKit
import CoreMotion

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var captureButton: CaptureButton!
    
    fileprivate let padding: CGFloat = 8
    var items : [Item] = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.captureButton.addTarget(self, action: #selector(HomeViewController.captureButtonAction), for: UIControlEvents.touchUpInside)
        Fireb.getAllitem { (items) in
            self.items = items
        }
        
    }
    var isMotionBasedPanEnabled = true
    let kMovementSmoothing = 0.3
    let kAnimationDuration = 0.3
    let kRotationMultiplier = 5.0
    var motionManager = CMMotionManager()
    func calculateRotationBasedOnDeviceMotionRotationRate(motion: CMDeviceMotion) {
        if self.isMotionBasedPanEnabled {
            var xRotationRate = motion.rotationRate.x
//            print("Rotation rate - x \(xRotationRate)")
            var zRotationRate = motion.rotationRate.z
            var yRotationRate = motion.rotationRate.y
            
            if fabs(yRotationRate) > (fabs(xRotationRate)+fabs(zRotationRate)) {
                var invertedYRotationRate = yRotationRate * -2
                
                var interpretedXOffset =  CGFloat(invertedYRotationRate * kRotationMultiplier)
                var contentOffset = self.clampedContentOffsetForHorizontalOffset(horizontalOffset:  interpretedXOffset)
                
                var percentageOffset = contentOffset.x/3300
//                print("Precent turned \(percentageOffset)")
//                UIView .animateWithDuration(kMovementSmoothing, delay: 0.0, options: .beginFromCurrentState, animations: { () -> Void in
//                    self.panningImageView.setContentOffset(CGPointMake(percentageOffset*self.panningImageView.contentSize.width, contentOffset.y), animated: false)
//                    self.panningScrollView.setContentOffset(contentOffset, animated: false)
//                    }, completion: nil)
                
            }
            
        }
    }
    
    func clampedContentOffsetForHorizontalOffset(horizontalOffset: CGFloat) -> CGPoint {
        var maximumXOffset:CGFloat = 1000.0
//            self.panningScrollView.contentSize.width - CGRectGetWidth(self.panningScrollView.bounds)
        var minimumXOffset = 0.0
        var clampedXOffset = fmax(minimumXOffset, Double(fmin(horizontalOffset, maximumXOffset)))
//        var centeredY = (self.panningScrollView.contentSize.height/2.0) - (CGRectGetHeight(self.panningScrollView.bounds)/2.0)
        var centeredY: CGFloat = 300
        return CGPoint(x: CGFloat(clampedXOffset), y: centeredY)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //        self.panningScrollView.contentOffset = CGPointMake((self.panningScrollView.contentSize.width / 2.0) - (CGRectGetWidth(self.panningScrollView.bounds)) / 2.0, (self.panningScrollView.contentSize.height / 2.0) - (CGRectGetHeight(self.panningScrollView.bounds)) / 2.0)
        self.motionManager.startDeviceMotionUpdates(to: OperationQueue.main) { (motion, error) in
            self.calculateRotationBasedOnDeviceMotionRotationRate(motion: motion!)
        }
//        self.motionManager.startDeviceMotionUpdatesToQueue(OperationQueue.main, withHandler: { (data: CMDeviceMotion!, error: NSError!) -> Void in
//            self.calculateRotationBasedOnDeviceMotionRotationRate(motion: data)
//        })
        
    }
    func captureButtonAction() {
        let captureVC = UIStoryboard(name: "HomePage", bundle: Bundle.main).instantiateViewController(withIdentifier: "CaptureVC")
        self.present(captureVC, animated: false, completion: nil)
    }
    
    // MARK: - Collection View Delegate Functions
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let itemDetailVC = UIStoryboard(name: "HomePage", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailItemVC") as! DetailViewController
        itemDetailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(itemDetailVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (self.collectionView.frame.width - padding * 3) / 2
        let ratio: CGFloat = 1334 / 750
        return CGSize(width: cellWidth, height: cellWidth * ratio)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return padding
    }
    
}
