//
//  ProfileViewController.swift
//  TravelDiary
//
//  Created by Siddhant Mishra on 23/02/19.
//  Copyright © 2019 Siddhant Mishra. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps

class ProfileViewController: UIViewController {

    //MARK: - UIElements
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var addProfilePicBtn: UIButton!
    @IBOutlet weak var NameView: UIView!
    @IBOutlet weak var EmailView: UIView!
    @IBOutlet weak var PhoneView: UIView!
    @IBOutlet weak var CityCiew: UIView!
    @IBOutlet weak var nameLBL: UILabel!
    @IBOutlet weak var name_tf: UITextField!
    @IBOutlet weak var email_lbl: UILabel!
    @IBOutlet weak var email_tf: UITextField!
    @IBOutlet weak var phone_lbl: UILabel!
    @IBOutlet weak var phone_tf: UITextField!
    @IBOutlet weak var city_lbl: UILabel!
    @IBOutlet weak var city_tf: UITextField!
    @IBOutlet weak var nameView_seprator: UIView!
    @IBOutlet weak var emailView_seprator: UIView!
    @IBOutlet weak var phoneView_seprator: UIView!
    @IBOutlet weak var cityView_seprator: UIView!
    var imagePicker = UIImagePickerController()
    let helper = HelperClass()
    var profileImage = UIImage()
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    
    //MARK: - View Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup Data when profile already filled
        self.setupUI()
        
    }
    
    func setupUI(){
        if let username = UserDefaults.standard.string(forKey: UserDefaultKeys.username.rawValue){
            self.name_tf.text = username
        }
        
        if let city = UserDefaults.standard.string(forKey: UserDefaultKeys.city.rawValue){
            self.city_tf.text = city
        }
        
        if let phone = UserDefaults.standard.string(forKey: UserDefaultKeys.phone.rawValue){
            self.phone_tf.text = phone
        }
        
        if let email = UserDefaults.standard.string(forKey: UserDefaultKeys.email.rawValue){
            self.email_tf.text = email
        }
        
        if let imageURL = UserDefaults.standard.string(forKey: UserDefaultKeys.imageUrl.rawValue){
            let url = URL(fileURLWithPath: imageURL)
            let data = try? Data(contentsOf:url)
            if let imageData = data {
                let image = UIImage(data: imageData)
                self.addProfilePicBtn.setImage(image, for: UIControl.State.normal)
                self.addProfilePicBtn.layer.cornerRadius = self.addProfilePicBtn.frame.width / 2
                self.addProfilePicBtn.layer.masksToBounds = true
            }
        }
    }
    
    //MARK: - UI Button Actions
    
    @IBAction func saveBtnAction(_ sender: Any) {
       let url = helper.saveImageToDocumentDirectory(profileImage, Name: name_tf.text!)
        
        UserDefaults.standard.set(name_tf.text!, forKey: UserDefaultKeys.username.rawValue)
        
        UserDefaults.standard.set(url, forKey: UserDefaultKeys.imageUrl.rawValue)
        
        UserDefaults.standard.set(city_tf.text!, forKey: UserDefaultKeys.city.rawValue)
        
        UserDefaults.standard.set(email_tf.text!, forKey: UserDefaultKeys.email.rawValue)
        
        UserDefaults.standard.set(phone_tf.text!, forKey: UserDefaultKeys.phone.rawValue)
        
        self.dismissVC()
    }
    
    @IBAction func addProfilePicBtnAction(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { _ in
            self.openGallery()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Open the camera
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        else{
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - Open the gallery
    func openGallery(){
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func dismissVC() {
        dismiss(animated: false, completion: nil)
    }
}

extension ProfileViewController : UITextFieldDelegate,GMSMapViewDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == name_tf {
            nameLBL.textColor = self.CustomThemeColor()
            nameView_seprator.backgroundColor = self.CustomThemeColor()
        }
        else if textField == phone_tf {
            phone_lbl.textColor = self.CustomThemeColor()
            phoneView_seprator.backgroundColor = self.CustomThemeColor()
        }
        else if textField == email_tf {
            email_lbl.textColor = self.CustomThemeColor()
            emailView_seprator.backgroundColor = self.CustomThemeColor()
        }
        else if textField == city_tf {
            let acController = GMSAutocompleteViewController()
            acController.delegate = self
            self.present(acController, animated: true, completion: nil)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    
        if textField == name_tf{
            nameLBL.textColor = UIColor.lightGray
            nameView_seprator.backgroundColor = UIColor.lightGray
        }
        else if textField == phone_tf{
            phone_lbl.textColor = UIColor.lightGray
            phoneView_seprator.backgroundColor = UIColor.lightGray
        }
        else if textField == email_tf{
            email_lbl.textColor = UIColor.lightGray
            emailView_seprator.backgroundColor = UIColor.lightGray
        }
        else if textField == city_tf{
            city_lbl.textColor = UIColor.lightGray
            cityView_seprator.backgroundColor = UIColor.lightGray
        }
    }
    
    func CustomThemeColor () -> UIColor{
        let color = UIColor.init(displayP3Red: 33.0/255.0, green: 152.0/255.0, blue: 192.0/255.0, alpha: 1.0)
        return color
    }
    
}

extension ProfileViewController : GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        self.city_tf.text = place.formattedAddress
        self.dismiss(animated: true, completion: nil)
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("Autocomplete was cancelled.")
        self.dismiss(animated: true, completion: nil)
    }
}

extension ProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{

            self.addProfilePicBtn.setImage(editedImage, for: UIControl.State.normal)
            self.addProfilePicBtn.layer.cornerRadius = self.addProfilePicBtn.frame.width / 2
            self.addProfilePicBtn.layer.masksToBounds = true
            profileImage = editedImage
        }
        //Dismiss the UIImagePicker after selection
        picker.dismiss(animated: true, completion: nil)
    }
}

