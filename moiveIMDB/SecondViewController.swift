//
//  SecondViewController.swift
//  moiveIMDB
//
//  Created by manukant tyagi on 29/10/21.
//

import UIKit

class SecondViewController: UIViewController {
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
    
    let alert = UIAlertController(title: nil, message: "Please Wait", preferredStyle: .alert)
    let lodingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
    
    let apiKey = "?api_key=d507293cec045151e8c4ac64583721e8"
    let movieUrlString = "https://api.themoviedb.org/3/movie/"
    let imageURL = "https://image.tmdb.org/t/p/w500"
    var data : MovieList?
    var id : Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lodingIndicator.hidesWhenStopped = true
        lodingIndicator.startAnimating()
        alert.view.addSubview(lodingIndicator)
        if let id = id {
            let url = movieUrlString + String(id) + apiKey
            movieDetailAPICalling(url: url) { (success) in
                if success{
                    let posterUrl = self.imageURL + (self.data?.backdropPath ?? "")
                    let movieImageUrl = self.imageURL + (self.data?.posterPath ?? "")
                    DispatchQueue.main.async {
                        self.movieImageView.image = self.imageAPICall(urlString: movieImageUrl) { (success) in }
                        self.posterImageView.image = self.imageAPICall(urlString: posterUrl) { (success) in
                        }
                        self.dismiss(animated: true, completion: nil)
                        self.movieNameLabel.text = self.data?.originalTitle ?? ""
                        self.overViewLabel.text = self.data?.overview
                        self.navigationItem.rightBarButtonItem?.title = self.data?.originalTitle
                    }
                   
                   
                    
                                        
                    print("success")
                }
            }
        }
       
        // Do any additional setup after loading the view.
    }
    func imageAPICall(urlString: String, completionHandler: @escaping(Bool) -> ()) -> UIImage?{
//        let image
        let url = URL(string: urlString)
        if let data = try? Data(contentsOf: url!){
            return UIImage(data: data)
        }
        return nil
    }
    func movieDetailAPICalling(url:String, completionHandler: @escaping (Bool) -> ()){
        present(alert, animated: true, completion: nil)
        let url = URL(string: url)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let data = data{
                do{
                    self.data = try JSONDecoder().decode(MovieList.self, from: data)
                    print(data)
                    completionHandler(true)
                }catch{
                    print("error in parsing of movieDetail, \(error)")
                    completionHandler(false)
                }
            }
        }
        task.resume()
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
