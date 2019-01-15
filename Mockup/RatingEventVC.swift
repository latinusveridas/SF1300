//
//  RatingEventVC.swift
//  Mockup
//
//  Created by Quentin Duquesne on 15/01/2019.
//  Copyright © 2019 Quentin Duquesne. All rights reserved.
//

import Foundation
import UIKit

class RatingEventVC : UIViewController  {
    
    @IBOutlet weak var CheckBoxYes: Checkbox!
    @IBOutlet weak var CheckBoxNo: Checkbox!
    @IBOutlet weak var StarsView: CosmosView!
    
    @IBAction func Close_Action(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Action_SendCom(_ sender: Any) {
        print(String(StarsView.rating))
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CheckBoxYes.checkedBorderColor = .blue
        CheckBoxYes.uncheckedBorderColor = .blue
        CheckBoxYes.borderStyle = .circle
        CheckBoxYes.checkmarkColor = .blue
        CheckBoxYes.checkmarkStyle = .tick
        CheckBoxYes.useHapticFeedback = true
        
        CheckBoxNo.checkedBorderColor = .blue
        CheckBoxNo.uncheckedBorderColor = .blue
        CheckBoxNo.borderStyle = .circle
        CheckBoxNo.checkmarkColor = .blue
        CheckBoxNo.checkmarkStyle = .cross
        CheckBoxNo.useHapticFeedback = true
        

    }
    
}



// ===================== RATING CONTROLLER ==================

