//
//  PopoverCinemaCell.swift
//  Cinematic Admin
//
//  Created by Khant Zaw Ko on 29/1/18.
//  Copyright © 2018 Khant Zaw Ko. All rights reserved.
//

import UIKit

class PopoverCinemaCell: UITableViewCell {

    @IBOutlet weak var cinemaNameLabel: UILabel!
    @IBOutlet weak var cinemaName: UITextField!
    
    @IBOutlet weak var cinemaPhoneLabel: UILabel!
    @IBOutlet weak var cinemaPhone: UITextField!
    
    @IBOutlet weak var cinemaLocationLabel: UILabel!
    @IBOutlet weak var cinemaLocation: UITextField!
    
    @IBOutlet weak var cinemaMaxTheatreLabel: UILabel!
    @IBOutlet weak var maxTheatrePickerView: UIPickerView!
}
