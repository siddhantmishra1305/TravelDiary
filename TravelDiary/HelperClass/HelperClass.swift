//
//  HelperClass.swift
//  TravelDiary
//
//  Created by Siddhant Mishra on 12/02/19.
//  Copyright © 2019 Siddhant Mishra. All rights reserved.
//

import UIKit
import CoreData


class HelperClass: NSObject {

    // MARK: - Travel Entity Functions
    
    func insertNewTravelRecord(travel:[String:String]) {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appdelegate.persistentContainer.viewContext
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Travels", in: context) else{
            print("Error initializing Travel")
            return
        }
        
            let moc = NSManagedObject(entity: entityDescription, insertInto: context)
            moc.setValue(travel["id"], forKey: "id")
            moc.setValue(travel["title"], forKey:"travel")
            moc.setValue(travel["date"], forKey: "date")
            moc.setValue(travel["venue"], forKey:"venue")
            moc.setValue(travel["tag"], forKey: "tags")
            moc.setValue(travel["noOfPeople"], forKey: "peopleCount")
            moc.setValue(travel["imagePath"], forKey: "imageURL")
            
            do{
                try context.save()
            }catch{
                print("Failed saving travel record")
            }
        
    }
    
    func queryAllData(entity:String) -> [NSManagedObject] {
        
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appdelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        var result = [NSManagedObject]()
        do{
            result = try context.fetch(request) as! [NSManagedObject]
        }
        catch{
        }
        return result
    }
    
    // MARK: - Directory Functions
    
    func saveImageToDocumentDirectory(_ chosenImage: UIImage,Name: String) -> String {
        let directoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        if !FileManager.default.fileExists(atPath: directoryPath) {
            do {
                try FileManager.default.createDirectory(at: NSURL.fileURL(withPath: directoryPath), withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
            }
        }
        let filename = Name.appending(".jpg")
        let filepath = directoryPath.appending(filename)
        let url = NSURL.fileURL(withPath: filepath)
        do {
            let imageData = chosenImage.jpegData(compressionQuality: 1.0)
            try imageData?.write(to: url, options: .atomic)
        } catch {
            print(error)
            print("file cant not be save at path \(filepath), with error : \(error)");
            
        }
        return filepath
    }

    func generateRowId() -> String {
        let length = 8
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0...length-1).map{ _ in letters.randomElement()! })
    }
    
    
    func getTagColor(tag:String) ->UIColor{
        
        let color:UIColor
        
        if (tag.caseInsensitiveCompare("Adventure") == .orderedSame){
            color = UIColor.orange
        }
        else if (tag.caseInsensitiveCompare("Holiday") == .orderedSame){
            color = UIColor.green
        }
        else if (tag.caseInsensitiveCompare("Summer") == .orderedSame){
            color = UIColor.yellow
        }
        else if (tag.caseInsensitiveCompare("Winter") == .orderedSame){
            color = UIColor.blue
        }
        else{
            color = UIColor.red
        }
        return color
    }
    
    func showAlert(Message:String,ViewController:UIViewController){
        let alert = UIAlertController(title: "Alert", message: Message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
                
            }}))
            ViewController.present(alert, animated: true, completion: nil)
    }
    // MARK: - Shadow to collection view cell
    func giveShadowToCollectionViewCell(cell:UICollectionViewCell){
        cell.layer.cornerRadius = 10.0
        cell.contentView.layer.cornerRadius = 10.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
        
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 1.5
        cell.layer.shadowOpacity = 0.2
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
    }
    // MARK: - Shadow to table view cell
    func giveShadowToTableViewCell(cell:UITableViewCell){
        
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
        
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 1.5
        cell.layer.shadowOpacity = 0.2
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
    }
    // MARK: - Custom Color
    func CustomThemeColor () -> UIColor{
        let color = UIColor.init(displayP3Red: 52.0/255.0, green: 55.0/255.0, blue: 71.0/255.0, alpha: 1.0)
        return color
    }
}
