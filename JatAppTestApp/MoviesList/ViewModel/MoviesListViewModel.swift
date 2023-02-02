//
//  MoviesListViewModel.swift
//  JatAppTestApp
//
//  Created by Yurii Zaiachkivskyi on 30.01.2023.
//

import UIKit
import Foundation
import Combine

class MoviesListViewModel: NSObject {
    
    private var networkService : NetworkService!
    private(set) var movieData : [MovieData]?
    @Published var movies : [MovieFetchedWithImage]?
    
    override init() {
        super.init()
        self.networkService =  NetworkService()
        self.getDataFromCacheIfAvailable()
            
    }
    
    // MARK: Getting Data from local cache

    private func getDataFromCacheIfAvailable() {
        if let cachedMovies = UserDefaults.standard.object(forKey: "MoviesCache") {
            movies = try? JSONDecoder().decode([MovieFetchedWithImage].self, from: cachedMovies as! Data)
        } else {
            fetchMoviesData()
        }
    }
    
    // MARK: Calls to fetch data and create models
    
    private func fetchMoviesData() {
        DispatchQueue.global().async {
            self.networkService.getTop250Movies { movieData, error  in
                DispatchQueue.main.async {
                    if let movieData {
                        self.movieData = Array(movieData.items.prefix(10))
                        self.movies = self.fetchImagesAndCreateCachedModels(fetchedArray: self.movieData)
                    }
                    else {
                        print(error?.localizedDescription ?? "Unknown error")
                    }
                }
            }
        }
    }
    
    private func fetchImagesAndCreateCachedModels(fetchedArray: [MovieData]?) -> [MovieFetchedWithImage] {
        guard let fetched = fetchedArray else { return [] }
        var fetchedMovies = [MovieFetchedWithImage](repeating: MovieFetchedWithImage(), count: fetched.count)
        for i in 0..<fetched.count {
            fetchedMovies[i].movieTitle = fetched[i].title
            fetchedMovies[i].movieRank = "Rank:\(fetched[i].rank)"
            DispatchQueue.global().async {
                self.networkService.fetchImage(from: fetched[i].movieImageUrl) { (image) in
                    DispatchQueue.main.async {
                        self.movies?[i].movieImage = image
                        self.checkForAllDataLoaded()
                    }
                }
            }
        }
        return fetchedMovies
    }
    
    private func checkForAllDataLoaded() {
        if let movies = movies {
            let filtered = movies.filter { $0.movieImage != nil }
            if filtered.count == movies.count {
                self.movies = filtered
                if let movies = self.movies {
                    let encoded = try? JSONEncoder().encode(movies)
                    UserDefaults.standard.set(encoded, forKey: "MoviesCache")
                }
            }
        }
    }
}
