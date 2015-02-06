//
//  PhotosViewController.swift
//  InstagramDemo
//
//  Created by Jehan Tremback on 2/4/15.
//  Copyright (c) 2015 Jehan Tremback. All rights reserved.
//
import UIKit
import SwiftyJSON

class PhotosViewController: UIViewController {
  var photos: NSArray!
  @IBOutlet weak var tableView: UITableView!
  var refreshControl: UIRefreshControl!
  
  override func viewDidLoad() {
    super.viewDidLoad()
//    tableView.dataSource = self
//    tableView.rowHeight = 320

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

    var request = NSURLRequest(URL: url)
    NSURLConnection.sendAsynchronousRequest(
      request,
      queue: NSOperationQueue.mainQueue()
    ) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
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
  
  
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func tableView(
    tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    return 10
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 10
  }
  
  func tableView(
    tableView: UITableView,
    titleForHeaderInSection section: Int
  ) -> String? {
    return "Section \(section)"
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
    }
    
    return cell
  }
}
