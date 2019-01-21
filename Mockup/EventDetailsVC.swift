//
//  EventDescriptionVC.swift
//  Mockup
//
//  Created by Quentin Duquesne on 18/12/2018.
//  Copyright © 2018 Quentin Duquesne. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import Alamofire
import ARSLineProgress
import CoreLocation

class EventDetailsVC: UIViewController {

    @IBOutlet weak var DescriptionMap: MKMapView!
    @IBOutlet weak var LocationLabel: UILabel!
    @IBOutlet weak var EventDescription: UILabel!
    
    let locationManager = CLLocationManager()
    var currentCoordinate: CLLocationCoordinate2D?
    let regionInMeters: Double = 10000
    var LocationData: String?
    var LatitudeData: String?
    var LongitudeData: String?
    var eventLocation: CLLocationCoordinate2D?
    var eventBaseInfo: [String:Any] = [:] // Populated on segue

 override func viewDidLoad() {
    super.viewDidLoad()

    let eventLocation = CLLocationCoordinate2D(latitude: Double(LatitudeData!)!, longitude: Double(LongitudeData!)!)

    checkLocationServices()

    // Artwork
    let artwork = Artwork(title: eventBaseInfo["sport"] as! String,
                          locationName: "Location of the event",
                          discipline: "Sculpture",
                          coordinate: eventLocation)
    DescriptionMap.addAnnotation(artwork)
    
    print(eventBaseInfo)
    
} // end of view load
    
// MARK: - IBAction
    
    @IBAction func Action_CloseVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func BookEvent_Action(_ sender: Any) {
        
        let data: [String:Any] = [
            "event_id" : eventBaseInfo["event_id"]!,
            "user_id" : UserDefaults.standard.string(forKey: "userID")!
        ]
        
        isBooked(eventData: data) { rawRes in
            if rawRes == true {
                ARSLineProgress.showSuccess()
            } else {
                ARSLineProgress.showFail()
            }
            
        } // is booked
        
    } // action book
    
// MARK: - Location functions

    func setupLocationManager() {
    
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    
    func centerViewOnUserLocation() {
        
       if let location = locationManager.location?.coordinate {
        let region = MKCoordinateRegion(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            DescriptionMap.setRegion(region, animated: true)
        }
        
    }
    
    
    func checkLocationServices() {
    
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn this on.
        }
    }
    
    
    func checkLocationAuthorization() {
    
        switch CLLocationManager.authorizationStatus() {
        
        case .authorizedWhenInUse:
            DescriptionMap.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
            
        case .denied:
            // Show alert instructing them how to turn on permissions
            break
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            
        case .restricted:
            // Show an alert letting them know what's up
            break
            
        case .authorizedAlways:
            break
        }
    }


} // end of EventDescriptionVC class


extension EventDetailsVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        /*guard let location = locations.last else { return }
        let region = MKCoordinateRegionMakeWithDistance(location.coordinate, regionInMeters, regionInMeters)
        DescriptionMap.setRegion(region, animated: true) */
        
        let eventLocation = CLLocationCoordinate2D(latitude: Double(LatitudeData!)!, longitude: Double(LongitudeData!)!)
        let region = MKCoordinateRegion(center: eventLocation, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        DescriptionMap.setRegion(region, animated: true)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    
        checkLocationAuthorization()
    }
    
} // end of Extension

// MARK: - NETWORK HELPERS

func isBooked(eventData: [String:Any?], completion: @escaping (Bool) -> ()) {
    // This function ask for a booking of the information in the event_data and return a bool indicating completion
    
    let SFTokenHandler = StreetFitTokenHandler()
    let sessionManager = SFTokenHandler.sessionManager
    sessionManager.adapter = SFTokenHandler
    sessionManager.retrier = SFTokenHandler
    let urlString = "http://83.217.132.102:3000/auth/bookings/book"
    
    let headers: HTTPHeaders = [
        "Content-Type" : "application/json; charset=UTF-8"
    ]
    
    sessionManager.request(urlString, method: .post, parameters: eventData, encoding: JSONEncoding.default, headers: headers)
        .validate()
        .responseJSON { response in
            
            print(response)
            
            switch response.result {
                
            case .success: //Ne presume pas un succes, simplement une reponse du server
                
                // Protections
                guard response.result.isSuccess else {return completion(false)}
                guard let rawInventory = response.result.value as? [String:Any]? else {return completion(false)}
                
                // Verification error
                switch rawInventory!["success"] as! Int {

                case 0:
                    if rawInventory!["error"] as! Int == 1 {
                             //Error confirmed 
                            switch rawInventory!["error_description"] as! String {

                            case "event already full":
                            print("full")
                            completion(false)

                            default:
                            print("df")
                            completion(false)
                            }
                    }

                case 1:
                    completion(true)
                default:
                    print("df")
                    completion(false)

                }
                
            case .failure(let error):
                print(error)
                
            }
            
    }
    
}
