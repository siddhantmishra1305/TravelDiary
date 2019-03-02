//
//  ViewController.swift
//  TravelDiary
//
//  Created by Siddhant Mishra on 27/01/19.
//  Copyright © 2019 Siddhant Mishra. All rights reserved.
//

import UIKit
import CoreData
import SideMenu

protocol TravelDetail {
    func travelRecordTapped(id:String,image:UIImage,title:String,date:String)
}

class DashBoardViewController: UIViewController {

    @IBOutlet weak var TopBar: UIView!
    @IBOutlet weak var NoRecordPlaceholder: UIView!
    @IBOutlet weak var TravelListView: UITableView!
    let helper = HelperClass()
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    var travelArray = [NSManagedObject]()
    var travelDetail : TravelDetail!
    
    //MARK: - View Setup
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        travelArray = helper.queryAllData(entity: "Travels")
        if travelArray.count == 0{
            NoRecordPlaceholder.isHidden = false
        }
        else{
            NoRecordPlaceholder.isHidden = true
        }
        self .TravelListView.reloadData()
        super.viewDidAppear(true)
    }
    
    //MARK: - Button Actions
    @IBAction func addNewTravel(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "AddNewTravel")
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func MenuBtnAction(_ sender: Any) {
    }
    
}

extension DashBoardViewController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return travelArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "travelCell", for: indexPath);
        helper.giveShadowToTableViewCell(cell: cell)
        let coverImage : UIImageView = cell.viewWithTag(3) as! UIImageView
        let title : UILabel = cell.viewWithTag(1) as! UILabel
        let date : UILabel = cell.viewWithTag(2) as! UILabel
        let travelObj = [travelArray[indexPath.row]]
        for result in travelObj{
            let imageURL = URL(fileURLWithPath:result.value(forKey: "imageURL") as! String)
            title.text = result.value(forKey: "travel") as? String
            date.text = result.value(forKey: "date") as? String
            
            let data = try? Data(contentsOf: imageURL)
            if let imageData = data {
                let image = UIImage(data: imageData)
                coverImage.image = image
                coverImage.layer.cornerRadius = coverImage.frame.width / 2
            }
        }
        return cell;
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "TravelDetail")
        self.travelDetail = vc as? TravelDetail
        let travelObj = [travelArray[indexPath.row]]
        for result in travelObj{
            let imageURL = URL(fileURLWithPath:result.value(forKey: "imageURL") as! String)
            let id = result.value(forKey: "id") as? String
            let date = result.value(forKey: "date") as? String
            let title = result.value(forKey: "travel") as? String
            
            let data = try? Data(contentsOf: imageURL)
            if let imageData = data {
                let image = UIImage(data: imageData)
                self.present(vc, animated: true, completion: nil)
                travelDetail?.travelRecordTapped(id: id!, image: image!, title: title!, date: date!)
            }
            else{
                let image = #imageLiteral(resourceName: "munnar")
                self.present(vc, animated: true, completion: nil)
                travelDetail?.travelRecordTapped(id: id!, image: image, title: title!, date: date!)
            }
        }
    }
}
