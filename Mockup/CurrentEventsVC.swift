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
import UserNotifications

class CurrentEventsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UNUserNotificationCenterDelegate {
    
    @IBOutlet weak var ProfileButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
        // ============================== VARIABLES ===============================
    // When data is received, it's filled in eventsList
    var eventsList: [eventClass] = []
    let refreshControl = UIRefreshControl()
    
    // Loading of the ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self

        ProfileButton.titleLabel!.text = ""
        ProfileButton.frame = CGRect(x: 8.00, y: 82.00, width: 40.00, height: 40.00)
        if let imageB  = UIImage(named: "coach profile picture") {
            ProfileButton.setBackgroundImage(imageB, for: .normal)
            
        }
        ProfileButton.addTarget(self, action: #selector(self.buttonClicked), for: UIControl.Event.touchUpInside)
        
        
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
        
        UNUserNotificationCenter.current().delegate = self
        
        
    } // End of ViewDidLoad
    
    
// ============================== TABLE FUNCTIONS ============================
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return UITableView.automaticDimension
        return 100
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    // Count received events in eventsList

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsList.count
    }
    
    // Populate data in cells
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! eventUICell
        cell.labelDate.text =  formatDate(strDate: eventsList[indexPath.row].date)
        cell.labelLocation.text = eventsList[indexPath.row].location
        cell.labelSport.text = eventsList[indexPath.row].sport
        cell.labelFirstName.text = eventsList[indexPath.row].first_name

        // Not string data converted to String
        cell.labelSubscribed.text = "\(eventsList[indexPath.row].nb_part_sub)"
        cell.labelPart_max.text = "\(eventsList[indexPath.row].nb_part_max)"
        cell.labelPrice.text = "\(eventsList[indexPath.row].price_per_part)"
        
        cell.UIImage_Sport.image = UIImage(named: sportLabelConverter(strSport: eventsList[indexPath.row].sport)) // We use helper sportLabelConverter to convert the name
        
        let intPartMax = Float(eventsList[indexPath.row].nb_part_max)
        let intSub = Float(eventsList[indexPath.row].nb_part_sub)
        
        cell.ParticipationProgressBar.progress = intSub/intPartMax
        
        //cell.organizer_ratingStars.rating = Double(eventsList[indexPath.row].organizer_rating!)
        
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
       
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "EventDetailsVC") as! EventDetailsVC
        
        newViewController.eventBaseInfo = copyEventData(selectedEvent: eventsList[indexPath.row])
        newViewController.LocationData = eventsList[indexPath.row].location
        newViewController.LatitudeData = eventsList[indexPath.row].latitude!
        newViewController.LongitudeData = eventsList[indexPath.row].longitude!
        
        self.present(newViewController,animated: true,completion: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: true)
        }
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
            
            let impact = UIImpactFeedbackGenerator(style: UIImpactFeedbackGenerator.FeedbackStyle.light)
            return
            
        }
        
        
    }
    
}

// ======================= CELL CONFIGURATION ================================

class eventUICell: UITableViewCell {
    
    //@IBOutlet weak var labelEvent_id: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var labelSport: UILabel!
    @IBOutlet weak var labelSubscribed: UILabel!
    @IBOutlet weak var labelPart_max: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var UIImage_OPP: UIImageView!
    @IBOutlet weak var UIImage_Sport: UIImageView!
    @IBOutlet weak var labelFirstName: UILabel!
    @IBOutlet weak var ParticipationProgressBar: UIProgressView!
    @IBOutlet weak var organizer_ratingStars: CosmosView!
    
    
    //@IBOutlet weak var labelLatitude: UILabel!
    //@IBOutlet weak var labelLongitude: UILabel!
    
}

// =========================== eventClass configuration ==============

public class eventClass {
    let event_id : String
    let date : String
    let location : String
    let sport : String
    let nb_part_sub : Int
    let nb_part_max : Int
    let price_per_part : Int
    let organizer_id : String
    let first_name : String
    let latitude : String?
    let longitude : String?
    let organizer_rating : Int?
    
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
        self.organizer_rating = data["organizer_rating"] as? Int
        
    }
    
}


// ========================== HELPERS ==================================

func sportLabelConverter(strSport: String) -> String {
// This function collect the name of the sport and convert it to a name of the image stored in the application
// Ex : Cross-Fit --> crossfit
    
    //We delete the cap : 
    let low = strSport.lowercased()
    return low
   
}

func formatDate(strDate: String) -> String {
    // Objective : return a string type "Mardi 25 Janvier 2019 17:00"
    
    //MySQL format to acceptable format
    print("STR DATE IS ",strDate)
    let dteFormatter = DateFormatter()
    dteFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    let cleanedDate = dteFormatter.date(from: strDate)
    
    let frenchDateFormatter = DateFormatter()
    frenchDateFormatter.dateStyle = .long
    frenchDateFormatter.timeStyle = .short
    frenchDateFormatter.locale = Locale(identifier: "fr_FR")
    let strDate = frenchDateFormatter.string(from: cleanedDate!)
    
    return strDate
    
}


func copyEventData(selectedEvent: eventClass) -> [String:Any] {
    
    var dataDict: [String:Any] = [:]
    
     dataDict["event_id"] = selectedEvent.event_id
     dataDict["date"] = selectedEvent.date
     dataDict["location"] = selectedEvent.location
     dataDict["sport"] = selectedEvent.sport
     dataDict["nb_part_sub"] = selectedEvent.nb_part_sub
     dataDict["nb_part_max"] = selectedEvent.nb_part_max
     dataDict["price_per_part"] = selectedEvent.price_per_part
     dataDict["organizer_id"] = selectedEvent.organizer_id
     dataDict["first_name"] = selectedEvent.first_name
     dataDict["latitude"] = selectedEvent.latitude
     dataDict["longitude"] = selectedEvent.longitude
    
    return dataDict

}

// ========================= EXTENSIONS ================================

extension CurrentEventsVC {
    
    @objc func buttonClicked() {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "ProfileVC")
        self.present(newViewController,animated: true,completion: nil)
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //displaying the ios local notification when app is in foreground
        completionHandler([.alert, .badge, .sound])
    }

}

