//
//  Business.swift
//  Yelp
//
//  Created by Jerry Su on 9/20/14.
//  Copyright (c) 2014 Jerry Su. All rights reserved.
//

class YelpBusiness {

    var dictionary: NSDictionary

    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        println(dictionary)
    }

    var name: String {
        get {
            return self.dictionary["name"] as String
        }
    }

    var imageURL: NSURL? {
        get {
            if let image = self.dictionary["image_url"] as? String {
                return NSURL(string: image.stringByReplacingOccurrencesOfString("ms.jpg", withString: "ls.jpg", options: nil, range: nil))
            }
            return nil
        }
    }

    var ratingImageURL: NSURL {
        get {
            return NSURL(string: self.dictionary["rating_img_url_large"] as String)
        }
    }

    var reviewCount: Int {
        get {
            return self.dictionary["review_count"] as Int
        }
    }

    var deals: Array<AnyObject>? {
        get {
            if let deals = self.dictionary["deals"] as? Array<AnyObject> {
                return deals
            }
            return nil
        }
    }

    var latitude: CGFloat? {
        get {
            if let location = self.dictionary["location"] as? NSDictionary {
                if let coordinate = location["coordinate"] as? NSDictionary {
                    return (coordinate["latitude"] as CGFloat)
                }
            }
            return nil
        }
    }

    var longitude: CGFloat? {
        get {
            if let location = self.dictionary["location"] as? NSDictionary {
                if let coordinate = location["coordinate"] as? NSDictionary {
                    return (coordinate["longitude"] as CGFloat)
                }
            }
            return nil
        }
    }

    var displayAddress: String {
        get {
            if let location = self.dictionary["location"] as? NSDictionary {
                if let address = location["address"] as? Array<String> {
                    if let neighborhoods = location["neighborhoods"] as? Array<String> {
                        return ", ".join(address + [neighborhoods[0]])
                    }
                    return ", ".join(address)
                }
            }
            return ""
        }
    }

    var displayCategories: String {
        get {
            if let categories = self.dictionary["categories"] as? Array<Array<String>> {
                return ", ".join(categories.map({ $0[0] }))
            }
            return ""
        }
    }

}