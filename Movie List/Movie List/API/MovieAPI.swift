//
//  MovieAPI.swift
//  Movie List
//
//  Created by Chad Olsen on 9/25/23.
//  Copyright © 2023 colsen. All rights reserved.
//

import UIKit

struct MovieAPI {
    
    func getMovieList(completion: @escaping ([Movie]) -> Void) {
        let headers = [
          "accept": "application/json",
          "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmNzllYTZhZTBhNjQ3OTY2YTVmN2FkOGJmYzU4OTY1NCIsInN1YiI6IjY1MTFjMGIwMzQ0YThlMDk2Zjg1Y2E3YSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ._3ZwGjxbOAesJ6kEompdNDvg74lRZABLy0NG0FqsCE8"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?language=en-US&page=1")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
          if (error != nil) {
            print(error as Any)
          } else {
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(apiResponse.self, from: data!)
                completion(result.results)
            }
            catch {
                print(error)
            }
          }
        })

        dataTask.resume()
    }
    
    func getImage(filePath: String, completion: @escaping (UIImage) -> Void) {
        let headers = [
          "accept": "application/json",
          "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmNzllYTZhZTBhNjQ3OTY2YTVmN2FkOGJmYzU4OTY1NCIsInN1YiI6IjY1MTFjMGIwMzQ0YThlMDk2Zjg1Y2E3YSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ._3ZwGjxbOAesJ6kEompdNDvg74lRZABLy0NG0FqsCE8"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://image.tmdb.org/t/p/w500\(filePath)")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
            } else {
                if let image = UIImage(data: data!) {
                    completion(image)
                }
            }
        })

        dataTask.resume()
    }
}

    
struct apiResponse: Decodable {
    var results: [Movie]
}
