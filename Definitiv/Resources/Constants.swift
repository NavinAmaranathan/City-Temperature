//
//  Constants.swift
//  Definitiv
//
//  Created by Navi on 19/07/22.
//

import Foundation

enum Constants: String {
    case ApiEndPoint = "https://api.openweathermap.org/data/2.5/weather?q="
    case ApiKey = "97904e638cd41e9c965871c67d11f7b2"
}

enum APIError: Error {
    case invalidData
    case invalidHttpResponse
    case parseFailure
}
