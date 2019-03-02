//
//  LoginViewController.swift
//  TravelDiary
//
//  Created by Siddhant Mishra on 16/02/19.
//  Copyright © 2019 Siddhant Mishra. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import TKSubmitTransition

class LoginViewController: UIViewController {

    //MARK: - UIElements
    @IBOutlet weak var loginMasterView: UIView!
    @IBOutlet weak var usernameView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginBtn: TKTransitionSubmitButton!
    var window: UIWindow?
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    
    var player: AVPlayer?
    let videoURL: NSURL = Bundle.main.url(forResource: "Aerial", withExtension: "mp4")! as NSURL
    
    //MARK: - View Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginMasterView.alpha = 0.0;
        loginMasterView.layer.zPosition = 0;
    
        player = AVPlayer(url: videoURL as URL)
        player?.actionAtItemEnd = .none
        player?.isMuted = true
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        playerLayer.zPosition = -1
        playerLayer.frame = view.frame
        view.layer.addSublayer(playerLayer)
        player?.play()
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem, queue: .main) { [weak self] _ in
                            self?.player?.seek(to: CMTime.zero)
                            self?.player?.play()
        }
        loginBtn.layer.cornerRadius = self.loginBtn.frame.size.width * 0.13
        loginBtn.layer.borderWidth = 0.5
        loginBtn.layer.borderColor = UIColor.init(displayP3Red: 52.0/255.0, green: 55.0/255.0, blue: 71.0/255.0, alpha: 1.0).cgColor
        loginBtn.addTarget(self, action: #selector(LoginViewController.onLoginButton(_:)), for: UIControl.Event.touchUpInside)

        usernameView.layer.cornerRadius = 30.0
        usernameView.layer.borderWidth = 0.5
        usernameView.layer.borderColor = UIColor.white.cgColor
        
        passwordView.layer.cornerRadius = 30.0
        passwordView.layer.borderWidth = 0.5
        passwordView.layer.borderColor = UIColor.white.cgColor
    }
    
    @IBAction func onLoginButton(_ button: TKTransitionSubmitButton ) {
        button.animate(1, completion: { () -> () in
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "Dashboard")
            vc.transitioningDelegate = self
            self.present(vc, animated: true, completion: nil)
        })
    }
}
    
extension LoginViewController:UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TKFadeInAnimator(transitionDuration: 0.5, startingAlpha: 0.8)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
}

extension LoginViewController : UITextFieldDelegate {
    //MARK: - TextField Delegate Functions
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

