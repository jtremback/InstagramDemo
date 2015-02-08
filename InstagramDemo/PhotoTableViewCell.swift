//
//  PhotoTableViewCell.swift
//  InstagramDemo
//
//  Created by Ryan Newton on 2/4/15.
//  Copyright (c) 2015 Jehan Tremback. All rights reserved.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {
  @IBOutlet weak var photoImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var infoLabel: UILabel!
  @IBOutlet weak var viewersRating: UILabel!
  @IBOutlet weak var criticsRating: UILabel!
  @IBOutlet weak var blurbLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }

}
