//
//  AddMoviePopupController.swift
//  Cinematic Admin
//
//  Created by Khant Zaw Ko on 24/1/18.
//  Copyright © 2018 Khant Zaw Ko. All rights reserved.
//

import UIKit

protocol MovieSelectionDelegate {
    func didSelectMovie(movie: String, startDate: String, weeksInTheatre: Int)
}

class AddMoviePopupController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let pickerViewTitles = ["Coco", "Wonder", "Thor", "IT"]
    var weeks = [String]()
    
    var selectedMovie = String()
    var selectedWeeks = Int()
    var selectedStartDateString = String()
    var selectedStartDate = Date()
    
    var selectionDelegate: MovieSelectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        for week in 1...12 {
            weeks.append(String(week))
        }
    }

    @IBAction func pressedCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pressedDone(_ sender: Any) {

        let alertController = UIAlertController(title: "Confirm?", message: "Are you sure to add the movie?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> () in
            self.dateFormatterAndCheckFriday()
        })
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func dateFormatterAndCheckFriday() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        
        if dateFormatter.string(from: self.selectedStartDate) == "Friday" {
            dateFormatter.dateFormat = "dd-MMM-yyyy"
            self.selectedStartDateString = dateFormatter.string(from: self.selectedStartDate)
            
            if self.selectedMovie.isEmpty && self.pickerViewTitles.count != 0 {
                self.selectedMovie = self.pickerViewTitles[0]
            }
            
            if self.selectedWeeks == 0 && self.weeks.count != 0 {
                self.selectedWeeks = Int(self.weeks[0])!
            }
            
            selectionDelegate?.didSelectMovie(movie: self.selectedMovie, startDate: self.selectedStartDateString, weeksInTheatre: self.selectedWeeks)
            
            self.dismiss(animated: true, completion: nil)
            
        } else {
            let alertController = UIAlertController(title: "Warning!", message: "Selected date must be friday!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // pickerview functions
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 100 {
            return pickerViewTitles.count
        } else if pickerView.tag == 101 {
            return weeks.count
        } else {
            return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 100 {
            return pickerViewTitles[row]
        } else if pickerView.tag == 101 {
            return weeks[row] + (Int(weeks[row]) == 1 ? " week" : " weeks")
        } else {
            return String()
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 100 {
            selectedMovie = pickerViewTitles[row]
        } else if pickerView.tag == 101 {
            selectedWeeks = Int(weeks[row])!
        }
    }
    
    // tableview functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseMovie", for: indexPath) as! PopupMovieCell
            cell.chooseMovieLabel.text = "Choose Movie"
            cell.chooseMoviePickerView.tag = 100
            cell.chooseMoviePickerView.delegate = self
            cell.chooseMoviePickerView.dataSource = self
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseDate", for: indexPath) as! PopupMovieCell
            cell.chooseStartDateLabel.text = "Choose Start Date"
            cell.chooseStartDatePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseWeeks", for: indexPath) as! PopupMovieCell
            cell.chooseWeeksLabel.text = "Weeks in Theatre"
            cell.chooseWeekPickerView.tag = 101
            cell.chooseWeekPickerView.delegate = self
            cell.chooseWeekPickerView.dataSource = self
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        selectedStartDate = sender.date
    }
}
