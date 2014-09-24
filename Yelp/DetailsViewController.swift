//
//  DetailsViewController.swift
//  Yelp
//
//  Created by Jerry Su on 9/23/14.
//  Copyright (c) 2014 Jerry Su. All rights reserved.
//

import Foundation
import MapKit

class DetailsViewController: UIViewController, MKMapViewDelegate {

    var business: YelpBusiness!

    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var ratingImage: UIImageView!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var dealsImage: UIImageView!
    @IBOutlet weak var mapView: MKMapView!

    var userLocation: UserLocation = UserLocation()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = business.name

        if (self.business.imageURL? != nil) {
            self.previewImage.setImageWithURL(self.business.imageURL)
        }

        self.previewImage.layer.cornerRadius = 9.0
        self.previewImage.layer.masksToBounds = true

        self.ratingImage.setImageWithURL(self.business.ratingImageURL)

        let reviewCount = self.business.reviewCount
        if (reviewCount == 1) {
            self.reviewLabel.text = "\(reviewCount) review"
        } else {
            self.reviewLabel.text = "\(reviewCount) reviews"
        }

        self.addressLabel.text = self.business.displayAddress
        self.categoriesLabel.text = self.business.displayCategories

        let distance = self.business.location.distanceFromLocation(self.userLocation.location)
        self.distanceLabel.text = String(format: "%.1f mi", distance / 1609.344)
        self.distanceLabel.sizeToFit()

        self.dealsImage.hidden = self.business.deals == nil

        self.mapView.delegate = self
        let annotation = MKPointAnnotation()
        let coordinate = CLLocationCoordinate2D(latitude: self.business.latitude!, longitude: self.business.longitude!)
        annotation.setCoordinate(coordinate)
        self.mapView.addAnnotation(annotation)
        self.mapView.setRegion(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpanMake(0.01, 0.01)), animated: false)
        self.mapView.layer.cornerRadius = 9.0
        self.mapView.layer.masksToBounds = true
    }

    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if !(annotation is MKPointAnnotation) {
            return nil
        }

        var view = mapView.dequeueReusableAnnotationViewWithIdentifier("pin") as? MKPinAnnotationView
        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            view!.canShowCallout = false
        }
        return view
    }
}