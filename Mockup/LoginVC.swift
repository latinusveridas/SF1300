//
//  ViewController.swift
//  Mockup
//
//  Created by Quentin Duquesne on 03/12/2018.
//  Copyright © 2018 Quentin Duquesne. All rights reserved.
//

import UIKit
import Alamofire
import ARSLineProgress

class LoginVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // Chargement du ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Cosmetic
        
        self.emailTextField.layer.borderColor = UIColor(red: 61/255, green: 182/255, blue: 238/255, alpha: 1).cgColor
        self.emailTextField.layer.borderWidth = CGFloat(Float(1.0))
        
        self.passwordTextField.layer.borderColor = UIColor(red: 61/255, green: 182/255, blue: 238/255, alpha: 1).cgColor
        self.passwordTextField.layer.borderWidth = CGFloat(Float(1.0))
        
        // Hide Keyboard
        
        self.HideKeyboard()
        
    }
    
    
    @IBAction func ActionLogin(_ sender: Any) {
        
        // Verification champs vides
        
        if (self.emailTextField.text!.isEmpty == true || self.passwordTextField.text!.isEmpty == true ) {
            
            let alertController = UIAlertController(title: "Attention", message: "Un champ est vide", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            present(alertController,animated: true,completion: nil)
            
        } else {
            
            let emailStr =  self.emailTextField.text!
            let pwStr = self.passwordTextField.text!
            
            isAlamoLoginSuccess(email: emailStr, password: pwStr) { boolResult in
                
                if boolResult == true {
                    
                    // Message de succes
                    ARSLineProgress.showSuccess()
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let newViewController = storyBoard.instantiateViewController(withIdentifier: "IDCurrentEvents")
                    self.present(newViewController,animated: true,completion: nil)
                    /*let alertController = UIAlertController(title: "StreetFit", message: "Bienvenue", preferredStyle: UIAlertController.Style.alert)
                    let showNextController = UIAlertAction(title: "Ok", style: .default) { (action: UIAlertAction) in
                        // Show next ViewController
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let newViewController = storyBoard.instantiateViewController(withIdentifier: "IDCurrentEvents")
                        self.present(newViewController, animated: true, completion: nil)
                    }
                    
                    alertController.addAction(showNextController)
                    self.present(alertController,animated: true,completion: nil)
                    */
                } else {
                    
                    // En cas de pb, message d'erreur
                    ARSLineProgress.showFail()
                    /*let alertController = UIAlertController(title: "StreetFit", message: "Echec de la connection", preferredStyle: UIAlertController.Style.alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alertController,animated: true,completion: nil)*/
                }
                
            } // Fin du closure Alamo
            
        }
        
        
    } // Fin de la fonction ActionLogin
    
    
    
    
} // Fin de la classe LoginVC




// ================================= MAIN FUNCTIONS =================================

func isAlamoLoginSuccess(email: String, password: String, completion: @escaping (Bool) -> Void) {
    
    // On prepare le payLoad a envoyer pour le login
    
    let targetURL = "http://83.217.132.102:3000/auth/login"
    let payloadDict = [
        "email" : email,
        "password" : password
    ]
    guard let payLoad = try? JSONSerialization.data(withJSONObject: payloadDict, options: .prettyPrinted) else {return}
    
    // On prepare la requete
    
    let url = URL(string: targetURL)!
    var request = URLRequest(url: url)
    request.httpMethod = HTTPMethod.post.rawValue
    request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
    request.httpBody = payLoad
    
    // on lance la requete Alamo
    
    Alamofire.request(request).responseJSON { response in

            print("!!!!", response)
        
        // On utilise Do..catch pour eviter les problemes
        
        do {
            let decoder = JSONDecoder()
            let model = try decoder.decode(MainResStruct.self, from: response.data!)
            
            if model.success == 1 {
                
                // Loading JWT1 in iPhone Memory
                let obtainedJWT1 = model.data!.jwt1!
                
                let defaults = UserDefaults.standard
                defaults.set(obtainedJWT1, forKey: "jwt1")
                print("Stored JWT1 in UserDefault Memory: ", defaults.string(forKey: "jwt1")!)
                
                // Loading Organizer_ID in iPhone Memory
                if let obtainedOrganizerId = model.data?.organizer_id {
                
                    defaults.set(obtainedOrganizerId, forKey: "organizerID")
                    print("New Stored Org_ID is ", defaults.string(forKey: "organizerID")!)
        
                    completion(true)
                    
                } else {
                    
                    completion(true)
                    
                }
                

            }
            
        } catch {
    
            completion(false)
        }
        
    }
    
} // Fin de la fonction AlamoLogin


// ====================================== DATA STRUCTURING ===============================

struct MainResStruct: Codable {
    let error: Int
    let errorDescription: String
    let success: Int
    let typeData: String
    let data: AuthData?
    
    enum CodingKeys: String, CodingKey {
        case error
        case errorDescription = "error_description"
        case success
        case typeData = "type_data"
        case data
    }
}

struct AuthData: Codable {
    let fieldCount: Int?
    let affectedRows: Int?
    let insertId: Int?
    let serverStatus: Int?
    let warningCount: Int?
    let message: String?
    let protocol41: Bool?
    let changedRows: Int?
    let jwt1 : String?
    let jwt2 : String?
    let organizer_id : String?
    
    enum CodingKeys: String, CodingKey {
        case fieldCount
        case affectedRows
        case insertId
        case serverStatus
        case warningCount
        case message
        case protocol41
        case changedRows
        case jwt1 = "JWT1"
        case jwt2 = "JWT2"
        case organizer_id
    }
}


