//
//  EventCreation.swift
//  Mockup
//
//  Created by Quentin Duquesne on 18/12/2018.
//  Copyright © 2018 Quentin Duquesne. All rights reserved.
//

import Foundation
import UIKit

class CreateEventVC: UIViewController {
    
    @IBOutlet weak var DatePicked: UILabel!
    @IBOutlet weak var Adress: UITextField!
    @IBOutlet weak var sportselected: UILabel!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var ParticipantField: UITextField!
    @IBOutlet weak var CreateEventButton: UIButton!
    @IBOutlet weak var DatePicker: UIDatePicker!
    @IBOutlet weak var SportPicker: UIPickerView!
    
    override func viewDidLoad() {
    super.viewDidLoad()

    // Add an event to call onDidChangeDate function when value is changed.
    DatePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)

     // Populate the SportPicker
    SportPicker.dataSource = CollectAvailableSports()
    
    }
    
    
// =================== CLASS HELPER FUNCTIONS =================================
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker){

        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()

        // Set date format
        dateFormatter.dateFormat = "MM/dd/yyyy"

        // Apply date format
        let selectedDate: String = dateFormatter.string(from: sender.date)

        print("Selected value \(selectedDate)")
        DatePicked.text = selectedDate
        
    }
    
    func PrepareAndUpload () {
    
        var dataLoad = [
        "date" : DatePicked.text,
        "strAddress" : Adress.text,
        "sport" : sportselected.text,
        "price" : priceField.text,
        "part_max" : ParticipantField.text
        
        ]
    
    }
    
} // End of CreateEventVC class

// ================= HELPERS ==========================================

func ConfigureDatePicker(dPicker: UIDatePicker) {
    
    // Configuration
    dPicker.timeZone = NSTimeZone.local
    dPicker.backgroundColor = UIColor.white
    dPicker.datePickerMode = .date
    
} 

func CollectAvailableSports() -> [String] {
// This function collec the available sports and return them in an Array
    
    var collectedSports: [String] = []

    let SFTokenHandler = StreetFitTokenHandler()
    let sessionManager = SFTokenHandler.sessionManager
    sessionManager.adapter = SFTokenHandler
    sessionManager.retrier = SFTokenHandler
    let urlString = "http://83.217.132.102:3001/"

    sessionManager.request(targetURL, method: .get)
            .validate()
            .responseJSON { response in

                //print(response)

                switch response.result {

                case .success:

                    guard response.result.isSuccess else {return completion(nil)}
                    guard let rawInventory = response.result.value as? Array? else {return completion(nil)}

                    completion(rawInventory)

                case .failure(let error):
                    print(error)

                }

    }
    
}

protocol SportPicker : UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int,forComponent component: Int) -> String? {
        return "Sports"
    }

}
