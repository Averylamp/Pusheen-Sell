//
//  ViewController.swift
//  HackMIT2016
//
//  Created by Nathan Gitter on 9/17/16.
//  Copyright © 2016 Nathan Gitter. All rights reserved.
//

import UIKit

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
