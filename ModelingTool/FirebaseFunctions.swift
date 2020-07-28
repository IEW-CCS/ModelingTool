//
//  FirebaseFunctions.swift
//  ModelingTool
//
//  Created by Lo Fang Chou on 2020/7/21.
//  Copyright © 2020 JStudio. All rights reserved.
//

import Foundation
import Firebase
import Cocoa

func downloadFBDetailBrandProfile(brand_name: String, completion: @escaping (DetailBrandProfile?) -> Void) {
    var brandData: DetailBrandProfile = DetailBrandProfile()
    let databaseRef = Database.database().reference()
    let pathString = "DETAIL_BRAND_PROFILE/\(brand_name)"

    databaseRef.child(pathString).observeSingleEvent(of: .value, with: { (snapshot) in
        if snapshot.exists() {
            let brandProfile = snapshot.value
            let jsonData = try? JSONSerialization.data(withJSONObject: brandProfile as Any, options: [])
            //let jsonString = String(data: jsonData!, encoding: .utf8)!
            //print("brandProfile jsonString = \(jsonString)")

            let decoder: JSONDecoder = JSONDecoder()
            do {
                brandData = try decoder.decode(DetailBrandProfile.self, from: jsonData!)
                print("brandData decoded successful !!")
                print("brandData = \(brandData)")
                completion(brandData)
            } catch {
                print("downloadFBDetailBrandProfile brandData jsonData decode failed: \(error.localizedDescription)")
                completion(nil)
            }
        } else {
            print("downloadFBDetailBrandProfile DETAIL_BRAND_PROFILE snapshot doesn't exist!")
            completion(nil)
        }
    })  { (error) in
        print("downloadFBDetailBrandProfile Firebase error = \(error.localizedDescription)")
        completion(nil)
    }
}

func downloadFBDetailMenuInformation(menu_number: String, completion: @escaping (DetailMenuInformation?) -> Void) {
    var menuData: DetailMenuInformation = DetailMenuInformation()
    let databaseRef = Database.database().reference()
    let pathString = "DETAIL_MENU_INFORMATION/\(menu_number)"

    databaseRef.child(pathString).observeSingleEvent(of: .value, with: { (snapshot) in
        if snapshot.exists() {
            let menuInfo = snapshot.value
            let jsonData = try? JSONSerialization.data(withJSONObject: menuInfo as Any, options: [])
            //let jsonString = String(data: jsonData!, encoding: .utf8)!
            //print("menuInfo jsonString = \(jsonString)")

            let decoder: JSONDecoder = JSONDecoder()
            do {
                menuData = try decoder.decode(DetailMenuInformation.self, from: jsonData!)
                print("menuData decoded successful !!")
                print("menuData = \(menuData)")
                completion(menuData)
            } catch {
                print("downloadFBDetailMenuInformation menuData jsonData decode failed: \(error.localizedDescription)")
                completion(nil)
            }
        } else {
            print("downloadFBDetailMenuInformation DETAIL_MENU_INFORMATION snapshot doesn't exist!")
            completion(nil)
        }
    })  { (error) in
        print("downloadFBDetailMenuInformation Firebase error = \(error.localizedDescription)")
        completion(nil)
    }
}

func uploadFBBrandCategory(brand_name: String, brand_category: DetailBrandCategory) {
    
    let databaseRef = Database.database().reference()
    let pathString = "BRAND_CATEGORY/\(brand_name)"
    
    databaseRef.child(pathString).setValue(brand_category.toAnyObject())
}

func uploadFBDetailBrandProfile(brand_name: String, brand_profile: DetailBrandProfile) {
    
    let databaseRef = Database.database().reference()
    let pathString = "DETAIL_BRAND_PROFILE/\(brand_name)"
    
    databaseRef.child(pathString).setValue(brand_profile.toAnyObject())
}

func uploadFBDetailMenuInformation(menu_number: String, menu_info: DetailMenuInformation) {
    
    let databaseRef = Database.database().reference()
    let pathString = "DETAIL_MENU_INFORMATION/\(menu_number)"
    
    databaseRef.child(pathString).setValue(menu_info.toAnyObject()) { (error, reference) in
        if error != nil {
            _ = dialogInformation(title: "Error", message: error!.localizedDescription)
            return
        }
        
        _ = dialogInformation(title: "Information", message: "Upload Detail Menu Information Successful!")
    }
}

func uploadFBBrandIconImage(brand_name: String, image: NSImage) {
    let targetSize = NSSize(width: 200.0, height: 200.0)
    let resizeImage = image.resized(to: targetSize)
    let imageData = resizeImage?.representations.first as? NSBitmapImageRep
    
    let uploadData = imageData!.representation(using: .jpeg, properties: [:])
    
    let pathString = "Brand_Image/\(brand_name).jpg"
    print("pathString = \(pathString)")
    let storageRef = Storage.storage().reference().child(pathString)
    

    storageRef.putData(uploadData!, metadata: nil, completion: { (data, error) in
        if error != nil {
            print(error!.localizedDescription)
            _ = dialogInformation(title: "Error", message: error!.localizedDescription)
            return
        }
        
        _ = dialogInformation(title: "Information", message: "Upload Icon Image to Storage Successful!")
    })
    
}
