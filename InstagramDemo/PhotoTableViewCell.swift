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
  @IBOutlet weak var rowLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }

}
