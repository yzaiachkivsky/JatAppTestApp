//
//  MovieDetailViewModel.swift
//  JatAppTestApp
//
//  Created by Yurii Zaiachkivskyi on 31.01.2023.
//

import UIKit
import Foundation
import Combine

class MovieDetailViewModel: NSObject, ObservableObject {
    
    var movieModel : MovieFetchedWithImage?
    @Published var occuranceData: [String] = [] 
    
    // MARK: Setup Functions
    
    public func setMovieModel(movie: MovieFetchedWithImage?) {
        self.movieModel = movie
        self.setupDataOperations()
    }
    
    private func setupDataOperations() {
        self.calculateMovieOccurances()
    }
    
    // MARK: Calculation Functions
    
    private func calculateMovieOccurances() {
        if let title = movieModel?.movieTitle {
            self.occuranceData = self.parseNameToFindLettersCount(movieName: title)
        }
    }
    
    public func parseNameToFindLettersCount(movieName: String) -> [String] {
        var occuranceDictionary: [String : Int] = [:]
        for i in movieName.lowercased() {
            var count = 1
            if occuranceDictionary[String(i)] == nil {
                occuranceDictionary[String(i)] = count
            } else {
                count = occuranceDictionary[String(i)] ?? 0
                count += 1
                occuranceDictionary[String(i)] = count
            }
        }
        let filteredDictionary = occuranceDictionary.filter( {!$0.key.isEmpty} )
        let occuranceString = filteredDictionary.map { "\($0)=\($1)"}
                                                .joined(separator: "+")
        let occuranceArray = occuranceString.components(separatedBy: "+")
        let filteredForWhiteSpacesArray = occuranceArray.filter { !$0.contains(" ") }
        return filteredForWhiteSpacesArray.sorted()
    }

}
