//
//  PickerViewCell.swift
//  ExtendingTableViewCell-Swift
//
//  Created by Kevin Chen on 7/8/14.
//  Copyright (c) 2014 KnightLord Universe Technolegies Ltd. All rights reserved.
//

import UIKit

class PickerViewCell: UITableViewCell {

    @IBOutlet var pickerView: UIPickerView!
    
    init(style: UITableViewCellStyle, reuseIdentifier: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Initialization code
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
