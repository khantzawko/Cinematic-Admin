//
//  AddTheatreController.swift
//  Cinematic Admin
//
//  Created by Khant Zaw Ko on 24/1/18.
//  Copyright © 2018 Khant Zaw Ko. All rights reserved.
//

import UIKit
import Firebase

class AddTheatreController: UITableViewController {
    
    var selectedCinema = Cinema()
    
    var theatreKeys = [String]()
    var theatreNames = [String]()
    var theatreShowtimes = [String]()
    var theatreTypes = [String]()
    
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        getTheatreData()
    }

    @IBAction func pressedAddTheatre(_ sender: Any) {
        let alertController = UIAlertController(title: "Add Theatre", message: "Please type in the name of theatre", preferredStyle: .alert)
        alertController.addTextField(configurationHandler: {(_ textField: UITextField) -> () in
            textField.placeholder = "Theatre Name"
        })
        let addAction = UIAlertAction(title: "Add", style: .default, handler: {(_ action: UIAlertAction) -> () in
            self.putTheatreData(name: alertController.textFields![0].text!, type: "Type A", showtimes: "930, 1230, 1530, 1830, 2130")
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func putTheatreData(name: String, type: String, showtimes: String) {
        ref = Database.database().reference()
        let key = ref.childByAutoId().key
        
        let path = "cinema/\(selectedCinema.key!)/Theatre/\(key)"
        let post = ["Name": name,
                    "TheatreType": type,
                    "Showtimes": showtimes] as [String : Any]
        
        let updateData = [path:post]
        self.ref.updateChildValues(updateData)
    }
    
    func getTheatreData() {
        ref = Database.database().reference().child("cinema/\(selectedCinema.key!)/Theatre")
        ref.observe(DataEventType.childAdded, with: {(snapshot) in
            
            var postDict = snapshot.value as! [String : AnyObject]
            
            if let theatreName = postDict["Name"], let theatreType = postDict["TheatreType"], let theatreShowtime = postDict["Showtimes"] {
                self.theatreKeys.append(snapshot.key)
                self.theatreNames.append(theatreName as! String)
                self.theatreShowtimes.append(theatreShowtime as! String)
                self.theatreTypes.append(theatreType as! String)

            }
            self.tableView.reloadData()
        })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return theatreNames.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TheatreCell", for: indexPath) as! TheatreCell
        cell.theatreName.text = theatreNames[indexPath.row]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToAddMovie" {
            let amc: AddMovieController = segue.destination as! AddMovieController
            let selectedRow = tableView.indexPathForSelectedRow?.row
            let selectedTheatre = Theatre(key: theatreKeys[selectedRow!], name: theatreNames[selectedRow!], showtimes: theatreShowtimes[selectedRow!], type: theatreTypes[selectedRow!])
            
            amc.selectedCinema = selectedCinema
            amc.selectedTheatre = selectedTheatre
        }
    }
}
