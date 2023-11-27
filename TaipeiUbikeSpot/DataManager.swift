//
//  DataManager.swift
//  TaipeiUbikeSpot
//
//  Created by Vickcoo on 2023/11/24.
//

import Foundation

class DataManager {
    static var shared: DataManager {
        return DataManager()
    }
    
    init() { }
    
    func fetchData(urlString: String, completion: @escaping (Result<[UbikeSpot], Error>) -> ()) {
        guard let url = URL(string: urlString) else {
            completion(.failure(URLError.badURL as! Error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            
            do {
                if let data = data {
                    let response = try JSONDecoder().decode([UbikeSpot].self, from: data)
                    completion(.success(response))
                }
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
