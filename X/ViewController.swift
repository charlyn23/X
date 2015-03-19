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
    var tapPoint: [CLLocation] = []

    
    
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
       // println(returnPath())
       // var touchMapCoordinate
        //self.shameCoordinates()[touchMapCoordinate]
       // let shameCoordinates = NSArray(contentsOfFile: fileUrlString)
        
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
        
        var newShame = MKPointAnnotation()
        var animatesDrop = true
        
        mapView.addAnnotation(newShame)
        mapView.selectAnnotation(newShame, animated: true)
        newShame.coordinate = touchMapCoordinate
        var shameLat = newShame.coordinate.latitude
        var shameLong = newShame.coordinate.longitude
        var shameCoordinate = (shameLat, shameLong)
        println(newShame.coordinate.latitude)
        println(newShame.coordinate.longitude)
        
    
    let submitAlertController = UIAlertController(title: "New Shame", message: "Would you like to submit this shame?", preferredStyle: .Alert)
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
        // delete pin
    }
    submitAlertController.addAction(cancelAction)
    
    let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
        // store coordinates to plist
        self.shameCoordinates.append(CLLocation(latitude: shameLat, longitude: shameLong))
       //d self.returnPath()
        
    }
    submitAlertController.addAction(OKAction)
    
    self.presentViewController(submitAlertController, animated: true) {
    // ...
    }
    }


    //Persist stuff
    func returnPath() -> NSURL {
        var directoryPath = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0] as NSURL
        return directoryPath.URLByAppendingPathComponent("ShamesLogged.plist")
        
    }
    
    var shameCoordinates: [CLLocation] = [shame Lat, shame Long] {
        didSet {
            var url = returnPath()
            var atomic = true
//            if let shameCoordinates = self.shameCoordinates
                let result = (shameCoordinates as NSArray).writeToURL(url, atomically: atomic)
                println(result)
//            }
        }
    }
    let filename = "ShamesLogged.plist"
    var UserDomaimnask = NSSearchPathDomainMask()
//    var filePath: String {
//        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, UserDomainmask, true)[0] as String
//        return documentsDirectory.stringByAppendingPathComponent(filename)
//    }

    
//    func storeShames() {
//        cocoaArray.writeToFile("///Users/charlynbuchanan/Library/Developer/CoreSimulator/Devices/624E3D48-A44B-46AC-BE0B-9125C4FBBE72/data/Containers/Data/Application/F1BBDDFE-6518-4328-A5C9-5C7FFA0F9519/Documents/ShamesLogged.plist", atomically: true)
//    }

}

