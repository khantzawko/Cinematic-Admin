//
//  TheatrePopoverController.swift
//  Cinematic Admin
//
//  Created by Khant Zaw Ko on 30/1/18.
//  Copyright © 2018 Khant Zaw Ko. All rights reserved.
//

import UIKit
import Firebase

class TheatrePopoverController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UIPopoverPresentationControllerDelegate  {

    @IBOutlet weak var tableView: UITableView!
    var theatreTypeKeys = [String]()
    var theatreTypeNames = [String]()
    var theatreTypescripts = [String]()
    
    var selectedCinema = Cinema()
    
    var theatreName = String()
    var selectedTheatreTypeKey = String()

    var selectedShowtimes: Date!
    var showtimes = [String]()
    var dateTimeArray = [Date]()
    
    var collectionView: UICollectionView!
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        getTheatreTypeData()
    }

    func getTheatreTypeData() {
        ref = Database.database().reference().child("theatretypes")
        ref.observe(DataEventType.childAdded, with: {(snapshot) in
            
            var theatreTypeDict = snapshot.value as! [String : AnyObject]
            
            if  let theatreTypeName = theatreTypeDict["name"],
                let theatreTypescript = theatreTypeDict["typescript"]{
                
                self.theatreTypeKeys.append(snapshot.key)
                self.theatreTypeNames.append(theatreTypeName as! String)
                self.theatreTypescripts.append(theatreTypescript as! String)
            }
            self.tableView.reloadData()
        })
    }
    
    @IBAction func pressedCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pressedDone(_ sender: Any) {
        checkTextFields()
        dismiss(animated: true, completion: nil)
    }
    
    func checkTextFields() {
        if theatreTypeKeys.isEmpty || theatreName.isEmpty || showtimes.isEmpty {
            print(theatreTypeKeys, theatreName, showtimes)
            alertMessage(title: "Warning!", message: "Incomplete Textfields!")
        } else {
            if selectedTheatreTypeKey.isEmpty {
                selectedTheatreTypeKey = theatreTypeKeys[0]
            }
            
            putTheatreData(name: theatreName, showtimes: showtimes, theatreTypeID: selectedTheatreTypeKey)
            dismiss(animated: true, completion: nil)
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func alertMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func putTheatreData(name: String, showtimes: [String], theatreTypeID: String) {
        ref = Database.database().reference()
        let key = ref.childByAutoId().key

        let theatrePath = "theatres/\(key)"
        let theatrePost = ["name": name,
                           "theatreTypeID": theatreTypeID,
                           "showtimes": showtimes,
                           "cinemaID": selectedCinema.key!] as [String : Any]

        let cinemaPath = "cinema/\(selectedCinema.key!)/\(theatrePath)"
        let cinemaPost = ["theatreID": key] as [String : Any]

        let updateData = [theatrePath:theatrePost,
                          cinemaPath:cinemaPost]
        self.ref.updateChildValues(updateData)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TheatreName", for: indexPath) as! PopoverTheatreCell
            cell.theatreNameLabel.text = "Theatre Name"
            cell.theatreName.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TheatreType", for: indexPath) as! PopoverTheatreCell
            cell.theatreTypeLabel.text = "Theatre Type"
            cell.theatrePickerView.delegate = self
            cell.theatrePickerView.dataSource = self
            cell.theatrePickerView.tag = 101
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Showtimes", for: indexPath) as! PopoverTheatreCell
            cell.showtimesLabel.text = "Showtimes"
            cell.addShowtimes.layer.cornerRadius = 10
            cell.addShowtimes.addTarget(self, action: #selector(pressedAddShowtimes), for: UIControlEvents.touchUpInside)
            collectionView = cell.collectionView
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        theatreName = textField.text!
    }
    
    @objc func pressedAddShowtimes(_ button: UIButton) {
        let popoverContentController = UIViewController()
        popoverContentController.view.backgroundColor = .lightGray
        popoverContentController.preferredContentSize = CGSize(width: 320, height: 370)
        popoverContentController.modalPresentationStyle = .popover
        
        let showtimesLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        showtimesLabel.textAlignment = .center
        showtimesLabel.text = "Select time"
        showtimesLabel.textColor = .black
        showtimesLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 50, width: 320, height: 250))
        datePicker.datePickerMode = .time
        datePicker.minuteInterval = 5
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        
        let addButton = UIButton(frame: CGRect(x: 10, y: 310, width: 300, height: 50))
        addButton.setTitle("Add", for: .normal)
        addButton.backgroundColor = .orange
        addButton.layer.cornerRadius = 10
        addButton.addTarget(self, action: #selector(addShowtimes), for: .touchUpInside)
        
        popoverContentController.view.addSubview(showtimesLabel)
        popoverContentController.view.addSubview(datePicker)
        popoverContentController.view.addSubview(addButton)
        
        let popOver = popoverContentController.popoverPresentationController
        popOver?.delegate = self
        self.present(popoverContentController, animated: true, completion: nil)
        popOver?.permittedArrowDirections = .init(rawValue: 0)
        popOver?.sourceView = self.view
        
        let rect = CGRect(
            origin: CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2),
            size: CGSize(width: 1, height: 1)
        )
        popOver?.sourceRect = rect
    }
    
    @objc func datePickerValueChanged(_ datepicker: UIDatePicker) {
        selectedShowtimes = datepicker.date
    }
    
    @objc func addShowtimes(_ button: UIButton) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.amSymbol = "am"
        formatter.pmSymbol = "pm"
        
        if selectedShowtimes != nil && !showtimes.contains(formatter.string(from: selectedShowtimes)) {
            dateTimeArray.append(selectedShowtimes)
            orderShowtimes()
            collectionView.reloadData()
        } else {
            print("nothing to add or adding the same value again!")
        }
        
        selectedShowtimes = nil
        self.dismiss(animated: true, completion: nil)
    }
    
    func orderShowtimes() {
        
        var dateTimeStringArray = [String]()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.amSymbol = "am"
        formatter.pmSymbol = "pm"
        
        dateTimeArray.sort(){$0 < $1}
        
        for datetime in dateTimeArray {
            let timeString = formatter.string(from: datetime)
            dateTimeStringArray.append(timeString)
        }
        
        showtimes = dateTimeStringArray
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    
    // pickerview functions
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return theatreTypeNames[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return theatreTypeNames.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 101 {
            selectedTheatreTypeKey = theatreTypeKeys[row]
        } else {
            
        }
    }

    
    // collectionView functions
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return showtimes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShowtimesCell", for: indexPath) as! ShowtimesCell
        cell.showtimesLabel.text = showtimes[indexPath.row]
        cell.removeShowtimes.tag = indexPath.row
        cell.removeShowtimes.layer.cornerRadius = 10
        cell.removeShowtimes.addTarget(self, action: #selector(removeShowtimes), for: .touchUpInside)
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 2
        return cell
    }
    
    @objc func removeShowtimes(_ button: UIButton) {
        //showtimes = showtimes.filter() {$0 != showtimes[button.tag]}
        showtimes.remove(at: button.tag)
        dateTimeArray.remove(at: button.tag)        
        collectionView.reloadData()
    }
}
