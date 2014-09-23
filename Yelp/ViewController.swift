//
//  ViewController.swift
//  Yelp
//
//  Created by Jerry Su on 9/19/14.
//  Copyright (c) 2014 Jerry Su. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UITableViewController, UISearchBarDelegate, FiltersViewControllerDelegate, CLLocationManagerDelegate {

    var searchBar: UISearchBar?

    var client: YelpClient!

    let yelpConsumerKey = "C6uWCSlZN-pt1qMSzQyeAQ"
    let yelpConsumerSecret = "mCV_4NS3bvZjxCSNvA8e_1djmtE"
    let yelpToken = "IFT9QzRtzVcfH0O6LR7TK5hwtDKKdZBc"
    let yelpTokenSecret = "_7yceRZuAeaIDuJnHRo7gWfWRFc"

    var term: String = ""
    let limit: Int = 20
    var offset: Int = 0

    var businesses: Array<YelpBusiness> = []
    var latitude: Double = 37.7710347
    var longitude: Double = -122.4040795

    let locationManager: CLLocationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.client = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)

        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 116
        self.tableView.addInfiniteScrollingWithActionHandler({
            self.performSearch(self.term, offset: self.offset, limit: self.limit)
        })
        self.tableView.showsInfiniteScrolling = false

        self.searchBar = UISearchBar()
        self.searchBar!.delegate = self
        self.searchBar!.placeholder = "Search"
        self.navigationItem.titleView = self.searchBar

        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.term = searchBar.text
        self.businesses = []
        self.offset = 0
        self.tableView.reloadData();
        self.tableView.showsInfiniteScrolling = true
        self.tableView.triggerInfiniteScrolling()
    }

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.term = ""
            self.businesses = []
            self.offset = 0
            self.tableView.reloadData()
            self.tableView.showsInfiniteScrolling = false
        }
    }

    func performSearch(term: String, offset: Int = 0, limit: Int = 20) {
        var parameters = YelpFilters.instance.getParameters()
        self.client.searchWithTerm(term, parameters: parameters, offset: offset, limit: 20, success: {
            (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let businesses = (response["businesses"] as Array).map({
                (business: NSDictionary) -> YelpBusiness in
                return YelpBusiness(dictionary: business)
            })
            self.businesses += businesses
            self.offset = self.businesses.count
            self.tableView.infiniteScrollingView?.stopAnimating()
            self.tableView.showsInfiniteScrolling = self.businesses.count < (response["total"] as Int)
            self.tableView.reloadData()
        }, failure: {
            (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            println(error)
        })
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessTableViewCell") as BusinessTableViewCell

        let business = businesses[indexPath.row]

        if (business.imageURL? != nil) {
            cell.previewImage.setImageWithURL(business.imageURL)
        }

        cell.previewImage.layer.cornerRadius = 9.0
        cell.previewImage.layer.masksToBounds = true

        cell.nameLabel.text = "\(indexPath.row + 1). \(business.name)"
        cell.ratingImage.setImageWithURL(business.ratingImageURL)

        let reviewCount = business.reviewCount
        if (reviewCount == 1) {
            cell.reviewLabel.text = "\(reviewCount) review"
        } else {
            cell.reviewLabel.text = "\(reviewCount) reviews"
        }

        cell.addressLabel.text = business.displayAddress
        cell.categoriesLabel.text = business.displayCategories

        let dlat = (self.latitude - business.latitude!) * M_PI / 180
        let dlon = (self.longitude - business.longitude!) * M_PI / 180
        let a = pow(sin(dlat / 2), 2) + cos(Double(business.latitude!) * M_PI / 180) * cos(Double(self.latitude) * M_PI / 180) * pow(sin(dlon / 2), 2)
        let c = 2 * atan2(sqrt(a), sqrt(1-a))
        cell.distanceLabel.text = String(format: "%.1f mi", 3963.1 * c)
        cell.distanceLabel.sizeToFit()

        cell.dealsImage.hidden = business.deals == nil

        cell.layoutIfNeeded()

        return cell
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses.count
    }

    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.layoutMargins = UIEdgeInsetsZero
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destinationViewController is UINavigationController {
            let navigationController = segue.destinationViewController as UINavigationController
            if navigationController.viewControllers[0] is FiltersViewController {
                let controller = navigationController.viewControllers[0] as FiltersViewController
                controller.delegate = self
            }
        }
    }

    func onFiltersDone(controller: FiltersViewController) {
        if self.term != "" {
            self.businesses = []
            self.offset = 0
            self.tableView.reloadData();
            self.tableView.showsInfiniteScrolling = true
            self.tableView.triggerInfiniteScrolling()
        }
    }

    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("error = \(error)")
    }

    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {
            (placemarks, error) ->Void in

            if error != nil {
                println("error = \(error)")
                return
            }

            if placemarks.count > 0 {
                let placemark = placemarks[0] as CLPlacemark
                println(placemark.locality)
            }
        })

        let location = locations.last as CLLocation
        if location.horizontalAccuracy > 0 {
            self.locationManager.stopUpdatingLocation()
            self.latitude = location.coordinate.latitude
            self.longitude = location.coordinate.longitude
        }
    }
}

