//
//  ListViewController.swift
//  Yelp
//
//  Created by Jerry Su on 9/22/14.
//  Copyright (c) 2014 Jerry Su. All rights reserved.
//

import UIKit
import CoreLocation

class ListViewController: SearchViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!

    var loadingIndicator: LoadingIndicator!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 116
        self.tableView.addInfiniteScrollingWithActionHandler({
            self.performSearch(self.searchBar.text, offset: self.offset, limit: self.limit)
        })
        self.tableView.showsInfiniteScrolling = false
        self.tableView.reloadData()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("onUserLocation"), name: "UserLocation/updated", object: nil)
        self.userLocation.requestLocation()

        let loadingIndicator = (NSBundle.mainBundle().loadNibNamed("LoadingIndicator", owner: self, options: nil)[0] as LoadingIndicator)
        self.loadingIndicator = loadingIndicator
        self.tableView.tableFooterView = loadingIndicator
    }

    func onUserLocation() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "UserLocation/updated", object: nil)
        if self.searchBar.text == "" {
            self.performSearch("Restaurants")
        }
    }

    override func onBeforeSearch() {
        self.loadingIndicator.animate()
    }

    override func onResults(results: Array<YelpBusiness>, total: Int, response: NSDictionary) {
        self.tableView.infiniteScrollingView.stopAnimating()
        self.tableView.showsInfiniteScrolling = results.count < total
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.tableView.reloadData()
    }

    override func onResultsCleared() {
        self.loadingIndicator.stopAnimating()
        self.tableView.tableFooterView = self.loadingIndicator
        self.tableView.showsInfiniteScrolling = false
        self.tableView.reloadData()
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessTableViewCell") as BusinessTableViewCell

        let business = self.results[indexPath.row]

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

        cell.addressLabel.text = business.shortAddress
        cell.categoriesLabel.text = business.displayCategories

        let distance = business.location.distanceFromLocation(self.userLocation.location)
        cell.distanceLabel.text = String(format: "%.1f mi", distance / 1609.344)
        cell.distanceLabel.sizeToFit()
        
        cell.dealsImage.hidden = business.deals == nil
        
        cell.layoutIfNeeded()
        
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.results.count
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let result = self.results[indexPath.row]
        self.showDetailsForResult(result)
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)

        if segue.destinationViewController is UINavigationController {
            let navigationController = segue.destinationViewController as UINavigationController
            if navigationController.viewControllers[0] is MapViewController {
                let controller = navigationController.viewControllers[0] as MapViewController
                controller.delegate = self
            }
        }
    }

}

