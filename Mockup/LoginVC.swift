//
//  ViewController.swift
//  Mockup
//
//  Created by Quentin Duquesne on 03/12/2018.
//  Copyright © 2018 Quentin Duquesne. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.userNameTextField.layer.borderColor = UIColor(red: 61/255, green: 182/255, blue: 238/255, alpha: 1).cgColor
        self.userNameTextField.layer.borderWidth = CGFloat(Float(1.0))
        
        self.passwordTextField.layer.borderColor = UIColor(red: 61/255, green: 182/255, blue: 238/255, alpha: 1).cgColor
        self.passwordTextField.layer.borderWidth = CGFloat(Float(1.0))
        
    }
}

