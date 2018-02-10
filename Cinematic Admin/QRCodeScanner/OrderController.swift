//
//  OrderController.swift
//  BarcodeScanner
//
//  Created by Mikheil Gotiashvili on 7/29/17.
//  Copyright © 2017 Mikheil Gotiashvili. All rights reserved.
//

import UIKit
import Firebase

class OrderController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var scannedCode: String?
    var ref: DatabaseReference!
    
    var movies = [Movie]()
    var cinemas = [Cinema]()
    var receipts = [Receipt]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getReceiptData(receiptCode: scannedCode!)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = OrderCell.init(style: .default, reuseIdentifier: "OrderCell")
        cell.movieName.text = movies[indexPath.row].name
        cell.ticketInfo.text = ("\(cinemas[indexPath.row].name!) - \(receipts[indexPath.row].ticketInfo!)")
        cell.movieDate.text = receipts[indexPath.row].movieTime
        cell.purchasedDate.text = receipts[indexPath.row].purchasedDate
        cell.orderEmail.text = receipts[indexPath.row].email
        return cell
    }
    
    @IBAction func pressedClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func getReceiptData(receiptCode: String) {
        ref = Database.database().reference().child("receipts")
        
        let movieRef = Database.database().reference().child("movies")
        let cinemaRef = Database.database().reference().child("cinema")
        
        ref.queryOrdered(byChild: "receiptCode").queryEqual(toValue: receiptCode).observe(DataEventType.childAdded, with: {(snapshot) in
            var postDict = snapshot.value as! [String : AnyObject]
            
            if let receiptAmount = postDict["amount"],
                let receiptEmail = postDict["email"],
                let receiptPurchasedDate = postDict["purchasedDate"],
                let receiptCode = postDict["receiptCode"],
                let receiptTicketInfo = postDict["ticketInfo"],
                let movieTime = postDict["movieTime"],
                let movieKey = postDict["movieID"],
                let cinemaKey = postDict["cinemaID"] {
                
                self.receipts.append(Receipt(key: snapshot.key,
                                             amount: receiptAmount as! Int,
                                             email: receiptEmail as! String,
                                             purchasedDate: receiptPurchasedDate as! String,
                                             receiptCode: receiptCode as! String,
                                             ticketInfo: receiptTicketInfo as! String,
                                             movieTime: movieTime as! String,
                                             movieID: movieKey as! String,
                                             cinemaID: cinemaKey as! String))
                
                cinemaRef.child(cinemaKey as! String).observe(DataEventType.value, with: {(cSnap) in
                    var cinemaDict = cSnap.value as! [String:AnyObject]
                    if  let cinemaName = cinemaDict["name"],
                        let cinemaLocation = cinemaDict["location"],
                        let cinemaPhone = cinemaDict["phone"],
                        let cinemaMaxNo = cinemaDict["maxNo"]{
                        let cinema = Cinema(key: (cinemaKey as! String),
                                            name: (cinemaName as! String),
                                            location: (cinemaLocation as! String),
                                            phone: (cinemaPhone as! String),
                                            maxNoOfTheatre: (cinemaMaxNo as! Int))
                        self.cinemas.append(cinema)
                    }
                })
                
                movieRef.child(movieKey as! String).observe(DataEventType.value, with: {(mSnap) in
                    var movieDict = mSnap.value as! [String:AnyObject]
                    if let movieName = movieDict["name"],
                        let movieImage = movieDict["image"],
                        let movieStartDate = movieDict["startDate"],
                        let movieEndDate = movieDict["endDate"] {
                        let movie = Movie(key: snapshot.key, name: (movieName as! String), image: (movieImage as! String), startDate: (movieStartDate as! String), endDate: (movieEndDate as! String), weeksInTheatre: 0)
                        self.movies.append(movie)
                    }
                    self.tableView.reloadData()
                })
                print(self.receipts)
            }
        })
    }
}
