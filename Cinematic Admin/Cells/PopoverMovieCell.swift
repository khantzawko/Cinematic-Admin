//
//  PopupMovieCell.swift
//  Cinematic Admin
//
//  Created by Khant Zaw Ko on 24/1/18.
//  Copyright © 2018 Khant Zaw Ko. All rights reserved.
//

import UIKit

class PopoverMovieCell: UITableViewCell{

    @IBOutlet weak var chooseMovieLabel: UILabel!
    @IBOutlet weak var chooseStartDateLabel: UILabel!
    @IBOutlet weak var chooseWeeksLabel: UILabel!

    @IBOutlet weak var chooseMoviePickerView: UIPickerView!
    @IBOutlet weak var chooseStartDatePicker: UIDatePicker!
    @IBOutlet weak var chooseWeekPickerView: UIPickerView!
}
