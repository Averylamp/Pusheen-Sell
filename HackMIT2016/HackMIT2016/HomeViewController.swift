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
    var videos : [Data] = [Data]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.captureButton.addTarget(self, action: #selector(HomeViewController.captureButtonAction), for: UIControlEvents.touchUpInside)
        Fireb.getAllitem { (items) in
            self.items = items
            self.collectionView.reloadData()
            for i : Item in items{
                Fireb.downloadFileFromServer(i.key, callback: { data in
                    self.videos.append(data)
                    
                    let filemanager = FileManager.default
                    let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(i.key + ".mp3")
                    if !filemanager.fileExists(atPath: paths){
                        let url : NSURL = NSURL(string: i.key + ".mp3")!
                        do {
                            try data.write(to: url as URL, options: Data.WritingOptions.atomicWrite)
                        } catch {
                            print(error)
                        }
                    }else{
                        print("Already video present created.")
                    }
                    
                    
                    
                    
                    print("Data length for item : \(i.name) is \(data.count)")
                })
            }
        }
        
    }
    
    func captureButtonAction() {
        let captureVC = UIStoryboard(name: "HomePage", bundle: Bundle.main).instantiateViewController(withIdentifier: "CaptureVC")
        self.present(captureVC, animated: false, completion: nil)
    }
    
    // MARK: - Collection View Delegate Functions
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : ItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath) as! ItemCell
        
        if self.items.count > 0 {
            let item : Item = self.items[indexPath.row]
            cell.titleLabel.text = item.name
            cell.subtitleLabel.text = item.description
        }
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
