//
//  AddMovieController.swift
//  Cinematic Admin
//
//  Created by Khant Zaw Ko on 24/1/18.
//  Copyright © 2018 Khant Zaw Ko. All rights reserved.
//

import UIKit
import Firebase

class MovieInTheatreController: UITableViewController, UIPopoverPresentationControllerDelegate {

    var selectedCinema = Cinema()
    var selectedTheatre = Theatre()
    
    var selectedMovieKeysInTheatre = [String]()
    var selectedMovieNames = [String]()
    var selectedMovieImages = [String]()
    var selectedStartDates = [String]()
    var selectedWeeks = [Int]()
    var showtimesString = String()
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getMovieDataFromTheatre()
    }

    @IBAction func pressedAddMovie(_ sender: Any) {
        let addMoviePopupController = storyboard?.instantiateViewController(withIdentifier: "PopoverController") as! MovieInTheatrePopoverController
        
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
        return selectedMovieNames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        cell.movieImage.layer.cornerRadius = 5
        cell.movieImage.downloadedFrom(link: selectedMovieImages[indexPath.row])
        cell.movieName.text = selectedMovieNames[indexPath.row]
        cell.cinemaType.text = "Theatre Type: " + selectedTheatre.type!
        cell.startDate.text = "Start Date: \(selectedStartDates[indexPath.row])"
        cell.showtimes.text = "Showtimes: \(showtimesString)"
        cell.weeksInTheatre.text = "Weeks in Theatre: \(String(selectedWeeks[indexPath.row]) + (selectedWeeks[indexPath.row] == 1 ? " week" : " weeks"))"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            selectedMovieNames.remove(at: indexPath.row)
            removeMovieDataInCinema(row: indexPath.row)
            tableView.endUpdates()
        }
    }
    
    func getMovieDataFromTheatre() {
        ref = Database.database().reference().child("theatres/\(selectedTheatre.key!)/movies")
        let moviesRef = Database.database().reference().child("movies")

        ref.observe(DataEventType.childAdded, with: {(snapshot) in
            var postDict = snapshot.value as! [String : AnyObject]
            if let movieKey = postDict["movieID"], let movieStartDate = postDict["startDate"], let weekInTheatre = postDict["weeksInTheatre"]  {
                self.selectedMovieKeysInTheatre.append(movieKey as! String)
                self.selectedStartDates.append(movieStartDate as! String)
                self.selectedWeeks.append(weekInTheatre as! Int)
                
                moviesRef.child(movieKey as! String).observe(DataEventType.value, with: {(snap) in
                    var movieDict = snap.value as! [String : AnyObject]
                    if let movieName = movieDict["name"], let movieImage = movieDict["image"] {
                        self.selectedMovieNames.append(movieName as! String)
                        self.selectedMovieImages.append(movieImage as! String)
                    }
                    self.tableView.reloadData()
                })
            }
        })
    }
    
    func removeMovieDataInCinema(row: Int) {
        let theatreRef = Database.database().reference().child("theatres/\(selectedTheatre.key!)/movies/\(selectedMovieKeysInTheatre[row])")
        theatreRef.removeValue()
        
        let movieRef = Database.database().reference().child("movies/\(selectedMovieKeysInTheatre[row])/theatres/\(selectedTheatre.key!)")
        movieRef.removeValue()
    }
}

extension MovieInTheatreController: MovieSelectionDelegate {
    func didSelectMovie(selectedMovie: Movie) {
//        selectedMovieNames.append(selectedMovie.name!)
//        selectedMovieImages.append(selectedMovie.image!)
//        selectedStartDates.append(selectedMovie.startDate!)
//        selectedWeeks.append(selectedMovie.weeksInTheatre!)
    }
}
