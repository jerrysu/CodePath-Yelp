//
//  SearchViewController.swift
//  Yelp
//
//  Created by Jerry Su on 9/22/14.
//  Copyright (c) 2014 Jerry Su. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, FiltersViewDelegate {

    var searchBar: UISearchBar!

    var client: YelpClient!

    let yelpConsumerKey = "C6uWCSlZN-pt1qMSzQyeAQ"
    let yelpConsumerSecret = "mCV_4NS3bvZjxCSNvA8e_1djmtE"
    let yelpToken = "IFT9QzRtzVcfH0O6LR7TK5hwtDKKdZBc"
    let yelpTokenSecret = "_7yceRZuAeaIDuJnHRo7gWfWRFc"

    var userLocation: UserLocation!

    var results: Array<YelpBusiness> = []
    var offset: Int = 0
    var total: Int!
    let limit: Int = 20
    var lastResponse: NSDictionary!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.client = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)

        self.userLocation = UserLocation()

        self.searchBar = UISearchBar()
        self.searchBar.delegate = self
        self.searchBar.placeholder = "e.g. sushi, cheeseburger"
        self.navigationItem.titleView = self.searchBar
    }

    final func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.clearResults()
        self.performSearch(searchBar.text)
    }

    final func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.clearResults()
        }
    }

    final func performSearch(term: String, offset: Int = 0, limit: Int = 20) {
        self.searchBar.text = term
        self.onBeforeSearch()
        self.client.searchWithTerm(term, parameters: self.getSearchParameters(), offset: offset, limit: 20, success: {
            (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let results = (response["businesses"] as Array).map({
                (business: NSDictionary) -> YelpBusiness in
                return YelpBusiness(dictionary: business)
            })
            self.results += results
            self.total = response["total"] as Int
            self.lastResponse = response as NSDictionary
            self.offset = self.results.count
            self.onResults(self.results, total: self.total, response: self.lastResponse)
        }, failure: {
            (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            println(error)
        })
    }

    func getSearchParameters() -> Dictionary<String, String> {
        var parameters = [
            "ll": "\(userLocation.latitude),\(userLocation.longitude)"
        ]
        for (key, value) in YelpFilters.instance.parameters {
            parameters[key] = value
        }
        return parameters
    }

    func onBeforeSearch() -> Void {}

    func onResults(results: Array<YelpBusiness>, total: Int, response: NSDictionary) -> Void {}

    final func clearResults() {
        self.results = []
        self.offset = 0
        self.onResultsCleared()
    }

    func onResultsCleared() -> Void {}

    func showDetailsForResult(result: YelpBusiness) {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let controller = storyboard.instantiateViewControllerWithIdentifier("Details") as DetailsViewController
        controller.business = result
        self.navigationController?.pushViewController(controller, animated: true)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destinationViewController is UINavigationController {
            let navigationController = segue.destinationViewController as UINavigationController
            if navigationController.viewControllers[0] is FiltersViewController {
                let controller = navigationController.viewControllers[0] as FiltersViewController
                controller.delegate = self
            } else if (navigationController.viewControllers[0] is DetailsViewController) {
                let controller = navigationController.viewControllers[0] as DetailsViewController
                
            }
        }
    }

    final func onFiltersDone(controller: FiltersViewController) {
        if self.searchBar.text != "" {
            self.clearResults();
            self.performSearch(self.searchBar.text)
        }
    }

    func synchronize(searchView: SearchViewController) {
        self.searchBar.text = searchView.searchBar.text
        self.results = searchView.results
        self.total = searchView.total
        self.offset = searchView.offset
        self.lastResponse = searchView.lastResponse

        if self.results.count > 0 {
            self.onResults(self.results, total: self.total, response: self.lastResponse)
        } else {
            self.onResultsCleared()
        }
    }

}

