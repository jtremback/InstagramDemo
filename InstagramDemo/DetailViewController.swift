//
//  DetailViewController.swift
//  InstagramDemo
//
//  Created by Jehan Tremback on 2/7/15.
//  Copyright (c) 2015 Jehan Tremback. All rights reserved.
//

import UIKit
import SwiftyJSON

class DetailViewController: UIViewController {
    var jsonRow: JSON?

    @IBOutlet weak var blurbLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = CGSizeMake(320, 1000);

        if let jsonRow = self.jsonRow? {

            self.blurbLabel.text = jsonRow["synopsis"].stringValue
//            self.titleLabel.text = jsonRow["title"].stringValue
//
//            let viewersRating = jsonRow["ratings"]["audience_score"].stringValue
//            self.viewersRating.text = "\(viewersRating)%"
//
//            let criticsRating = jsonRow["ratings"]["critics_score"].stringValue
//            self.criticsRating.text = "\(criticsRating)%"
//
//            let mpaaRating = jsonRow["mpaa_rating"].stringValue
//            let runTime = jsonRow["runtime"].stringValue
//            let year = jsonRow["year"].stringValue
//            self.infoLabel.text = "\(year) • \(mpaaRating) • \(runTime) min"

            let thumbnailUrl = jsonRow["posters"]["thumbnail"].stringValue
            // Replace tmb with ori to get full size image
            let originalUrl = NSURL(string: join(
                "_ori.jpg",
                thumbnailUrl.componentsSeparatedByString("_tmb.jpg")
            ))

            posterImageView.setImageWithURL(
                originalUrl,
                placeholderImage: UIImage(named: "Placeholder")
            )

        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

// MARK: - Navigation

}
