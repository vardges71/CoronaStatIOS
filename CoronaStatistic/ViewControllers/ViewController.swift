//
//  ViewController.swift
//  CoronaStatistic
//
//  Created by Vardges Gasparyan on 2020-04-25.
//  Copyright © 2020 Vardges Gasparyan. All rights reserved.
//

import UIKit
import AVKit
import FirebaseAuth

class ViewController: UIViewController {
    
    var videoPlayer:AVPlayer?
    var videoPlayerLayer:AVPlayerLayer?

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupElements()
    }
    
    override func viewDidAppear(_ animated: Bool){
    
    if Auth.auth().currentUser != nil {
        
      // User is signed in.
        let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Stroryboard.homeViewController) as? HomeViewController
        
        self.view.window?.rootViewController = homeViewController
        self.view.window?.makeKeyAndVisible()
    } else {
      // No user is signed in.
        
        return
    }}
    
    func setupElements() {
        
        Utilities.styleFilledButton(loginButton)
        Utilities.styleHollowButton(registerButton)
    }

    override func viewWillAppear(_ animated: Bool) {
            
        setUpVideo()
    }
    
    func setUpVideo() {
        
        // Get the file to the resource in the bundle
        let bundlePath = Bundle.main.path(forResource: "Covid19", ofType: "mp4")
        
        guard bundlePath != nil else {
            return
        }
        
        // Create the URL from it
        let url = URL(fileURLWithPath: bundlePath!)
        
        
        // Create the video player item
        
        let item = AVPlayerItem(url: url)
        
        // Create the player
        videoPlayer = AVPlayer(playerItem: item)
        
        // Create the layer
        videoPlayerLayer = AVPlayerLayer(player: videoPlayer!)
        
        // Adjust the size and frame
        videoPlayerLayer?.frame = CGRect(x: -self.view.frame.size.width*1.5, y: 0, width: self.view.frame.size.width*4, height: self.view.frame.size.height)
        view.layer.insertSublayer(videoPlayerLayer!, at: 0)
        
        // Add it to the view and play it
        videoPlayer?.playImmediately(atRate: 1.5)
    }

}

