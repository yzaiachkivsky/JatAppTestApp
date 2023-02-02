//
//  MoviesListViewController.swift
//  JatAppTestApp
//
//  Created by Yurii Zaiachkivskyi on 27.01.2023.
//

import UIKit
import Combine

class MoviesListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var moviesListCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    lazy var moviesListViewModel :  MoviesListViewModel = {
        let viewModel = MoviesListViewModel()
        return viewModel
    }()

    private(set) var movies : [MovieFetchedWithImage]?
    private var searchMoviesArray : [MovieFetchedWithImage]?
    private(set) var selectedMovie : MovieFetchedWithImage?
    private let refreshControl = UIRefreshControl()
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Top 10 IMDB"
        self.moviesListCollectionView.delegate = self
        self.moviesListCollectionView.dataSource = self
        
        self.startDataSetup()
        // Do any additional setup after loading the view.
    }
    
    // MARK: Setup Functions
    
    private func startDataSetup() {
        self.setupRefreshControl()
        self.setupLoadingBar()
        self.configureCollectionFlowLayout()
        self.callToViewModelForUIUpdate()
    }
    
    private func setupRefreshControl() {
           refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
           moviesListCollectionView.alwaysBounceVertical = true
           moviesListCollectionView.refreshControl = refreshControl
    }
  
    @objc private func didPullToRefresh(_ sender: Any) {
        self.callToViewModelForUIUpdate()
        refreshControl.endRefreshing()
    }
    
    private func setupLoadingBar() {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    private func configureCollectionFlowLayout() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        moviesListCollectionView.collectionViewLayout = layout
    }
    
    // MARK: Call ViewModel for updates and updating user interface
    
    private func callToViewModelForUIUpdate() {
        self.moviesListViewModel = MoviesListViewModel()
        self.moviesListViewModel.$movies.sink { [weak self] _ in
            self?.movies = self?.moviesListViewModel.movies
            self?.updateUI()
        }.store(in: &cancellables)
    }
    
    private func updateUI() {
        self.movies = self.moviesListViewModel.movies
        self.searchMoviesArray = self.movies
        self.dismiss(animated: false, completion: nil)
        self.moviesListCollectionView.reloadData()
    }
    
    // MARK: Collection View Delegate functions
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let movies = self.searchMoviesArray {
            return movies.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath as IndexPath) as! MovieCollectionViewCell
        if self.searchMoviesArray != nil {
            cell.movieNameLabel.text = self.searchMoviesArray?[indexPath.row].movieTitle
            cell.movieRankLabel.text = self.searchMoviesArray?[indexPath.row].movieRank
            cell.movieImageView.image = UIImage(data: self.searchMoviesArray?[indexPath.row].movieImage ?? Data())
        }
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         return CGSize(width: collectionView.frame.width, height: collectionView.frame.width)
     }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedMovie = self.searchMoviesArray?[indexPath.row]
        self.performSegue(withIdentifier: "openMovieDetails", sender: self)
    }
    
    // MARK: Search Bar Delegate 
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchMoviesArray?.removeAll()
        guard let movies = movies else { return }
        
        self.searchMoviesArray = movies.filter { MovieFetchedWithImage -> Bool in
            return MovieFetchedWithImage.movieTitle?.contains(searchText) ?? false
        }
            
        if (searchBar.text!.isEmpty) {
            self.searchMoviesArray = self.movies
        }
        self.moviesListCollectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.searchMoviesArray = self.movies
        searchBar.endEditing(true)
        self.moviesListCollectionView.reloadData()

      }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "openMovieDetails" {
            if let destinationVC = segue.destination as? MovieDetailsViewController {
                destinationVC.movieModel = self.selectedMovie
            }
        }
    }

}




