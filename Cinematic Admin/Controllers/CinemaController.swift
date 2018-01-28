//
//  AddCinemaController.swift
//  Cinematic Admin
//
//  Created by Khant Zaw Ko on 24/1/18.
//  Copyright © 2018 Khant Zaw Ko. All rights reserved.
//

import UIKit
import Firebase

class AddCinemaController: UITableViewController {
    
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
        let alertController = UIAlertController(title: "Add Cinema", message: "Please type in the name of cinema", preferredStyle: .alert)
        alertController.addTextField(configurationHandler: {(_ textField: UITextField) -> () in
            textField.placeholder = "Cinema Name"
        })
        let addAction = UIAlertAction(title: "Add", style: .default, handler: {(_ action: UIAlertAction) -> () in
            self.putCinemaData(name: alertController.textFields![0].text!, phone: "100", location: "Testing Location", maxNoOfCinema: 3)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func putCinemaData(name: String, phone: String, location: String, maxNoOfCinema: Int) {
        ref = Database.database().reference()
        let key = ref.childByAutoId().key
        
        let path = "cinema/\(key)"
        let post = ["name": name,
                    "phone": phone,
                    "location": location,
                    "maxNo": maxNoOfCinema] as [String : Any]
        
        let updateData = [path:post]
        self.ref.updateChildValues(updateData)
    }
    
    func getCinemaData() {
        ref = Database.database().reference().child("cinema")
        ref.observe(DataEventType.childAdded, with: {(snapshot) in
            
            var postDict = snapshot.value as! [String : AnyObject]
            
            if let cinemaName = postDict["name"], let cinamePhone = postDict["phone"], let cinemaLocation = postDict["location"], let cinemaMaxNo = postDict["maxNo"]  {
                
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
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToAddTheatre" {
            let atc: AddTheatreController = segue.destination as! AddTheatreController
            let selectedRow = tableView.indexPathForSelectedRow?.row
            let selectedCinema = Cinema(key: cinemaKeys[selectedRow!], name: cinemaNames[selectedRow!], phone: cinemaPhones[selectedRow!], location: cinemaLocations[selectedRow!], maxNoOfTheatre: cinemaMaxNoOfTheatres[selectedRow!])
            atc.selectedCinema = selectedCinema
        }
    }
    
}
