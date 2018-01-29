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
    
    var cinemaKeys = [String]()
    var cinemaNames = [String]()
    var cinemaPhones = [String]()
    var cinemaLocations = [String]()
    var cinemaMaxNoOfTheatres = [Int]()
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
                
                self.cinemaKeys.append(snapshot.key)
                self.cinemaNames.append(cinemaName as! String)
                self.cinemaPhones.append(cinamePhone as! String)
                self.cinemaLocations.append(cinemaLocation as! String)
                self.cinemaMaxNoOfTheatres.append(cinemaMaxNo as! Int)
            }
            self.tableView.reloadData()
        })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cinemaNames.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CinemaCell", for: indexPath) as! CinemaCell
        cell.cinemaName.text = cinemaNames[indexPath.row]
        cell.cinemaInfo.text = "\(cinemaPhones[indexPath.row]) • \(cinemaLocations[indexPath.row]) • \(cinemaMaxNoOfTheatres[indexPath.row])"
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToAddTheatre" {
            let tc: TheatreController = segue.destination as! TheatreController
            let selectedRow = tableView.indexPathForSelectedRow?.row
            let selectedCinema = Cinema(key: cinemaKeys[selectedRow!], name: cinemaNames[selectedRow!], phone: cinemaPhones[selectedRow!], location: cinemaLocations[selectedRow!], maxNoOfTheatre: cinemaMaxNoOfTheatres[selectedRow!])
            tc.selectedCinema = selectedCinema
        }
    }
    
}
