//
//  ProfileVC.swift
//  Mockup
//
//  Created by Quentin Duquesne on 05/01/2019.
//  Copyright © 2019 Quentin Duquesne. All rights reserved.
//

import Foundation
import UIKit

class ProfileVC: UIViewController {
    
    @IBAction func CloseAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func ShowPaymentMethodsVC(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let PaymentVC = storyBoard.instantiateViewController(withIdentifier: "PaymentMethodsID") as! PaymentOptionsVC
        self.present(PaymentVC, animated: true, completion: nil)
    }
    
    
    
}
