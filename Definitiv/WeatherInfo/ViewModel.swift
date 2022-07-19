//
//  ViewModel.swift
//  Definitiv
//
//  Created by Navi on 23/02/22.
//

import Foundation

typealias Temperatures = [String: String]?

protocol ViewModelData {
    func fetchTemperatures(cityName: String, completionHandler: @escaping (Result<Temperatures, Error>)-> Void)
}

class ViewModel: ViewModelData {
    var session: URLSession
    
    // MARK: - Initialiser
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    // MARK: - Public functions
    // Fetches the response from API
    /// - Parameters:
    /// - cityName: Passed to API from the user input
    /// - completionHandler: Callback on API call completion
    func fetchTemperatures(cityName: String, completionHandler: @escaping (Result<Temperatures, Error>)-> Void) {
        
        let urlString = Constants.ApiEndPoint.rawValue+cityName+"&appid="+Constants.ApiKey.rawValue
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) {[weak self] data, response, error in
            // Check if data is nil
            guard let data = data else {
                completionHandler(.failure(APIError.invalidData))
                return
            }
            // Check is error is present
            if let error = error {
                print("Error in fetching\(error.localizedDescription)")
                completionHandler(.failure(error))
            }  else {
                // Validate success response
                guard let _ = response as? HTTPURLResponse else {
                    completionHandler(.failure(APIError.invalidHttpResponse))
                    return
                }
                // Decode response from data
                guard let response = try? JSONDecoder().decode(Response.self, from: data),
                      let temperatures = self?.getTemperatures(response: response)
                else {
                    completionHandler(.failure(APIError.parseFailure))
                    return
                }
                
                // Return back the parsed data
                completionHandler(.success(temperatures))
            }
        }
        task.resume()
    }
    
    // MARK: - Private functions
    private func getTemperatures(response: Response) -> Temperatures {
        return [
            "minValue": response.main.tempMin.stringValue,
            "maxValue": response.main.tempMax.stringValue
        ]
    }
}
