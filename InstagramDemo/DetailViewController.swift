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
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var criticsRating: UILabel!
    @IBOutlet weak var viewersRating: UILabel!
    @IBOutlet weak var infoHeight: NSLayoutConstraint!

    var infoExpanded = false
    @IBAction func infoTapped(sender: AnyObject) {
        if (infoExpanded) {
            self.infoHeight.constant = 120.0
            infoExpanded = false
            UIView.animateWithDuration(0.2, animations: {
                self.mainView.layoutIfNeeded()
            })
        } else {
            self.infoHeight.constant = 300.0
            infoExpanded = true
            UIView.animateWithDuration(0.2, animations: {
                self.mainView.layoutIfNeeded()
            })
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let jsonRow = self.jsonRow? {

            self.blurbLabel.text = jsonRow["synopsis"].stringValue
            self.titleLabel.text = jsonRow["title"].stringValue

            let viewersRating = jsonRow["ratings"]["audience_score"].stringValue
            self.viewersRating.text = "\(viewersRating)%"

            let criticsRating = jsonRow["ratings"]["critics_score"].stringValue
            self.criticsRating.text = "\(criticsRating)%"

            let mpaaRating = jsonRow["mpaa_rating"].stringValue
            let runTime = jsonRow["runtime"].stringValue
            let year = jsonRow["year"].stringValue
            self.infoLabel.text = "\(year) • \(mpaaRating) • \(runTime) min"

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
