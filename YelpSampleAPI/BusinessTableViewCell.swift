//
//  BusinessTableViewCell.swift
//  YelpSampleAPI
//
//  Created by Benjamin Cortens on 2015-10-30.
//  Copyright © 2015 Benjamin Cortens. All rights reserved.
//

import UIKit

class BusinessTableViewCell: UITableViewCell
{

	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var categoriesLabel: UILabel!
	@IBOutlet weak var photoPreview: UIImageView!
	@IBOutlet weak var ratingControl: RatingControl!
	@IBOutlet weak var phoneNumber: UILabel!
	@IBOutlet weak var address: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
