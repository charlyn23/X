//
//  ViewController.swift
//  X
//
//  Created by Charlyn Buchanan on 3/16/15.
//  Copyright (c) 2015 Charlyn Buchanan. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIAlertViewDelegate {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        mapView = MKMapView()
    }


    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    var placemark = CLPlacemark()
    var dropPin = MKPointAnnotation()
    var shameCoordinates: [Float]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.mapType = .Standard
        mapView.frame = view.frame
        self.mapView.showsUserLocation = true
        view.addSubview(mapView)

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        var newShame = MKPointAnnotation()
        println(returnPath())

        
    }
    
    //Zoom in on user location
    func mapView(mapView: MKMapView!,
        didUpdateUserLocation userLocation: MKUserLocation!) {
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            
            var newRegion = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: span)
            mapView.setRegion(newRegion, animated: true)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBOutlet var longTap: UILongPressGestureRecognizer!
    
    //Switch for location manager status options
    func locationManager(manager: CLLocationManager!,
        didChangeAuthorizationStatus status: CLAuthorizationStatus){
            println(status)
            switch status {
            case .AuthorizedWhenInUse:
                println("authorized when in use")
            case .Denied:
                println("Denied")
            case .Restricted:
                println("restricted")
            case .NotDetermined:
                println("not determined")
            case .Authorized:
                println("authorized")
            default:
                println("default")
            }
            
            var longTap: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "didLongTapMap:")
           // longTap.delegate = self
            longTap.numberOfTapsRequired = 0
            longTap.minimumPressDuration = 0.5
            mapView.addGestureRecognizer(longTap)
        }
    //Dropping a pin
    func didLongTapMap(gestureRecognizer: UIGestureRecognizer) {
        // Get the spot that was tapped.
        let tapPoint: CGPoint = gestureRecognizer.locationInView(mapView)
        let touchMapCoordinate: CLLocationCoordinate2D = mapView.convertPoint(tapPoint, toCoordinateFromView: mapView)
        println("pressed")
        println(touchMapCoordinate)
        
        var newShame = MKPointAnnotation()
        newShame.coordinate = touchMapCoordinate
        
        mapView.addAnnotation(newShame)
        mapView.selectAnnotation(newShame, animated: true)

}
    //Persist stuff
    func returnPath() -> NSURL {
        var directoryPath = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0] as NSURL
        return directoryPath.URLByAppendingPathComponent("ShamesLogged.plist")
        
    }
    let filename = "ShamesLogged.plist"
    var filePath = NSBundle.mainBundle().pathForResource("ShamesLogged", ofType: "plist")
    let cocoaArray: NSArray = shameCoordinates[]
    
    func storeShames() {
        cocoaArray.writeToFile("///Users/charlynbuchanan/Library/Developer/CoreSimulator/Devices/624E3D48-A44B-46AC-BE0B-9125C4FBBE72/data/Containers/Data/Application/F1BBDDFE-6518-4328-A5C9-5C7FFA0F9519/Documents/ShamesLogged.plist", atomically: true)
    }
}