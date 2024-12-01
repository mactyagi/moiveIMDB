//
//  MoviewDetailViewModel.swift
//  moiveIMDB
//
//  Created by manukant tyagi on 30/11/24.
//

import Foundation
import Combine
import UIKit

class MovieDetailViewModel {
    
    var movieId: Int
    var networkManager: NetworkManaging
    
    @Published var movie: MovieModel?
    @Published var posterImage: UIImage?
    @Published var backdropImage: UIImage?
    @Published var isLoading: Bool = false
    @Published var error: Error?
    
    init(movieId: Int, networkManager: NetworkManaging) {
        self.movieId = movieId
        self.networkManager = networkManager
        print(movieId)
    }
    
    func fetchMovieDetail() {
        isLoading = true
        networkManager.fetchData(from: .movieDetails(movieId)) { [weak self] (result: Result<MovieModel, NetworkError>) in
            guard let self else { return }
            self.isLoading = false
            switch result {
            case .success(let movie):
                self.movie = movie
                self.getPosterImage(urlString: NetworkManager.posterUrl + movie.posterPath)
                self.getBackdropImage(urlString: NetworkManager.posterUrl + movie.backdropPath)
                
            case .failure(let error):
                print(error)
                self.error = error
            }
        }
    }
    
    
    func getPosterImage(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        ImageDownloader.downloadImage(from: url) { [weak self] image in
            self?.posterImage = image
        }
    }
    
    func getBackdropImage(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        ImageDownloader.downloadImage(from: url) { [weak self] image in
            self?.backdropImage = image
        }
    }
}
