//
//  General Helpers.swift
//  Mockup
//
//  Created by Quentin Duquesne on 30/12/2018.
//  Copyright © 2018 Quentin Duquesne. All rights reserved.
//

import Foundation
import UIKit


extension UIViewController {
    
    func HideKeyboard(){
        let Tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        view.addGestureRecognizer(Tap)
        
    }
    
    @objc func DismissKeyboard() {
        
        view.endEditing(true)
        
    }
    
    
}
