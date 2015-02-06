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

class PhotosViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var errorLabel: UILabel!
  var photos: NSArray!
  var isError = false
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
    var clientId = "ef9cb306bc39451d9d0ef2ba3c1b9584"
    var url = NSURL(
      string: "https://api.instagram.com/v1/media/popular?client_id=\(clientId)"
    )!

    let delayInSeconds = 2.0
    let startTime = dispatch_time(
      DISPATCH_TIME_NOW,
      Int64(delayInSeconds * Double(NSEC_PER_SEC))
    )

    dispatch_after(startTime, dispatch_get_main_queue()) { () -> Void in
      self.errorLabel.hidden = false
    }

    var request = NSURLRequest(URL: url)
    NSURLConnection.sendAsynchronousRequest(
      request,
      queue: NSOperationQueue.mainQueue()
    ) {(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
      if error != nil {
        self.errorLabel.hidden = false
      } else {
        var responseDictionary = NSJSONSerialization.JSONObjectWithData(
          data,
          options: nil,
          error: nil
        ) as NSDictionary
        

        self.photos = responseDictionary["data"] as NSArray
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
      }
    }
  }

  func displayErrorMessage () {
    errorLabel.hidden = false
  }

  func tableView (
    tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    if let photos = self.photos {
      return photos.count
    }
    return 1
  }

  func tableView(
    tableView: UITableView,
    cellForRowAtIndexPath indexPath: NSIndexPath
  ) -> UITableViewCell {
    var cell = tableView.dequeueReusableCellWithIdentifier(
      "com.codepath.instacell"
    ) as PhotoTableViewCell
    
    if (photos != nil) {
      let json = JSON(photos)
      let url = NSURL(
        string: json[indexPath.row]["images"]["standard_resolution"]["url"].stringValue
      )
      
      cell.photoImageView.setImageWithURL(url)
      cell.rowLabel.text = "Row: \(indexPath.row)"
    }

    if (self.isError) {
      cell.rowLabel.text = "Fuck"
    }

    return cell
  }
}
