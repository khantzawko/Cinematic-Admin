//
//  AddMovieController.swift
//  Cinematic Admin
//
//  Created by Khant Zaw Ko on 24/1/18.
//  Copyright © 2018 Khant Zaw Ko. All rights reserved.
//

import UIKit
import Firebase

class AddMovieController: UITableViewController, UIPopoverPresentationControllerDelegate {

    var selectedCinema = Cinema()
    var selectedTheatre = Theatre()
    
    var selectedMovieNames = [String]()
    var selectedMovieImages = [String]()
    var selectedStartDates = [String]()
    var selectedWeeks = [Int]()
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getMovieData()
    }

    @IBAction func pressedAddMovie(_ sender: Any) {
        let addMoviePopupController = storyboard?.instantiateViewController(withIdentifier: "PopoverController") as! AddMoviePopoverController
        
        addMoviePopupController.selectionDelegate = self
        
        addMoviePopupController.selectedCinema = selectedCinema
        addMoviePopupController.selectedTheatre = selectedTheatre
        
        addMoviePopupController.modalPresentationStyle = .popover
        if let popoverController = addMoviePopupController.popoverPresentationController {
            popoverController.permittedArrowDirections = .any
            popoverController.delegate = self
        }
        present(addMoviePopupController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return selectedMovieNames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        cell.movieImage.layer.cornerRadius = 10
        cell.movieImage.downloadedFrom(link: selectedMovieImages[indexPath.row])
        cell.movieName.text = selectedMovieNames[indexPath.row]
        cell.cinemaType.text = "Cinema Type: " + selectedTheatre.type!
        cell.startDate.text = "Start Date: \(selectedStartDates[indexPath.row])"
        cell.showtimes.text = "Showtimes: " + selectedTheatre.showtimes!
        cell.weeksInTheatre.text = "Weeks in Theatre: \(String(selectedWeeks[indexPath.row]) + (selectedWeeks[indexPath.row] == 1 ? " week" : " weeks"))"
        return cell
    }
    
    func getMovieData() {
        ref = Database.database().reference().child("cinema/\(selectedCinema.key!)/Theatre/\(selectedTheatre.key!)/MovieShowing")
        ref.observe(DataEventType.childAdded, with: {(snapshot) in
            
            var postDict = snapshot.value as! [String : AnyObject]
            
            if let movieName = postDict["Name"], let movieImage = postDict["Image"], let movieStartDate = postDict["StartDate"], let weekInTheatre = postDict["WeeksInTheatre"]  {
                self.selectedMovieNames.append(movieName as! String)
                self.selectedMovieImages.append(movieImage as! String)
                self.selectedStartDates.append(movieStartDate as! String)
                self.selectedWeeks.append(weekInTheatre as! Int)
            }
            self.tableView.reloadData()
        })
    }
}

extension AddMovieController: MovieSelectionDelegate {
    func didSelectMovie(selectedMovie: Movie) {
        selectedMovieNames.append(selectedMovie.name!)
        selectedMovieImages.append(selectedMovie.image!)
        selectedStartDates.append(selectedMovie.startDate!)
        selectedWeeks.append(selectedMovie.weeksInTheatre!)
    }
}
