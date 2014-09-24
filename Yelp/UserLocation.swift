//
//  UserLocation.swift
//  Yelp
//
//  Created by Jerry Su on 9/22/14.
//  Copyright (c) 2014 Jerry Su. All rights reserved.
//

import CoreLocation

class UserLocation: NSObject, CLLocationManagerDelegate {

    internal class UserLocationManager: NSObject, CLLocationManagerDelegate {

        var locationManager: CLLocationManager = CLLocationManager()

        var latitude: Double!
        var longitude: Double!

        private var requested: Bool = false

        func requestLocation() {
            if self.requested {
                return
            }
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
            self.requested = true
        }

        func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
            println("error = \(error)")
        }

        func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
            let location = locations.last as CLLocation
            if location.horizontalAccuracy > 0 {
                self.latitude = location.coordinate.latitude
                self.longitude = location.coordinate.longitude

                let nc = NSNotificationCenter.defaultCenter()
                nc.postNotificationName("UserLocation/updated", object: nil)

                self.locationManager.stopUpdatingLocation()
                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(60.0 * Double(NSEC_PER_SEC)))
                dispatch_after(time, dispatch_get_main_queue(), {
                    self.locationManager.startUpdatingLocation()
                })
            }
        }

        class var instance: UserLocationManager {
            struct Static {
                static let instance: UserLocationManager = UserLocationManager()
            }
            return Static.instance
        }

    }

    var manager: UserLocationManager!

    override init() {
        manager = UserLocationManager.instance
    }

    func requestLocation() {
        manager.requestLocation()
    }

    var latitude: Double {
        get {
            return manager.latitude ?? 37.7710347
        }
    }

    var longitude: Double {
        get {
            return manager.longitude ?? -122.4040795
        }
    }

    var location: CLLocation {
        get {
            return CLLocation(latitude: self.latitude, longitude: self.longitude)
        }
    }

}