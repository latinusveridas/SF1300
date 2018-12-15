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


