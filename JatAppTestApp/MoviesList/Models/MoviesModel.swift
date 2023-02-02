//
//  MoviesModel.swift
//  JatAppTestApp
//
//  Created by Yurii Zaiachkivskyi on 28.01.2023.
//
import UIKit

struct Movies: Decodable {
    let items: [MovieData]
}

struct MovieData: Decodable {
    let title, rank: String
    let movieImageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case rank = "rank"
        case movieImageUrl = "image"
    }
}

struct MovieFetchedWithImage: Codable {
    var movieTitle: String?
    var movieRank: String?
    var movieImage: Data?
}
