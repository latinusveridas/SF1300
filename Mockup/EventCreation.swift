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

class CreateEventVC: UIViewController {
    
    @IBOutlet weak var DatePicked: UILabel!
    @IBOutlet weak var Adress: UITextField!
    @IBOutlet weak var sportselected: UILabel!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var ParticipantField: UITextField!
    @IBOutlet weak var CreateEventButton: UIButton!
    @IBOutlet weak var DatePicker: UIDatePicker!
    @IBOutlet weak var SportPicker: UIPickerView!
    @IBOutlet weak var OrgID: UILabel!
    
    var sportsAV: [String] = []
    
    override func viewDidLoad() {
    super.viewDidLoad()

    // Add an event to call onDidChangeDate function when value is changed.
    DatePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)

     // Collect the available sports
    CollectAvailableSports() { result in
    self.sportsAV = result
    self.SportPicker.reloadAllComponents()
    }
        
    self.SportPicker.delegate = self
    self.SportPicker.dataSource = self
        
    OrgID.text = UserDefaults.standard.string(forKey: "organizerID")
    
    }
    
    
    @IBAction func Action_CreateEvent(_ sender: Any) {
        // This action create the payload and send it to the server
        
        //Prepare the data
        let data = PrepareData()
        
        
        /*isUploaded(eventData: data){ response in
            
            
        }*/
        
    }
    
    
    
    
    
// =================== CLASS HELPER FUNCTIONS =================================
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker){

        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()

        // Set date format
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"

        // Apply date format
        let selectedDate: String = dateFormatter.string(from: sender.date)

        print("Selected value \(selectedDate)")
        DatePicked.text = selectedDate
        
    }
    
    func PrepareData () -> [String:String] {
        
        // on ajoute les secondes pour etre au format dd/MM/yyyy HH:mm:SS
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        print(DatePicked.text!)
        print(DatePicked.description)
        let modDate = dateFormatter.date(from: DatePicked.text!)
        print(modDate)
        let strDate = dateFormatter.string(from: modDate)
        
        let dataLoad = [
        "date" : strDate,
        "address_string" : Adress.text!,
        "sport" : sportselected.text!,
        "price" : priceField.text!,
        "part_max" : ParticipantField.text!,
        "organizer_id": OrgID.text!
        
        ]
        
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
    
    //guard let eventData = try? JSONSerialization.data(withJSONObject: eventData, options: .prettyPrinted) else {return}
    
    //request.httpMethod = HTTPMethod.post.rawValue
    
    let headers: HTTPHeaders = [
        "Content-Type" : "application/json; charset=UTF-8"
    ]

    //request.httpBody = payLoad
    sessionManager.request(urlString, method: .post, parameters: eventData, encoding: JSONEncoding.default, headers: headers)
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


// =========== EXTENSIONS==============================

extension CreateEventVC : UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sportsAV.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        sportselected.text = sportsAV[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sportsAV[row]
    }

}
