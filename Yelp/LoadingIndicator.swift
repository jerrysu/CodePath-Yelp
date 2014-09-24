//
//  LoadingIndicator.swift
//  Yelp
//
//  Created by Jerry Su on 9/23/14.
//  Copyright (c) 2014 Jerry Su. All rights reserved.
//

import UIKit

class LoadingIndicator: UIView {

    @IBOutlet weak var logo: UIImageView!

    override func awakeFromNib() {
        self.animate()
    }

    func animate() {
        logo.image = UIImage.animatedImageNamed("AnimatedLogo", duration: 0.4)
    }

    func stopAnimating() {
        logo.image = UIImage(named: "Logo")
    }

}