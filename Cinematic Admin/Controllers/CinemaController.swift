//
//  AddCinemaController.swift
//  Cinematic Admin
//
//  Created by Khant Zaw Ko on 24/1/18.
//  Copyright © 2018 Khant Zaw Ko. All rights reserved.
//

import UIKit
import Firebase

class CinemaController: UITableViewController, UIPopoverPresentationControllerDelegate {
    
    var cinemaMaxNoOfTheatres = [Int]()
    
    var cinema = [Cinema]()
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        
        getCinemaData()
    }

    @IBAction func pressedAddCinema(_ sender: Any) {
        let cinemaPopoverController = storyboard?.instantiateViewController(withIdentifier: "CinemaPopoverController") as! CinemaPopoverController
        cinemaPopoverController.modalPresentationStyle = .popover
        if let popoverController = cinemaPopoverController.popoverPresentationController {
            popoverController.permittedArrowDirections = .any
            popoverController.delegate = self
        }
        present(cinemaPopoverController, animated: true, completion: nil)
    }
    
    func getCinemaData() {
        ref = Database.database().reference().child("cinema")
        ref.observe(DataEventType.childAdded, with: {(snapshot) in
            
            var cinemaDict = snapshot.value as! [String : AnyObject]
            
            if  let cinemaName = cinemaDict["name"],
                let cinamePhone = cinemaDict["phone"],
                let cinemaLocation = cinemaDict["location"],
                let cinemaMaxNo = cinemaDict["maxNo"]  {
                
                self.cinema.append(Cinema(key: snapshot.key, name: cinemaName as? String, location: cinemaLocation as? String, phone: cinamePhone as? String, maxNoOfTheatre: cinemaMaxNo as? Int))
            }
            self.tableView.reloadData()
        })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cinema.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CinemaCell", for: indexPath) as! CinemaCell
        cell.cinemaName.text = cinema[indexPath.row].name
        cell.cinemaInfo.text = "\(cinema[indexPath.row].phone!) • \(cinema[indexPath.row].location!) • \(cinema[indexPath.row].maxNoOfTheatre!)"
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToAddTheatre" {
            let tc: TheatreController = segue.destination as! TheatreController
            let selectedRow = tableView.indexPathForSelectedRow?.row
            let selectedCinema = cinema[selectedRow!]
            tc.selectedCinema = selectedCinema
        }
    }
    
}
