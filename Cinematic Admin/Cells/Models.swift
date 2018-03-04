//
//  Movie.swift
//  Cinematic Admin
//
//  Created by Khant Zaw Ko on 26/1/18.
//  Copyright © 2018 Khant Zaw Ko. All rights reserved.
//

import UIKit

struct Movie {
    var key: String?
    var name: String?
    var image: String?
    var startDate: String?
    var endDate: String?
    var weeksInTheatre: Int?
}

struct Cinema {
    var key: String?
    var name: String?
    var location: String?
    var phone: String?
    var maxNoOfTheatre: Int?
}

struct Theatre {
    var key: String?
    var name: String?
    var showtimes: [String]?
    var type: String?
}

struct TheatreType {
    var key: String?
    var name: String?
    var typescript: String?
}

struct Receipt {
    var key: String!
    var amount: Int!
    var email: String!
    var purchasedDate: String!
    var receiptCode: String!
    var ticketInfo: String!
    var seatInfo: String!
    var movieTime: String!
    var movieID: String!
    var cinemaID: String!
}
