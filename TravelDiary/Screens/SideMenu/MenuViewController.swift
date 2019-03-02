//
//  MenuViewController.swift
//  TravelDiary
//
//  Created by Siddhant Mishra on 23/02/19.
//  Copyright © 2019 Siddhant Mishra. All rights reserved.
//

import UIKit
import SideMenu

class MenuViewController: UIViewController {

    //MARK: - UIElements
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var MenuTable: UITableView!

    var ProfileViewController: UIViewController!
    var loginViewController: UIViewController!
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    var Menu : [String] = ["Profile","Notifications","Help","Settings","Logout"]
    let helper = HelperClass()
    
    //MARK: - View Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add swipe gestures
        self.MenuSetup()
      
        // Menu Item setup
        self.MenuItemSetup()
        
        //Get profile data from user defaults
        if let username = UserDefaults.standard.string(forKey: UserDefaultKeys.username.rawValue){
            self.username.text = username
        }
        
        if let imageURL = UserDefaults.standard.string(forKey: UserDefaultKeys.imageUrl.rawValue){
            let url = URL(fileURLWithPath: imageURL)
            let data = try? Data(contentsOf:url)
            if let imageData = data {
                let image = UIImage(data: imageData)
                profileImageView.image = image
                profileImageView.layer.cornerRadius = self.profileImageView.frame.width / 2
                profileImageView.layer.masksToBounds = true
            }
        }
        
        
    }
    
    func MenuItemSetup(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let profileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        self.ProfileViewController = profileViewController
        
        let LoginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.loginViewController = LoginViewController
    }
    
    func MenuSetup(){
        
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
        SideMenuManager.default.menuFadeStatusBar = false
    
    }
}

extension MenuViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return Menu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath);
        
        let Image : UIImageView = cell.viewWithTag(1) as! UIImageView
        let title : UILabel = cell.viewWithTag(2) as! UILabel
        
        if Menu[indexPath.row] == "Profile"{
            Image.image = #imageLiteral(resourceName: "ProfileFilled")
        }
        else if Menu[indexPath.row] == "Settings"{
            Image.image = #imageLiteral(resourceName: "settings")
        }
        else if Menu[indexPath.row] == "Logout"{
            Image.image = #imageLiteral(resourceName: "Logout")
        }
        else if Menu[indexPath.row] == "Notifications"{
            Image.image = #imageLiteral(resourceName: "Notification")
        }
        else if Menu[indexPath.row] == "Help"{
            Image.image = #imageLiteral(resourceName: "Help")
        }
        title.text = Menu[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if Menu[indexPath.row] == "Profile"{
            present(ProfileViewController, animated: false, completion: nil)
        }
        else if Menu[indexPath.row] == "Settings"{
            
        }
        else if Menu[indexPath.row] == "Logout"{
            self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        }
        else{
            
        }
    }
}
