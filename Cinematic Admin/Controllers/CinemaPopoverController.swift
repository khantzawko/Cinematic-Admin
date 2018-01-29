//
//  CinemaPopoverController.swift
//  Cinematic Admin
//
//  Created by Khant Zaw Ko on 29/1/18.
//  Copyright © 2018 Khant Zaw Ko. All rights reserved.
//

import UIKit
import Firebase

class CinemaPopoverController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var cinemaName = String()
    var cinemaPhone = String()
    var cinemaLocation = String()
    var cinemaMaxTheatre = Int()
    var maxTheatres = [Int]()
    
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        
        for theatre in 1...10 {
            maxTheatres.append(theatre)
        }
        cinemaMaxTheatre = maxTheatres[0]
    }
    
    @IBAction func pressedCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pressedDone(_ sender: Any) {
        checkTextFields()
    }

    func checkTextFields() {
        if cinemaName.isEmpty || cinemaPhone.isEmpty || cinemaLocation.isEmpty {
            alertMessage(title: "Warning!", message: "Incomplete Textfields!")
        } else {
            putCinemaData(name: cinemaName, phone: cinemaPhone, location: cinemaLocation, maxNoOfCinema: cinemaMaxTheatre)
            dismiss(animated: true, completion: nil)
        }
    }
    
    func alertMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
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
    

    
    // pickerview functions
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 103 {
            return maxTheatres.count
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 103 {
            return String(maxTheatres[row])
        } else {
            return String()
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 103 {
            cinemaMaxTheatre = maxTheatres[row]
        }
    }
    
    //tableview functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CinemaName", for: indexPath) as! PopoverCinemaCell
            cell.cinemaNameLabel.text = "Cinema Name"
            cell.cinemaName.tag = 100
            cell.cinemaName.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
            cell.cinemaName.addTarget(self, action: #selector(textFieldShouldReturn), for: .editingDidEndOnExit)
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CinemaPhone", for: indexPath) as! PopoverCinemaCell
            cell.cinemaPhoneLabel.text = "Phone no."
            cell.cinemaPhone.tag = 101
            cell.cinemaPhone.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
            cell.cinemaPhone.addTarget(self, action: #selector(textFieldShouldReturn), for: .editingDidEndOnExit)

            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CinemaLocation", for: indexPath) as! PopoverCinemaCell
            cell.cinemaLocationLabel.text = "Location"
            cell.cinemaLocation.tag = 102
            cell.cinemaLocation.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
            cell.cinemaLocation.addTarget(self, action: #selector(textFieldShouldReturn), for: .editingDidEndOnExit)

            return cell
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CinemaMaxTheatre", for: indexPath) as! PopoverCinemaCell
            cell.cinemaMaxTheatreLabel.text = "Max no. of Theatre"
            cell.maxTheatrePickerView.tag = 103
            cell.maxTheatrePickerView.delegate = self
            cell.maxTheatrePickerView.dataSource = self
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.tag == 100 {
            cinemaName = textField.text!
        } else if textField.tag == 101 {
            cinemaPhone = textField.text!
        } else if textField.tag == 102 {
            cinemaLocation = textField.text!
        } else {
            
        }
    }
    
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
