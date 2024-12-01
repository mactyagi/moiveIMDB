//
//  NetworkManager.swift
//  moiveIMDB
//
//  Created by manukant tyagi on 30/11/24.
//

import Foundation
import UIKit


protocol NetworkManaging {
    func fetchData<T: Codable>(from endPoint: EndPoints, completion: @escaping (Result<T, NetworkError>) -> Void)
}


class NetworkManager: NetworkManaging {
    
    private let baseUrl = "https://api.themoviedb.org/3/"
    private let apiKey = "d507293cec045151e8c4ac64583721e8"
    static let posterUrl = "https://image.tmdb.org/t/p/w200"
    
    
    func fetchData<T: Codable>(from endPoint: EndPoints, completion: @escaping (Result<T, NetworkError>) -> Void) {
        let url = baseUrl + endPoint.rawValue + "?api_key=" + apiKey
        let urlRequest = URLRequest(url: URL(string: url)!)
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
            if let error {
                completion(.failure(.apiError))
            }
            
            guard let data else {
                completion(.failure(.invalidData))
               return
            }
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            let decoder = JSONDecoder()
            do{
                let decodedData = try decoder.decode(T.self, from: data)
                completion(.success(decodedData))
            }catch {
                completion(.failure(.decodingError))
            }
            
        }.resume()
    }
}



enum EndPoints {
    case discover
    case movieDetails(Int)
    
    var rawValue: String {
        switch self {
        case .discover:
            return "discover/movie"
        case .movieDetails(let id):
            return "movie/\(id)"
        }
    }
}


enum NetworkError: Error {
    case invalidResponse
    case decodingError
    case apiError
    case invalidData
}
