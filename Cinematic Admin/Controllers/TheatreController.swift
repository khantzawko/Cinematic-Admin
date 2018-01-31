//
//  AddTheatreController.swift
//  Cinematic Admin
//
//  Created by Khant Zaw Ko on 24/1/18.
//  Copyright © 2018 Khant Zaw Ko. All rights reserved.
//

import UIKit
import Firebase

class TheatreController: UITableViewController, UIPopoverPresentationControllerDelegate {
    
    var selectedCinema = Cinema()
    var theatres = [Theatre]()
    
    var showtimesString = String()
    
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        getTheatreData()
    }

    @IBAction func pressedAddTheatre(_ sender: Any) {
        let theatrePopoverController = storyboard?.instantiateViewController(withIdentifier: "TheatrePopoverController") as! TheatrePopoverController
        theatrePopoverController.selectedCinema = selectedCinema
        theatrePopoverController.modalPresentationStyle = .popover
        if let popoverController = theatrePopoverController.popoverPresentationController {
            popoverController.permittedArrowDirections = .any
            popoverController.delegate = self
        }
        present(theatrePopoverController, animated: true, completion: nil)
    }
    
    func getTheatreData() {
        ref = Database.database().reference()
        let theatreTypeRef = Database.database().reference().child("theatretypes")
        
        let theatreQuery = ref.child("theatres/").queryOrdered(byChild: "cinemaID").queryEqual(toValue: selectedCinema.key!)
        theatreQuery.observe(DataEventType.childAdded, with: {(snapshot) in

            var postDict = snapshot.value as! [String : AnyObject]

            if let theatreName = postDict["name"], let theatreTypeID = postDict["theatreTypeID"], let theatreShowtime = postDict["showtimes"] {
                theatreTypeRef.child(theatreTypeID as! String).observe(DataEventType.value, with: {(snap) in
                    var theatreTypeDict = snap.value as! [String : AnyObject]
                    if let theatreTypeName = theatreTypeDict["name"] {
                        self.theatres.append(Theatre(key: snapshot.key, name: theatreName as? String, showtimes: theatreShowtime as? [String], type: theatreTypeName as? String))
                    }
                    self.tableView.reloadData()
                })
            }
            self.tableView.reloadData()
        })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return theatres.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TheatreCell", for: indexPath) as! TheatreCell
        cell.theatreName.text = theatres[indexPath.row].name
        cell.theatreType.text = "Type: \(theatres[indexPath.row].type!)"
        
        for index in (theatres[indexPath.row].showtimes)! {
            showtimesString += index + ", "
        }
        
        showtimesString.removeLast(2)
        
        cell.showtimes.text = "Showtimes: \((showtimesString))"
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToAddMovie" {
            let mitc: MovieInTheatreController = segue.destination as! MovieInTheatreController
            let selectedRow = tableView.indexPathForSelectedRow?.row
            
            mitc.selectedCinema = selectedCinema
            mitc.selectedTheatre = theatres[selectedRow!]
            mitc.showtimesString = showtimesString            
        }
    }
}
