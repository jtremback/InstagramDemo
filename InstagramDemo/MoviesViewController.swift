//
//    MoviesViewController.swift
//    InstagramDemo
//
//    Created by Jehan Tremback on 2/4/15.
//    Copyright (c) 2015 Jehan Tremback. All rights reserved.
//
import UIKit
import SwiftyJSON
import Alamofire
import JavaScriptCore

// Patch SwiftyJSON to support constructing a JSON out of [JSON]
extension JSON {
         public init(_ jsonArray:[JSON]) {
                self.init(jsonArray.map { $0.object })
        }
}

class MoviesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    var json: JSON!
    var refreshControl: UIRefreshControl!

    let jsContext = JSContext()

    override func viewDidLoad() {
        super.viewDidLoad()

        let jsPath = NSBundle.mainBundle().pathForResource(
            "color-convert-0.5.1",
            ofType: "js"
        )
        if let jsString = String(
            contentsOfFile: jsPath!,
            encoding: NSUTF8StringEncoding,
            error: nil
        ) {
            jsContext.evaluateScript(jsString)
        }

        let rgb: JSValue = jsContext.evaluateScript(
            "colorConvert.lab2rgb(\([23,34,45]))"
        )
        println(rgb.toArray()[0])

        refreshControl = UIRefreshControl()
        refreshControl.addTarget(
            self,
            action: "fetchStories",
            forControlEvents: UIControlEvents.ValueChanged
        )

        let dummyTableVC = UITableViewController()
        dummyTableVC.tableView = tableView
        dummyTableVC.refreshControl = refreshControl

        fetchStories()
    }

    func fetchStories() {
        self.loadingIndicator.startAnimating()
        self.loadingIndicator.hidden = false

        let request = Alamofire.request(
            .GET,
            "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json",
            parameters: [
                "apikey": "e2evqmpxp9upphtv3xf8jsmd",
                "limt": 16,
                "country": "us"
            ]
        ).response { (req, res, json, err) in
            if err != nil {
                self.errorLabel.hidden = false
            } else {
                self.errorLabel.hidden = true
                if let json = NSJSONSerialization.JSONObjectWithData(
                    json as NSData,
                    options: nil,
                    error: nil
                ) as? NSDictionary {
                    self.json = JSON(json)
                    self.tableView.reloadData()
                }
            }

            self.loadingIndicator.stopAnimating()
            self.loadingIndicator.hidden = true

            self.refreshControl.endRefreshing()
        }
    }

    func displayErrorMessage () {
        errorLabel.hidden = false
    }

    func tableView (
        tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        if let json = self.json {
            return json["movies"].arrayValue.count
        }
        return 0
    }

    func tableView(
        tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath
    ) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(
            "com.codepath.instacell"
        ) as MoviesTableViewCell
        
        if let json = json {
            let jsonRow = json["movies"][indexPath.row]

            cell.blurbLabel.text = jsonRow["synopsis"].stringValue
            cell.titleLabel.text = jsonRow["title"].stringValue

            let viewersRating = jsonRow["ratings"]["audience_score"].numberValue
            cell.viewersRating.text = "\(viewersRating)%"

            let criticsRating = jsonRow["ratings"]["critics_score"].numberValue
            cell.criticsRating.text = "\(criticsRating)%"

            let averageRating = (Int(criticsRating) + Int(viewersRating)) / 2

            let mpaaRating = jsonRow["mpaa_rating"].stringValue
            let runTime = jsonRow["runtime"].stringValue
            let year = jsonRow["year"].stringValue
            cell.infoLabel.text = "\(year) • \(mpaaRating) • \(runTime) min"

            let rgbJSValue: JSValue = jsContext.evaluateScript(
                "colorConvert.lab2rgb(\([Double(averageRating) * 2.0, Double(viewersRating) * 1.0, Double(criticsRating) * 1.0]))"
            )

            let rgbArray = rgbJSValue.toArray()

            let ratingColor = UIColor(
                red: CGFloat(rgbArray[0] as Int) / 255,
                green: CGFloat(rgbArray[1] as Int) / 255,
                blue: CGFloat(rgbArray[2] as Int) / 255,
                alpha: CGFloat(255) / 255
            )

            cell.titleLabel.textColor = ratingColor

            let url = NSURL(string: jsonRow["posters"]["thumbnail"].stringValue)

            cell.photoImageView.setImageWithURL(
                url,
                placeholderImage: UIImage(named: "Placeholder")
            )
        }

        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailSegue" {
            let cell = sender as UITableViewCell
            if let indexPath = tableView.indexPathForCell(cell) {

                let detailViewController = segue.destinationViewController as DetailViewController
                detailViewController.jsonRow = json["movies"][indexPath.row]
                
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
        }
    }
}
