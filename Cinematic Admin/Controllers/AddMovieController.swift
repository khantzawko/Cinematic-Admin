//
//  AddMovieController.swift
//  Cinematic Admin
//
//  Created by Khant Zaw Ko on 24/1/18.
//  Copyright © 2018 Khant Zaw Ko. All rights reserved.
//

import UIKit

class AddMovieController: UITableViewController, UIPopoverPresentationControllerDelegate {

    var selectedMovie = [String]()
    var selectedStartDate = [String]()
    var selectedWeeks = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func pressedAddMovie(_ sender: Any) {
        let addMoviePopupController = storyboard?.instantiateViewController(withIdentifier: "PopoverController") as! AddMoviePopupController
        
        addMoviePopupController.selectionDelegate = self
        
        addMoviePopupController.modalPresentationStyle = .popover
        if let popoverController = addMoviePopupController.popoverPresentationController {
            popoverController.permittedArrowDirections = .any
            popoverController.delegate = self
        }
        present(addMoviePopupController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return selectedMovie.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        cell.movieName.text = selectedMovie[indexPath.row]
        cell.cinemaType.text = "Cinema Type: Type C"
        cell.startDate.text = "Start Date: \(selectedStartDate[indexPath.row])"
        cell.showtimes.text = "Showtimes: 9:30, 12:30, 15:30, 18:30, 21:30"
        cell.weeksInTheatre.text = "Weeks in Theatre: \(String(selectedWeeks[indexPath.row]) + (selectedWeeks[indexPath.row] == 1 ? " week" : " weeks"))"
        return cell
    }
}

extension AddMovieController: MovieSelectionDelegate {
    func didSelectMovie(movie: String, startDate: String, weeksInTheatre: Int) {
        selectedMovie.append(movie)
        selectedStartDate.append(startDate)
        selectedWeeks.append(weeksInTheatre)
        
        tableView.reloadData()
    }
}
