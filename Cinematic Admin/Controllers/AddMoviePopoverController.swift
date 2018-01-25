//
//  AddMoviePopupController.swift
//  Cinematic Admin
//
//  Created by Khant Zaw Ko on 24/1/18.
//  Copyright © 2018 Khant Zaw Ko. All rights reserved.
//

import UIKit
import Firebase

protocol MovieSelectionDelegate {
    func didSelectMovie(selectedMovie: Movie)
}

class AddMoviePopoverController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var selectedCinema = Cinema()
    var selectedTheatre = Theatre()
    var selectedMovie = Movie()
    
    var movieNames = [String]()
    var movieImages = [String]()
    var movieKeys = [String]()
    var weeks = [String]()
    
    var selectedStartDate = Date()
    
    var ref: DatabaseReference!
    var selectionDelegate: MovieSelectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        for week in 1...12 {
            weeks.append(String(week))
        }
        
        getMovieData()
    }
    
    func getMovieData() {
        ref = Database.database().reference().child("movies")
        ref.observe(DataEventType.childAdded, with: {(snapshot) in
            
            var postDict = snapshot.value as! [String : AnyObject]
            
            if let movieName = postDict["Name"], let movieImage = postDict["Image"]  {
                self.movieNames.append(movieName as! String)
                self.movieImages.append(movieImage as! String)
                self.movieKeys.append(snapshot.key)
            }
            self.tableView.reloadData()
        })
    }
    
    func putMovieDataToTheatre(selectedMovie: Movie) {
        ref = Database.database().reference()
        let key = ref.childByAutoId().key
        
        let path = "cinema/\(selectedCinema.key!)/Theatre/\(selectedTheatre.key!)/MovieShowing/\(key)"
        let post = ["Name": selectedMovie.name!,
                    "Image": selectedMovie.image!,
                    "StartDate": selectedMovie.startDate!,
                    "WeeksInTheatre": selectedMovie.weeksInTheatre!] as [String : Any]
        
        let updateData = [path:post]
        self.ref.updateChildValues(updateData)
    }
    
    func putCinemaDataToMovie(selectedCinema: Cinema, selectedTheatre: Theatre, selectedMovie: Movie) {
        ref = Database.database().reference()
        let key = ref.childByAutoId().key
        
        let path = "movies/\(selectedMovie.key!)/CinemaShowing/\(key)"
        let post = ["CinemaName": selectedCinema.name!,
                    "TheatreName": selectedTheatre.name!,
                    "Showtimes": selectedTheatre.showtimes!,
                    "TheatreType": selectedTheatre.type!,
                    "StartDate": selectedMovie.startDate!,
                    "WeeksInTheatre": selectedMovie.weeksInTheatre!] as [String : Any]
        
        let updateData = [path:post]
        self.ref.updateChildValues(updateData)
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
            selectedMovie.startDate = dateFormatter.string(from: self.selectedStartDate)
            
            if selectedMovie.name == nil && self.movieNames.count != 0 {
                selectedMovie.key = self.movieKeys[0]
                selectedMovie.name = self.movieNames[0]
                selectedMovie.image = self.movieImages[0]
            }
            
            if selectedMovie.weeksInTheatre == nil && self.weeks.count != 0 {
                selectedMovie.weeksInTheatre = Int(self.weeks[0])!
            }
            
            // check for not duplicate starting date before put the data
            putMovieDataToTheatre(selectedMovie: selectedMovie)
            putCinemaDataToMovie(selectedCinema: selectedCinema, selectedTheatre: selectedTheatre, selectedMovie: selectedMovie)
            
//            selectionDelegate?.didSelectMovie(selectedMovie: selectedMovie)
            
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
            return movieNames.count
        } else if pickerView.tag == 101 {
            return weeks.count
        } else {
            return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 100 {
            return movieNames[row]
        } else if pickerView.tag == 101 {
            return weeks[row] + (Int(weeks[row]) == 1 ? " week" : " weeks")
        } else {
            return String()
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 100 {
            selectedMovie.name = movieNames[row]
            selectedMovie.image = movieImages[row]
            selectedMovie.key = movieKeys[row]
        } else if pickerView.tag == 101 {
            selectedMovie.weeksInTheatre = Int(weeks[row])!
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
