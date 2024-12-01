//
//  MovieTableViewCell.swift
//  moiveIMDB
//
//  Created by manukant tyagi on 30/11/24.
//

import Foundation
import UIKit

class MovieTableViewCell: UITableViewCell{
    static let identifier = "MovieTableViewCell"
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var mainLabel: UILabel!
    var loader = LoaderView()
    
    @IBOutlet weak var overViewLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        overViewLabel.sizeToFit()
        overViewLabel.lineBreakMode = .byWordWrapping
        overViewLabel.numberOfLines = 0
        
    }
    
    override func prepareForReuse() {
        movieImageView.image = UIImage(named: "No-image-found")
        loader.hide()
    }
    
    func setup(movie: Movie) {
        mainLabel.text = movie.title
        dateLabel.text = movie.releaseDate
        overViewLabel.text = movie.overview
        loader.show(on: movieImageView)
        guard let url = URL(string: NetworkManager.posterUrl + movie.posterPath) else { return }
        ImageDownloader.downloadImage(from: url, completion: { [weak self] image in
            self?.loader.hide()
            if let image {
                DispatchQueue.main.async {
                    self?.movieImageView.image = image
                }
            }else {
                self?.movieImageView.image = UIImage(named: "No-image-found")
            }
        })
    }
}
