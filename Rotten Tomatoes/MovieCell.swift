//
//  MovieCell.swift
//  Rotten Tomatoes
//
//  Created by Zhi Huang on 8/29/15.
//  Copyright (c) 2015 Zhi Huang. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var posterSpinnerView: UIActivityIndicatorView!
    @IBOutlet weak var cellSpinnerView: UIActivityIndicatorView!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellSpinnerView.startAnimating()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
