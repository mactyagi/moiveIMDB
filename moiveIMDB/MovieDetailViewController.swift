//
//  SecondViewController.swift
//  moiveIMDB
//
//  Created by manukant tyagi on 29/10/21.
//

import UIKit
import Combine

class MovieDetailViewController: UIViewController {
    @IBOutlet weak var revenueLabel: UILabel!
    @IBOutlet weak var productionCompanyLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var productionBudgetLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var overViewLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    
    var viewModel: MovieDetailViewModel!
    var cancellables: Set<AnyCancellable> = []
    var loader = LoaderView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSubscribers()
        viewModel.fetchMovieDetail()
    }
    
    
    func setSubscribers() {
        viewModel.$movie.sink { [weak self] movie in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                revenueLabel.text = String(self.viewModel.movie?.revenue ?? 0)
                productionCompanyLabel.text = viewModel.movie?.productionCompanies.first?.name
                languageLabel.text = viewModel.movie?.originalLanguage
                genresLabel.text = viewModel.movie?.genres.first?.name
                durationLabel.text = viewModel.movie?.runtime.description
                movieNameLabel.text = viewModel.movie?.originalTitle
                overViewLabel.text = viewModel.movie?.overview
            }
        }.store(in: &cancellables)
        
        viewModel.$posterImage.sink {[weak self] image in
            DispatchQueue.main.async { [weak self] in
                self?.posterImageView.image = image
            }
            
        }.store(in: &cancellables)
        
        
        viewModel.$backdropImage.sink { image in
            DispatchQueue.main.async { [weak self] in
                self?.movieImageView.image = image
            }
        }.store(in: &cancellables)
        
        
        viewModel.$isLoading.sink { isLoading in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                isLoading ? loader.show(on: view) : loader.hide()
            }
        }.store(in: &cancellables)
        
        
        viewModel.$error.sink { error in
            DispatchQueue.main.async { [weak self] in
                if let error {
                    self?.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }.store(in: &cancellables)
    }
}
