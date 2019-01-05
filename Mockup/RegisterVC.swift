//
//  RegisterVC.swift
//  Mockup
//
//  Created by Quentin Duquesne on 15/12/2018.
//  Copyright © 2018 Quentin Duquesne. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

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
        HideKeyboard()  
        
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
    
    
// ====================== CLASS HELPERS FUNCTIONS ========================
    
    func PrepareData () -> [String:String] {
        // This function collect the data and put all the stuff in a Dictionary
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
    
    
} // End of RegisterClass


// ================================= HELPERS ========================================



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
    
} // end of function isUploaded

extension UITextField {
    
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }
} // end of extension Uitextfield
