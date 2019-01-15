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
    
    @IBOutlet weak var img: UIImageView!
    var imagePicker = UIImagePickerController()
    
    
    @IBAction func CloseAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func ShowPaymentMethodsVC(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let PaymentVC = storyBoard.instantiateViewController(withIdentifier: "PaymentMethodsID") as! PaymentOptionsVC
        self.present(PaymentVC, animated: true, completion: nil)
    }
    
    @IBAction func ChangeProfilePicture_Action(_ sender: Any) {
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker,animated: true,completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
    }
    
    
}

extension ProfileVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        img.image = image
        picker.dismiss(animated: true)
    }


    
}

extension UIImage {
    
    /*func load(image imageName: String) -> UIImage {
        
        // declare image location
        let imagePath: String = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/\(imageName).png"
        let imageUrl: URL = URL(fileURLWithPath: imagePath)
        
        // check if the image is stored already
        if FileManager.default.fileExists(atPath: imagePath),
            let imageData: Data = try? Data(contentsOf: imageUrl),
            let image: UIImage = UIImage(data: imageData, scale: UIScreen.main.scale) {
            return image
        }
        
        // image has not been created yet: create it, store it, return it
        let newImage: UIImage = // create your UIImage here
            try? UIImagePNGRepresentation(newImage)?.write(to: imageUrl)
        return newImage
    }*/
}
