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
    var first = true
    var distance = 0
    
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
            /*let span = MKCoordinateSpanMake(0.015, 0.015)
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: manager.location!.coordinate.latitude, longitude: manager.location!.coordinate.longitude), span: span)
            mapa.setRegion(region, animated: true)
                currentLocation = CLLocation.init(latitude: manager.location!.coordinate.latitude, longitude: manager.location!.coordinate.longitude)
                let pin = MKPointAnnotation()
                pin.coordinate.latitude = currentLocation.coordinate.latitude
                pin.coordinate.longitude = currentLocation.coordinate.longitude
                pin.title = "Long: \(currentLocation.coordinate.longitude), Lat: \(currentLocation.coordinate.latitude)"
                pin.subtitle = "Ditancia recorrida: \(distance*50)"
                mapa.addAnnotation(pin)*/
        }
        else{
            manejador.stopUpdatingLocation()
            mapa.showsUserLocation = false
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let span = MKCoordinateSpanMake(0.015, 0.015)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: manager.location!.coordinate.latitude, longitude: manager.location!.coordinate.longitude), span: span)
        if(first || abs(manager.location!.distanceFromLocation(currentLocation)) > 50){
            mapa.setRegion(region, animated: true)
            first = false;
            distance += 1
            currentLocation = CLLocation.init(latitude: manager.location!.coordinate.latitude, longitude: manager.location!.coordinate.longitude)
            let pin = MKPointAnnotation()
            pin.coordinate.latitude = currentLocation.coordinate.latitude
            pin.coordinate.longitude = currentLocation.coordinate.longitude
            pin.title = "Long: \(currentLocation.coordinate.longitude), Lat: \(currentLocation.coordinate.latitude)"
            pin.subtitle = "Ditancia recorrida: \(distance*50)"
            mapa.addAnnotation(pin)
        }
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Me salí del mapa")
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

