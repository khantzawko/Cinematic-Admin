//
//  PopoverTheatreCell.swift
//  Cinematic Admin
//
//  Created by Khant Zaw Ko on 30/1/18.
//  Copyright © 2018 Khant Zaw Ko. All rights reserved.
//

import UIKit

class PopoverTheatreCell: UITableViewCell {

    @IBOutlet weak var theatreNameLabel: UILabel!
    @IBOutlet weak var theatreName: UITextField!
    
    @IBOutlet weak var theatreTypeLabel: UILabel!
    @IBOutlet weak var theatrePickerView: UIPickerView!
    
    @IBOutlet weak var showtimesLabel: UILabel!
    @IBOutlet weak var addShowtimes: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
}
