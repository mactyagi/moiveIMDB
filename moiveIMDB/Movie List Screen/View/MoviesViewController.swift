//
//  ViewController.swift
//  moiveIMDB
//
//  Created by manukant tyagi on 29/10/21.
//

import UIKit
import Combine

class MoviesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: MovieListViewModel = MovieListViewModel(networkManager: NetworkManager())
    var cancellables: Set<AnyCancellable> = []
    var loader = LoaderView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSubscribers()
        tableViewSetup()
        viewModel.getListOfMovie()
        
    }
    
    
    func tableViewSetup() {
        tableView.register(UINib(nibName: MovieTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: MovieTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    func setSubscribers() {
        viewModel.$isLoading.sink { [weak self] isLoading in
            guard let self else { return }
            isLoading ? loader.show(on: view) : loader.hide()
        }.store(in: &cancellables)
        
        viewModel.$movies.sink { [weak self] movies in
            DispatchQueue.main.async {
                guard let self else { return }
                self.tableView.reloadData()
            }
        }.store(in: &cancellables)
        
        viewModel.$error.sink { [weak self] error in
            if let error {
                DispatchQueue.main.async {
                    guard let self else { return }
                    self.showAlert(title: "Error!", message: error.localizedDescription)
                }
            }
        }.store(in: &cancellables)
    }
}

extension MoviesViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.movies.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as! MovieTableViewCell
        cell.setup(movie: viewModel.movies[indexPath.row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        callMovieDetailVC(movieId: viewModel.movies[indexPath.row].id)
    }
    
    
    func callMovieDetailVC(movieId: Int) {
        let movieViewModel = MovieDetailViewModel(movieId: movieId, networkManager: viewModel.networkManager)
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        vc.viewModel = movieViewModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
}




