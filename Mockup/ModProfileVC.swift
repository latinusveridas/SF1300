//
//  ModProfileVC.swift
//  Mockup
//
//  Created by Quentin Duquesne on 06/12/2018.
//  Copyright © 2018 Quentin. All rights reserved.
//

import Foundation
import UIKit

class ModProfileVC : ViewController {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var updateProfilePicture: UIButton!
    @IBOutlet weak var emailAddress: UITextField!
    
    var imagePicker = UIImagePickerController()
    var userData: [String:String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    } // end of viewDidLoad
    
    @IBAction func inClickPickImage(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker,animated: true,completion: nil)
    }
    
    
} // end of ModProfileVC

// ===================================== EXTENSION ============================================

extension ImageCropVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            img.image = image
            
        }   
        dismiss(animated: true, completion: nil)
    }    
}

// ===================================== FUNCTIONS =====================================

func collectUserData(userId: String, completion: @escaping ([String:Any]) -> ()) {
    // This function collect userData in an Dictionnary
    
    let SFTokenHandler = StreetFitTokenHandler()
    let sessionManager = SFTokenHandler.sessionManager
    sessionManager.adapter = SFTokenHandler
    sessionManager.retrier = SFTokenHandler
    let urlString = "http://83.217.132.102:3000/auth/experlogin/xxxx"
    
    let headers: HTTPHeaders = [
        "Content-Type" : "application/json; charset=UTF-8",
        "user_id" : userId
    ]

    sessionManager.request(urlString, method: .post, parameters: eventData, encoding: JSONEncoding.default, headers: headers)
        .validate()
        .responseJSON { response in
            print(response)
            switch response.result {          
            case .success:         
                guard response.result.isSuccess else {return completion(false)}
                guard let rawInventory = response.result.value as? [String:Any]? else {return completion(false)}

                var successStatus = rawInventory!["success"] as! Int
                
                if successStatus == 1 {
                    completion(rawInventory)
                } else {
                    completion([:])
                }   
            case .failure(let error):
                print(error)            
            }   // switch
    } //request
    
} //function collectUserData
