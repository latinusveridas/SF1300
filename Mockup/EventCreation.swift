//
//  EventCreation.swift
//  Mockup
//
//  Created by Quentin Duquesne on 18/12/2018.
//  Copyright © 2018 Quentin Duquesne. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import ARSLineProgress

class CreateEventVC: UIViewController {
    
    @IBOutlet weak var DatePicked: UILabel!
    @IBOutlet weak var Adress: UITextField!
    @IBOutlet weak var sportselected: UILabel!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var ParticipantField: UITextField!
    @IBOutlet weak var CreateEventButton: UIButton!
    @IBOutlet weak var DatePicker: UIDatePicker!
    @IBOutlet weak var SportPicker: UIPickerView!

    var pricePicker: UIPickerView = UIPickerView()
    let arrPrices = [5,10,15,20,25,30,35,40,45,50]
    var sportsAV: [String] = []
    let orgID = UserDefaults.standard.string(forKey: "organizerID")!
    
    override func viewDidLoad() {
    super.viewDidLoad()
    self.HideKeyboard()
        
    // Add an event to call onDidChangeDate function when value is changed.
    DatePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)

     // Collect the available sports
    CollectAvailableSports() { result in
    self.sportsAV = result
    self.SportPicker.reloadAllComponents()
    // Delegation of the ViewPickers
        print(self.sportsAV)
        print(self.sportsAV.count)
        self.SportPicker.delegate = self
        self.SportPicker.dataSource = self
        self.pricePicker.dataSource = self
        self.pricePicker.delegate = self
        }
    
    priceField.inputView = pricePicker
        
    } // end of viewdidload
    
    
    @IBAction func Action_CreateEvent(_ sender: Any) {
        // This action create the payload and send it to the server
        
        //ARSLineProgress.showWithProgress(initialValue: 1.00)
        
        //Prepare the data
        let data = PrepareData()
            
        isUploaded(eventData: data){ response in
            
            if response == true {
                print("in true isUploaded")
               let alertController = UIAlertController(title: "StreetFit", message: "Votre évenement a bien été créé !", preferredStyle: UIAlertController.Style.alert)
                let showNextController = UIAlertAction(title: "Ok", style: .default) { (action: UIAlertAction) in
                    
                    self.dismiss(animated: true, completion: nil)
                }
                
                alertController.addAction(showNextController)
                self.present(alertController,animated: true,completion: nil)

                //ARSLineProgress.showWithProgress(initialValue: 100.00)
                
            } else {
                
                let alertController = UIAlertController(title: "StreetFit", message: "FAIL", preferredStyle: UIAlertController.Style.alert)
                let showNextController = UIAlertAction(title: "Ok", style: .default) { (action: UIAlertAction) in }
                
            }
            
        }
        
    }
    
    @IBAction func CloseView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
// =================== CLASS HELPER FUNCTIONS =================================
    
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {

        DatePicked.text = dateEventToLocal(trgetDate: sender.date)
        
    }
    
    func dateEventToLocal(trgetDate: Date) -> String {
        
        let localTimeZoneID = TimeZone.current.localizedName(for: .shortStandard, locale: .current) ?? ""
        print(localTimeZoneID)
        let dateFormatWithoutSeconds = DateFormatter()
        dateFormatWithoutSeconds.dateFormat = "yyyy-MM-dd HH:mm" // Delete of seconds
        dateFormatWithoutSeconds.timeZone = TimeZone(identifier: localTimeZoneID)
        
        let strDateWithoutSeconds: String = dateFormatWithoutSeconds.string(from: trgetDate) + ":00"
        print("String local", strDateWithoutSeconds)
        
        return strDateWithoutSeconds
        
    }
    
    func dateEventToUTC(trgetDate: Date) -> String {
        
        let newFormat = DateFormatter()
        newFormat.dateFormat = "yyyy-MM-dd HH:mm" // Delete of seconds
        newFormat.timeZone = TimeZone(identifier: "UTC")
        
        let utcString: String = newFormat.string(from: trgetDate) + ":00"
        print("String UTC ", utcString)
        
        return utcString
        
    }
    
    
    func PrepareData () -> [String:String] {
        
        // on ajoute les secondes pour etre au format dd/MM/yyyy HH:mm:SS
        let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        print(DatePicked.text!)
        let modDate: String = DatePicked.text! + ":00"
        
        let dataLoad: [String:String]
        
        dataLoad = [
        "date" : modDate,
        "address_string" : Adress.text!,
        "sport" : sportselected.text!,
        "price" : priceField.text!,
        "part_max" : ParticipantField.text!,
        "organizer_id": orgID
        ]
        
        print("Date prepared by PrepareData function is ", modDate)
        print("PREPARE DATA", dataLoad.description)
        return dataLoad
    
    }
    
} // End of CreateEventVC class

// ================= HELPERS ==========================================

func ConfigureDatePicker(dPicker: UIDatePicker) {
    
    // Configuration
    dPicker.timeZone = NSTimeZone.local
    dPicker.minimumDate = Date()
    dPicker.backgroundColor = UIColor.white
    dPicker.datePickerMode = .dateAndTime
    
} 

func CollectAvailableSports(completion: @escaping ([String]) -> ()) {
// This function collec the available sports and return them in an Array

    let SFTokenHandler = StreetFitTokenHandler()
    let sessionManager = SFTokenHandler.sessionManager
    sessionManager.adapter = SFTokenHandler
    sessionManager.retrier = SFTokenHandler
    let urlString = "http://83.217.132.102:3001/sports"
    
    sessionManager.request(urlString)
            .validate()
            .responseJSON { response in

                print(response)

                switch response.result {

                case .success:

                    guard response.result.isSuccess else {return completion([])}
                    guard let rawInventory = response.result.value as? [String] else {return completion([])}

                    completion(rawInventory)

                case .failure(let error):
                    print(error)

                }

            }
        
    }

func isUploaded(eventData: [String:String?], completion: @escaping (Bool) -> ()) {
    // This function upload the event_data and return a bool indicating completion
    
    let SFTokenHandler = StreetFitTokenHandler()
    let sessionManager = SFTokenHandler.sessionManager
    sessionManager.adapter = SFTokenHandler
    sessionManager.retrier = SFTokenHandler
    let urlString = "http://83.217.132.102:3000/auth/experlogin/createevent"
    
    let headers: HTTPHeaders = [
        "Content-Type" : "application/json; charset=UTF-8"
    ]

    sessionManager.request(urlString, method: .post, parameters: eventData, encoding: JSONEncoding.default, headers: headers)
        .validate()
        .responseJSON { response in
            
            print(response)
            
            switch response.result {
                
            case .success:
                
                guard response.result.isSuccess else {return completion(false)}
                guard let rawInventory = response.result.value as? [String:Any]? else {return completion(false)}
                
                print(rawInventory)
                
                var successStatus = rawInventory!["success"] as! Int
                
                if successStatus == 1 {
                    completion(true)
                } else {
                    completion(false)
                }
                
            case .failure(let error):
                print(error)
                
            }
            
    }
    
}


func isTxtFldVoid(txtFld : UITextField) -> Bool {
// This function test if the text field is nil to avoid to send nil data to the server
    
    if txtFld.text! == nil {
    return true
    } else {
    return false
    }

}

// ====================== EXTENSIONS ==============================

extension CreateEventVC : UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == SportPicker {
            return sportsAV.count
        } else {
            if pickerView == pricePicker {
            return arrPrices.count
        }
            else {return 0}
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == SportPicker {
        sportselected.text = sportsAV[row]
        } else {
            if pickerView == pricePicker {
        priceField.text = String(arrPrices[row])
        }
            else {}
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == SportPicker {
            return String(sportsAV[row])
        } else if pickerView == pricePicker {
        return String(arrPrices[row])
        } else {
            return ""
        }
        
        
    }

}
