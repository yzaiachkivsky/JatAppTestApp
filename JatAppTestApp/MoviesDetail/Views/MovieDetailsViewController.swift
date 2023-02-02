//
//  MovieDetailsViewController.swift
//  JatAppTestApp
//
//  Created by Yurii Zaiachkivskyi on 31.01.2023.
//

import UIKit
import Combine

class MovieDetailsViewController: UIViewController {
    
    var movieModel : MovieFetchedWithImage?
    lazy var movieDetailsViewModel: MovieDetailViewModel = {
        let viewModel = MovieDetailViewModel()
        return viewModel
    }()
    @IBOutlet weak var occuranceLabel: UILabel!
    @IBOutlet weak var occuredCharactersTextView: UITextView!
    private (set) var occuranceData: [String] = []
    private var cancellables: Set<AnyCancellable> = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let movieTitle = movieModel?.movieTitle {
            self.title = movieTitle
            self.setOccuranceLabelFullName(movieTitle: movieTitle)
            self.callToViewModelForUIUpdate()
        }
    }
    
    // MARK: Initializing functions
    
    private func callToViewModelForUIUpdate() {
        self.movieDetailsViewModel.setMovieModel(movie: movieModel)
        self.movieDetailsViewModel.$occuranceData.sink { [weak self] _ in
            self?.updateUI()
        }.store(in: &cancellables)
    }
    
    private func updateUI() {
        self.occuranceData = self.movieDetailsViewModel.occuranceData
        self.setOccuranceValuesFromArray(array: occuranceData)
    }
    
    // MARK: Setting Values to View
    
    private func setOccuranceLabelFullName(movieTitle: String) {
        self.occuranceLabel.text = "Character Occurance in movie title: \(movieTitle)"
    }
    
    private func setOccuranceValuesFromArray(array: [String]) {
        let occuranceString = array.joined(separator: "\n\n")
        occuredCharactersTextView.text = occuranceString
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
