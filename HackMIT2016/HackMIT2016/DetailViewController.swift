//
//  DetailViewController.swift
//  HackMIT2016
//
//  Created by Nathan Gitter on 9/17/16.
//  Copyright © 2016 Nathan Gitter. All rights reserved.
//

import UIKit
import MediaPlayer

class DetailViewController: UIViewController{
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    
    var item: Item?
    var moviePlayer: MPMoviePlayerController?
    var tapGesture : UITapGestureRecognizer?
    var show = true;
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil // this is a hack to get the swipe back to work
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(DetailViewController.toggleBackground))
        self.view.addGestureRecognizer(tapGesture!)
        self.perform(#selector(DetailViewController.toggleBackground), with: nil, afterDelay: 4.0)
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }

   
    
    func playVideo() {
        
        let videoView = UIView(frame: CGRect(origin: CGPoint(x: self.view.bounds.origin.x,y :self.view.bounds.origin.y), size: CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height)))
        
        
        let pathToEx1 = Bundle.main.path(forResource: "myVideoFile", ofType: "mp4")
        let pathURL = NSURL.fileURL(withPath: pathToEx1!)
        moviePlayer = MPMoviePlayerController(contentURL: pathURL)
        if let player = moviePlayer {
            player.view.frame = videoView.bounds
            player.prepareToPlay()
            player.scalingMode = .aspectFill
            videoView.addSubview(player.view)
        }
        
        self.view.addSubview(videoView)
    }
    
    func toggleBackground(){
            show = !show
        if show{
            showBackground()
        }else{
            hideBackground()
        }
        
    }
    
    func showBackground(){
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.25)
        self.backgroundView.transform = CGAffineTransform.identity
    
        UIView.commitAnimations()
        
    }
    
    func hideBackground(){
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.25)
        self.backgroundView.transform = CGAffineTransform(translationX: 0, y: self.backgroundView.frame.size.height)
        UIView.commitAnimations()
    }
    
}
