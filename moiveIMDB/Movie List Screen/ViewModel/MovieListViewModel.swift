//
//  MovieListViewModel.swift
//  moiveIMDB
//
//  Created by manukant tyagi on 30/11/24.
//

import Foundation
import Combine

class MovieListViewModel {
    
    let networkManager: NetworkManaging
    
    @Published var isLoading = false
    @Published var movies: [Movie] = []
    @Published var error: Error?
    
    init(networkManager: NetworkManaging) {
        self.networkManager = networkManager
    }
    
    func getListOfMovie() {
        isLoading = true
        networkManager.fetchData(from: .discover) { [weak self] (result: Result<MovieListResponse, NetworkError>)  in
            guard let self else { return }
            isLoading = false
            switch result {
            case .success(let model):
                movies = model.results
                print(movies)
            case .failure(let error):
                print(error.localizedDescription)
                self.error = error
            }
        }
    }
}
