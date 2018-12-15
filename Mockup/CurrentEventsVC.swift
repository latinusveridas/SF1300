//
//  CurrentEventsVC.swift
//  Mockup
//
//  Created by Quentin Duquesne on 15/12/2018.
//  Copyright © 2018 Quentin Duquesne. All rights reserved.
//

import Foundation
import UIKit

class CurrentEventsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // ============================== VARIABLES
    
    // When data is received, it's filled in eventsList
    var eventsList: [eventClass] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // ============================== TABLE FUNCTIONS ============================
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "protoEventCell", for: indexPath) as! eventUICell
        cell.labelEvent_id.text = eventsList[indexPath.row].event_id
        cell.labelDate.text = eventsList[indexPath.row].date
        cell.labelLocation.text = eventsList[indexPath.row].location
        cell.labelSport.text = eventsList[indexPath.row].sport
        cell.labelFirstName.text = eventsList[indexPath.row].first_name
        cell.labelLatitude.text = eventsList[indexPath.row].latitude
        cell.labelLongitude.text = eventsList[indexPath.row].longitude
        
        // Not string data converted to String
        cell.labelSubscribed.text = "\(eventsList[indexPath.row].nb_part_sub)"
        cell.labelPart_max.text = "\(eventsList[indexPath.row].nb_part_max)"
        cell.labelPrice_max.text = "\(eventsList[indexPath.row].price_per_part)"
        
        // Last Step : Image download through AlamofireImage
        if let organizerID = eventsList[indexPath.row].organizer_id as? String {
            
            // Building the URL
            let firstPartURL = "http://83.217.132.102:3000/"
            var organizer_profile_picture = organizerID.replacingOccurrences(of: "_O_", with: "_OPP_")
            organizer_profile_picture = organizer_profile_picture + ".jpg"
            let imageURL = firstPartURL + organizer_profile_picture
            print(imageURL)
            
            //AlamofireImage request
            Alamofire.request(imageURL).responseImage(completionHandler: {response in
                if let image = response.result.value {
                    DispatchQueue.main.async {
                        cell.UIImage_OPP?.image = image
                    }
                }
            })
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail: EventDescriptionController
        detail = self.storyboard?.instantiateViewController(withIdentifier: "EventDescriptionController") as! EventDescriptionController
        self.navigationController?.pushViewController(detail, animated: true)
        
        detail.LocationData = eventsList[indexPath.row].location
        detail.LatitudeData = eventsList[indexPath.row].latitude
        detail.LongitudeData = eventsList[indexPath.row].longitude
        
    }
    
    
}










// ================= CELL CONFIGURATION ================================
class eventUICell: UITableViewCell {
    
    @IBOutlet weak var labelEvent_id: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var labelSport: UILabel!
    @IBOutlet weak var labelSubscribed: UILabel!
    @IBOutlet weak var labelPart_max: UILabel!
    @IBOutlet weak var labelPrice_max: UILabel!
    @IBOutlet weak var UIImage_OPP: UIImageView!
    @IBOutlet weak var labelFirstName: UILabel!
    @IBOutlet weak var labelLatitude: UILabel!
    @IBOutlet weak var labelLongitude: UILabel!
    
}









// =========================== eventClass configuration ==============
public class eventClass {
    let event_id: String
    let date: String
    let location: String
    let sport: String
    let nb_part_sub : Int
    let nb_part_max : Int
    let price_per_part : Int
    let organizer_id : String
    let first_name : String
    let latitude: String?
    let longitude: String?
    
    
    init(data: [String:Any]) {
        self.event_id = data["event_id"] as! String
        self.date = data["date"] as! String
        self.location = data["location"] as! String
        self.sport = data["sport"] as! String
        self.nb_part_sub = data["nb_part_sub"] as! Int
        self.nb_part_max = data["nb_part_max"] as! Int
        self.price_per_part = data["price_per_part"] as! Int
        self.organizer_id = data["organizer_id"] as! String
        self.first_name = data["first_name"] as! String
        self.latitude = data["latitude"] as? String
        self.longitude = data["longitude"] as? String
        
    }
    
}






