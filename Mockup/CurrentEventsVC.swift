//
//  CurrentEventsVC.swift
//  Mockup
//
//  Created by Quentin Duquesne on 15/12/2018.
//  Copyright © 2018 Quentin Duquesne. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

class CurrentEventsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // ============================== VARIABLES ===============================
    @IBOutlet weak var tableView: UITableView!
    
    // When data is received, it's filled in eventsList
    var eventsList: [eventClass] = []
    let refreshControl = UIRefreshControl()
    
    // Loading of the ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self

        
        let SFTokenHandler = StreetFitTokenHandler()
        let sessionManager = SFTokenHandler.sessionManager
        sessionManager.adapter = SFTokenHandler
        sessionManager.retrier = SFTokenHandler
        let urlString = "http://83.217.132.102:3000/auth/experlogin/innerjoin"
        populateEventsList(targetURL: urlString, theSessionManager: sessionManager) { eventsList in
            guard eventsList != nil else {return}
            self.eventsList = eventsList!
            self.tableView.reloadData()
            
        }
        
        
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing...")
        refreshControl.addTarget(self, action: #selector(refreshTableEvents), for: UIControl.Event.valueChanged)
        
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl = refreshControl
        } else {
            self.tableView.addSubview(refreshControl)
        }
        
        
        
        
    } // End of ViewDidLoad
    
    
// ============================== TABLE FUNCTIONS ============================
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return UITableView.automaticDimension
        return 115
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
    
    
    // Count received events in eventsList

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsList.count
    }
    
    // Populate data in cells
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! eventUICell
        //cell.labelEvent_id.text = eventsList[indexPath.row].event_id
        //cell.labelDate.text = eventsList[indexPath.row].date
        cell.labelLocation.text = eventsList[indexPath.row].location
        cell.labelSport.text = eventsList[indexPath.row].sport
        cell.labelFirstName.text = eventsList[indexPath.row].first_name
        //cell.labelLatitude.text = eventsList[indexPath.row].latitude
        //cell.labelLongitude.text = eventsList[indexPath.row].longitude
        
        // Not string data converted to String
        cell.labelSubscribed.text = "\(eventsList[indexPath.row].nb_part_sub)"
        cell.labelPart_max.text = "\(eventsList[indexPath.row].nb_part_max)"
        cell.labelPrice.text = "\(eventsList[indexPath.row].price_per_part)"
        
        cell.UIImage_Sport.image = UIImage(named: eventsList[indexPath.row].sport)
        
        var intPartMax = Float(eventsList[indexPath.row].nb_part_max)
        var intSub = Float(eventsList[indexPath.row].nb_part_sub)
        
        cell.ParticipationProgressBar.progress = intSub/intPartMax
        
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
    
    // Define the number of sections - normally its 1
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Evenement en cas de selection d'une ligne
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail: EventViewVC
        detail = self.storyboard?.instantiateViewController(withIdentifier: "EventViewVC") as! EventViewVC
        self.navigationController?.pushViewController(detail, animated: true)
        
        detail.LocationData = eventsList[indexPath.row].location
        detail.LatitudeData = eventsList[indexPath.row].latitude!
        detail.LongitudeData = eventsList[indexPath.row].longitude!
        
    }
    
    
} // Fin de la class CurrentEventsVC

extension CurrentEventsVC {
    
    @objc func refreshTableEvents() {
        
        let SFTokenHandler = StreetFitTokenHandler()
        let sessionManager = SFTokenHandler.sessionManager
        sessionManager.adapter = SFTokenHandler
        sessionManager.retrier = SFTokenHandler
        let urlString = "http://83.217.132.102:3000/auth/experlogin/innerjoin"
        
        populateEventsList(targetURL: urlString, theSessionManager: sessionManager) { eventsList in
            guard eventsList != nil else {return}
            self.eventsList = eventsList!
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            return
            
        }
        
        
    }
    
}

// ======================= CELL CONFIGURATION ================================

class eventUICell: UITableViewCell {
    
    //@IBOutlet weak var labelEvent_id: UILabel!
    //@IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var labelSport: UILabel!
    @IBOutlet weak var labelSubscribed: UILabel!
    @IBOutlet weak var labelPart_max: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var UIImage_OPP: UIImageView!
    @IBOutlet weak var UIImage_Sport: UIImageView!
    @IBOutlet weak var labelFirstName: UILabel!
    
    @IBOutlet weak var ParticipationProgressBar: UIProgressView!
    
    //@IBOutlet weak var labelLatitude: UILabel!
    //@IBOutlet weak var labelLongitude: UILabel!
    
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
    
    // Initialisation de la classe
    
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






