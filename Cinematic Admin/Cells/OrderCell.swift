//
//  OrderCell.swift
//  Cinematic Admin
//
//  Created by Khant Zaw Ko on 11/2/18.
//  Copyright © 2018 Khant Zaw Ko. All rights reserved.
//

import UIKit

class OrderCell: UITableViewCell {
    
    let screenSize = UIScreen.main.bounds
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var movieImage: UIImageView!
    var movieName: UILabel!
    var ticketInfo: UILabel!
    var movieDate: UILabel!
    var purchasedDate: UILabel!
    var orderEmail: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.accessoryType = .none
        
        let movieImageWidth: CGFloat = 80
        let movieImageHeight: CGFloat = 120
        let movieImageOffsetX: CGFloat = 15
        let movieImageOffsetY: CGFloat = 8
        
        movieImage = UIImageView()
        movieImage.frame = CGRect(x: movieImageOffsetX, y: movieImageOffsetY, width: movieImageWidth, height: movieImageHeight)
        movieImage.layer.cornerRadius = 5
        movieImage.clipsToBounds = true
        movieImage.image = UIImage(named: "loading")
        contentView.addSubview(movieImage)
        
        let movieNameWidth: CGFloat = screenWidth - (movieImage.frame.maxX + (2 * movieImageOffsetX))
        let movieNameHeight: CGFloat = 25
        let movieNameOffsetX: CGFloat = movieImage.frame.maxX + movieImageOffsetX
        let movieNameOffsetY: CGFloat = movieImageOffsetY
        
        movieName = UILabel()
        movieName.frame = CGRect(x: movieNameOffsetX, y: movieNameOffsetY, width: movieNameWidth, height: movieNameHeight)
        movieName.font = UIFont.boldSystemFont(ofSize: 18)
        contentView.addSubview(movieName)
        
        let ticketInfoWidth: CGFloat = screenWidth - (movieImage.frame.maxX + (2 * movieImageOffsetX))
        let ticketInfoHeight: CGFloat = 20
        let ticketInfoOffsetX: CGFloat = movieImage.frame.maxX + movieImageOffsetX
        let ticketInfoOffsetY: CGFloat = movieName.frame.maxY + 4
        
        ticketInfo = UILabel()
        ticketInfo.frame = CGRect(x: ticketInfoOffsetX, y: ticketInfoOffsetY, width: ticketInfoWidth, height: ticketInfoHeight)
        ticketInfo.font = UIFont.italicSystemFont(ofSize: 14)
        contentView.addSubview(ticketInfo)
        
        
        let movieDateWidth: CGFloat = screenWidth - (movieImage.frame.maxX + (2 * movieImageOffsetX))
        let movieDateHeight: CGFloat = 20
        let movieDateOffsetX: CGFloat = movieImage.frame.maxX + movieImageOffsetX
        let movieDateOffsetY: CGFloat = ticketInfo.frame.maxY + 4
        
        movieDate = UILabel()
        movieDate.frame = CGRect(x: movieDateOffsetX, y: movieDateOffsetY, width: movieDateWidth, height: movieDateHeight)
        movieDate.font = UIFont.italicSystemFont(ofSize: 14)
        contentView.addSubview(movieDate)
        
        let purchasedDateWidth: CGFloat = screenWidth - (movieImage.frame.maxX + (2 * movieImageOffsetX))
        let purchasedDateHeight: CGFloat = 20
        let purchasedDateOffsetX: CGFloat = movieImage.frame.maxX + movieImageOffsetX
        let purchasedDateOffsetY: CGFloat = movieDate.frame.maxY + 4
        
        purchasedDate = UILabel()
        purchasedDate.frame = CGRect(x: purchasedDateOffsetX, y: purchasedDateOffsetY, width: purchasedDateWidth, height: purchasedDateHeight)
        purchasedDate.font = UIFont.italicSystemFont(ofSize: 14)
        contentView.addSubview(purchasedDate)
        
        let orderEmailWidth: CGFloat = screenWidth - (movieImage.frame.maxX + (2 * movieImageOffsetX))
        let orderEmailHeight: CGFloat = 20
        let orderEmailOffsetX: CGFloat = movieImage.frame.maxX + movieImageOffsetX
        let orderEmailOffsetY: CGFloat = purchasedDate.frame.maxY + 4
        
        orderEmail = UILabel()
        orderEmail.frame = CGRect(x: orderEmailOffsetX, y: orderEmailOffsetY, width: orderEmailWidth, height: orderEmailHeight)
        orderEmail.font = UIFont.italicSystemFont(ofSize: 14)
        contentView.addSubview(orderEmail)
    }
}


