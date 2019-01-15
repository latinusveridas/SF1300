//
//  PaymentMethodsVC.swift
//  Mockup
//
//  Created by Quentin Duquesne on 13/01/2019.
//  Copyright © 2019 Quentin Duquesne. All rights reserved.
//

import Foundation
import UIKit

class PaymentOptionsVC: UIViewController, CardIOPaymentViewControllerDelegate {
    
    
    @IBOutlet weak var CardNumberField: UITextField!
    @IBOutlet weak var CardExpirationField: UITextField!
    @IBOutlet weak var CardNameField: UITextField!
    @IBOutlet weak var CardCVCField: UITextField!
    
    @IBAction func ScanCard_Action(_ sender: Any) {

        let cardIOVC = CardIOPaymentViewController(paymentDelegate: self)!
        cardIOVC.collectCardholderName = true
        cardIOVC.hideCardIOLogo = true
        cardIOVC.guideColor = UIColor.blue
        cardIOVC.collectCVV = true
        present(cardIOVC, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func userDidCancel(_ paymentViewController: CardIOPaymentViewController!) {
        paymentViewController.dismiss(animated: true, completion: nil)
    }
    
    func userDidProvide(_ cardInfo: CardIOCreditCardInfo!, in paymentViewController: CardIOPaymentViewController!) {
        if let info = cardInfo {
            CardNumberField.text = info.redactedCardNumber
            CardExpirationField.text = String(info.expiryMonth) + "/" + String(info.expiryYear)
            CardNameField.text = info.cardholderName
            CardCVCField.text = info.cvv
        }
        paymentViewController.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func DismissVC_Action(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func Debug_Functions(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let DebugVC = storyBoard.instantiateViewController(withIdentifier: "DebugVC") as! UIViewController
        self.present(DebugVC, animated: true, completion: nil)
    }
    
    
}




