//
//  TravelDetailViewController.swift
//  TravelDiary
//
//  Created by Siddhant Mishra on 20/02/19.
//  Copyright © 2019 Siddhant Mishra. All rights reserved.
//

import UIKit
import CoreData

class TravelDetailViewController: UIViewController {

    //MARK: - UIElements
    
    @IBOutlet weak var CoverPicture: UIImageView!
    @IBOutlet weak var tripName: UILabel!
    @IBOutlet weak var tripDate: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var editBtnAction: UIButton!
    @IBOutlet weak var DetailCollectionView: UICollectionView!
    @IBOutlet weak var BackBtn: UIButton!
    var helper = HelperClass()
    var travelArray = [[String:String]]()
    var Menu : [String] = ["Flight Booking","Hotel Booking","Gallery"]
    
    //MARK: - View Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        let dashVC = DashBoardViewController()
        dashVC.travelDetail = self
    }
    
    //MARK: - Button Actions
    
    @IBAction func BackBtnAction(_ sender: Any) {
        self.dismissVC()
    }
    
    func dismissVC() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}

extension TravelDetailViewController : UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return Menu.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat((collectionView.frame.size.width / 2) - 14), height: CGFloat(213))
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "travelDetailCell", for: indexPath);
        
        helper.giveShadowToCollectionViewCell(cell: cell)
        let Image : UIImageView = cell.viewWithTag(1) as! UIImageView
        let title : UILabel = cell.viewWithTag(2) as! UILabel
        
        if Menu[indexPath.row] == "Flight Booking"{
            Image.image = #imageLiteral(resourceName: "Flight")
        }
        else if Menu[indexPath.row] == "Hotel Booking"{
            Image.image = #imageLiteral(resourceName: "Hotel")
        }
        else if Menu[indexPath.row] == "Gallery"{
            Image.image = #imageLiteral(resourceName: "Gallery")
        }
        title.text = Menu[indexPath.row]
        return cell
    }
}

extension TravelDetailViewController: TravelDetail{
    
    func travelRecordTapped(id:String,image:UIImage,title:String,date:String){
        CoverPicture.image = image
        tripName.text = title
        tripDate.text = date
    }
}
