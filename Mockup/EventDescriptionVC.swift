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

class EventDescriptionVC: UIViewController {

    @IBOutlet weak var DescriptionMap: MKMapView!
    
    let locationManager = CLLocationManager()
    var currentCoordinate: CLLocationCoordinate2D?
    let regionInMeters: Double = 10000
    
    // Populated on segue
    var LocationData: String?
    var LatitudeData: String?
    var LongitudeData: String?
    var eventLocation: CLLocationCoordinate2D?
    
    @IBOutlet weak var LocationLabel: UILabel!
    @IBOutlet weak var LatitudeLabel: UILabel!
    @IBOutlet weak var LongitudeLabel: UILabel!
    
 override func viewDidLoad() {
    super.viewDidLoad()
    
    LocationLabel.text = LocationData
    LatitudeLabel.text = LatitudeData
    LongitudeLabel.text = LongitudeData

    let eventLocation = CLLocationCoordinate2D(latitude: Double(LatitudeData!)!, longitude: Double(LongitudeData!)!)

    checkLocationServices()

    // Artwork
    let artwork = Artwork(title: "MyEvent",
                          locationName: "Location of the event",
                          discipline: "Sculpture",
                          coordinate: eventLocation)
    DescriptionMap.addAnnotation(artwork)
    
}

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


extension EventDescriptionVC: CLLocationManagerDelegate {
    
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
