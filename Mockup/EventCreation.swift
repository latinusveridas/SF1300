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
        datePicker.addTarget(self, action: #selector(ViewController.datePickerValueChanged(_:)), for: .valueChanged)
    }

    @IBAction func updateSelectedDateField(sender: DatePicker) {
    DatePicked.text = DatePicker
    }
    
}

func ConfigureDatePicker(dPicker: UIDatePicker) {
    
    // Configuration
    dPicker.timewone = NSTimeZone.local
    dPicker.backgroundColor = UIColor.white
    
} 

func datePickerValueChanged(_ sender: UIDatePicker){

    // Create date formatter
    let dateFormatter: DateFormatter = DateFormatter()

    // Set date format
    dateFormatter.dateFormat = "MM/dd/yyyy"

    // Apply date format
    let selectedDate: String = dateFormatter.string(from: sender.date)

    print("Selected value \(selectedDate)")
}
