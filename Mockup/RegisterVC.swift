//
//  RegisterVC.swift
//  Mockup
//
//  Created by Quentin Duquesne on 15/12/2018.
//  Copyright © 2018 Quentin Duquesne. All rights reserved.
//

import Foundation
import UIKit

class RegisterVC: UIViewController {
    
    @IBOutlet weak var SurnameField: UITextField!
    @IBOutlet weak var NameField: UITextField!
    @IBOutlet weak var BornDateField: UITextField!
    @IBOutlet weak var PasswordField: UITextField!
    @IBOutlet weak var EmailField: UITextField!
    @IBOutlet weak var UserConditionsLabel: UILabel!
    
    @IBAction func Action_Dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configuration des textbox
        let textFields = [self.SurnameField,
                          self.NameField,
                          self.BornDateField,
                          self.PasswordField,
                          self.EmailField
        ]
    
        textFields.forEach { field in
            field!.layer.borderColor = UIColor(red: 61/255, green: 182/255, blue: 238/255, alpha: 1).cgColor
            field!.layer.borderWidth = CGFloat(Float(1.0))
        }
        
        UserConditionsLabel.text = "En cliquant sur S’inscrire, vous reconnaissez avoir lu et approuvez les Conditions d’utilisation et la Politique de confidentialité."
        

    }
    
    
}


/////

 func PrepareData () -> [String:String] {
        
        let dataLoad = [
        "surname": SurnameField.text!,
        "name": NameField.text!,
        "born_date": BornDateField.text!,
        "password": PasswordField.text!,
        "email": EmailField.text!,
        ]
        
        print("PREPARED DATA", dataLoad.description)
        return dataLoad
    
    }

func isUploaded(userData: [String:String?], completion: @escaping (Bool) -> ()) {
    // This function upload the userData and return a bool indicating completion
    
    let SFTokenHandler = StreetFitTokenHandler()
    let sessionManager = SFTokenHandler.sessionManager
    sessionManager.adapter = SFTokenHandler
    sessionManager.retrier = SFTokenHandler
    let urlString = "http://83.217.132.102:3000/auth/users/registerxxxxxx"
        
    let headers: HTTPHeaders = [
        "Content-Type" : "application/json; charset=UTF-8"
    ]

    sessionManager.request(urlString, method: .post, parameters: userData, encoding: JSONEncoding.default, headers: headers)
        .validate()
        .responseJSON { response in
            
            print(response)
            
            switch response.result {
                
            case .success:
                
                guard response.result.isSuccess else {return completion(false)}
                guard let rawInventory = response.result.value as? [[String:Any]?] else {return completion(false)}
                
                print(rawInventory)
                
               /* if rawInventory["success"] == "1" {
                    
                } else {
                    
                }*/
                
            case .failure(let error):
                print(error)
                
            }
            
    }
    
}
