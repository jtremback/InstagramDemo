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

    let clientId = "ef9cb306bc39451d9d0ef2ba3c1b9584"
    let request = Alamofire.request(
      .GET,
      "https://api.instagram.com/v1/media/popular?client_id=\(clientId)",
      parameters: ["client_id": clientId]
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
      return json["data"].arrayValue.count
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
      let string = json["data"][indexPath.row]["images"]["standard_resolution"]["url"].stringValue

      let url = NSURL(
        string: string
      )

      cell.photoImageView.setImageWithURL(url, placeholderImage: UIImage(named: "Placeholder"))
    }

    return cell
  }
}
