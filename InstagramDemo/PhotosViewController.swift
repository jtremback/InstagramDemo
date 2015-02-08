//
//  PhotosViewController.swift
//  InstagramDemo
//
//  Created by Jehan Tremback on 2/4/15.
//  Copyright (c) 2015 Jehan Tremback. All rights reserved.
//
import UIKit
import SwiftyJSON
import Alamofire

// Patch SwiftyJSON to support constructing a JSON out of [JSON]
extension JSON {
     public init(_ jsonArray:[JSON]) {
        self.init(jsonArray.map { $0.object })
    }
}

class PhotosViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var errorLabel: UILabel!
  @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!


  var json: JSON!
  var refreshControl: UIRefreshControl!

  override func viewDidLoad() {
    super.viewDidLoad()

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
          println(json)
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
    ) as PhotoTableViewCell
    
    if let json = json {
      let url = NSURL(
        string: json["movies"][indexPath.row]["posters"]["thumbnail"].stringValue
      )

      let jsonRow = json["movies"][indexPath.row]

      cell.blurbLabel.text = jsonRow["synopsis"].stringValue
      cell.titleLabel.text = jsonRow["title"].stringValue

      let viewersRating = jsonRow["ratings"]["audience_score"].stringValue
      cell.viewersRating.text = "\(viewersRating)%"

      let criticsRating = jsonRow["ratings"]["critics_score"].stringValue
      cell.criticsRating.text = "\(criticsRating)%"

      let mpaaRating = jsonRow["mpaa_rating"].stringValue
      let runTime = jsonRow["runtime"].stringValue
      let year = jsonRow["year"].stringValue
      cell.infoLabel.text = "\(year) • \(mpaaRating) • \(runTime) min"

      cell.photoImageView.setImageWithURL(url, placeholderImage: UIImage(named: "Placeholder"))
    }

    return cell
  }
}
