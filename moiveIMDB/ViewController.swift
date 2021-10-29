//
//  ViewController.swift
//  moiveIMDB
//
//  Created by manukant tyagi on 29/10/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    let urlString = "https://api.themoviedb.org/3/discover/movie?api_key=d507293cec045151e8c4ac64583721e8"
    
    let posterUrl = "https://image.tmdb.org/t/p/w200"
    
    let alert = UIAlertController(title: nil, message: "Please Wait", preferredStyle: .alert)
    let lodingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
    var data: Welcome? = nil
    var imageArray: [UIImage] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lodingIndicator.hidesWhenStopped = true
        lodingIndicator.startAnimating()
        alert.view.addSubview(lodingIndicator)
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.estimatedRowHeight = 100
        movieListAPICalling(url: urlString) { (success) in
            if success{
                
                self.callingImageApi { (success) in
                    if success{
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
               
               
                print("success")
            }
        }
    }
    func callingImageApi(completionHandler: @escaping(Bool) -> ()){
        if let results = self.data?.results{
            for i in results{
                let string = self.posterUrl + (i.posterPath)
                let url = URL(string: string)
                if let data = try? Data(contentsOf: url!){
                    self.imageArray.append(UIImage(data: data)!)
                }
            }
            
        }
        completionHandler(true)
    }
    
    func movieListAPICalling(url: String, completionHandler: @escaping(Bool)-> ()){
        present(alert, animated: true, completion: nil)
        let url = URL(string: url)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, eror) in
//            print(response)
            if let data = data{
                do {
                    self.data = try JSONDecoder().decode(Welcome.self, from: data)
                    completionHandler(true)
                    print(data)
                }
                catch{
                    print(error)
                    completionHandler(false)
                }
            }
            completionHandler(true)
            
        }
        

        task.resume()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        data?.results.count ?? 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
        
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! tableViewCell
        if !imageArray.isEmpty {
            cell.movieImageView.image = imageArray[indexPath.section]
        }
        
        cell.mainLabel.text = self.data?.results[indexPath.section].title
        cell.dateLabel.text = self.data?.results[indexPath.section].releaseDate
        cell.overViewLabel.text = self.data?.results[indexPath.section].overview
//        cell.textLabel?.text = "dgf"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "secondViewController") as! SecondViewController
        vc.id = data?.results[indexPath.row].id
        self.navigationController?.pushViewController(vc, animated: true)
//        print(id)
//        if let id = id {
//            let url = movieUrlString + String(id) + apiKey
//            movieDetailAPICalling(url: url) { (success) in
//                if success{
//                    print("success")
//                }
//            }
//        }
        
    }
    
    
}
class tableViewCell: UITableViewCell{
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var mainLabel: UILabel!
    
    @IBOutlet weak var overViewLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        overViewLabel.sizeToFit()
        overViewLabel.lineBreakMode = .byWordWrapping
        overViewLabel.numberOfLines = 0
    }
}

