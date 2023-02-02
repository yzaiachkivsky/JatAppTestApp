//
//  NetworkService.swift
//  JatAppTestApp
//
//  Created by Yurii Zaiachkivskyi on 28.01.2023.
//

import UIKit
import Foundation

class NetworkService: NSObject {
    
    private let sourcesURL = URL(string: "https://imdb-api.com/en/API/Top250Movies/k_bo79tmhf")!
      
    func getTop250Movies(completion : @escaping (Movies?, Error?) -> ()){
          URLSession.shared.dataTask(with: sourcesURL) { (items, urlResponse, error) in
              if let error = error {
                             print(error.localizedDescription)
                             completion(nil,error)
                         }
              if let items = items{
                  do {
                      let jsonDecoder = JSONDecoder()
                      let movieData = try! jsonDecoder.decode(Movies.self, from: items)
                      completion(movieData, nil)
                  }
              }
          }.resume()
      }

    func fetchImage(from url: String, completion : @escaping (Data) -> ()){
        guard let imageURL = URL(string: url) else { return }
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }
            DispatchQueue.main.async {
               completion(imageData)
            }
        }
    }
}
