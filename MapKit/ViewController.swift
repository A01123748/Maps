//
//  ViewController.swift
//  MapKit
//
//  Created by Eliseo Fuentes on 9/14/16.
//  Copyright © 2016 Eliseo Fuentes. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, UIPopoverPresentationControllerDelegate{
    
    @IBOutlet weak var mapa: MKMapView!
    private let manejador = CLLocationManager()
    var currentLocation = CLLocation()
    var distance = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        manejador.delegate = self
        manejador.desiredAccuracy = kCLLocationAccuracyBest
        manejador.requestWhenInUseAuthorization()
    }

    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse{
            manejador.startUpdatingLocation()
            mapa.showsUserLocation = true
            if(manager.location != nil){
                insertPin(manager.location!.coordinate.latitude, longitude: manager.location!.coordinate.longitude,isUpdate: false, measuredDistance: 0)
            }
        }
        else{
            manejador.stopUpdatingLocation()
            mapa.showsUserLocation = false
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let measuredDistance = abs(manager.location!.distanceFromLocation(currentLocation))
        if(measuredDistance > 50){
            insertPin(manager.location!.coordinate.latitude, longitude: manager.location!.coordinate.longitude,isUpdate: true, measuredDistance: measuredDistance)
        }
    }
    
    func insertPin( latitude: CLLocationDegrees, longitude: CLLocationDegrees,isUpdate:Bool, measuredDistance:Double){
        let span = MKCoordinateSpanMake(0.015, 0.015)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: span)
        mapa.setRegion(region, animated: true)
        currentLocation = CLLocation.init(latitude: latitude, longitude: longitude)
        let pin = MKPointAnnotation()
        pin.coordinate.latitude = latitude
        pin.coordinate.longitude = longitude
        let latP = String(format: "%.3f", latitude)
        let longP = String(format: "%.3f", longitude)
        
        pin.title = "Long: \(longP)º, Lat: \(latP)º"
        if(isUpdate){
            distance+=measuredDistance
        }
        let distanceP = String(format: "%.3f", distance)
        pin.subtitle = "Ditancia recorrida: \(distanceP)m"
        mapa.addAnnotation(pin)
    }
    
    @IBAction func changeMapType(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex
        {
        case 0:
            mapa.mapType = MKMapType.Standard
            break;
        case 1:
            mapa.mapType = MKMapType.Hybrid
            break;
        case 2:
            mapa.mapType = MKMapType.Satellite
            break;
        default:
            break;
        }
    }
    
}

