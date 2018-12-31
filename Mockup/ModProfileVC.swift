//
//  ModProfileVC.swift
//  Mockup
//
//  Created by Quentin Duquesne on 06/12/2018.
//  Copyright © 2018 Quentin. All rights reserved.
//

import Foundation
import UIKit

class ModProfileVC : ViewController {
    
    @IBOutlet weak var img: UIImageView!
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    } // end of viewDidLoad
    
    @IBAction func inClickPickImage(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker,animated: true,completion: nil)
    }
    
    
} // end of ModProfileVC

extension ImageCropVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            img.image = image
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
}
