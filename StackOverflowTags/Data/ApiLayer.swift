//
//  ApiLayer.swift
//  StackOverflowTags
//
//  Created by Innocent Magagula on 2021/05/24.
//

import Foundation

class ApiLayer {

    @InfoPlist<String>("WEB_SERVICE_BASE_URL")
    static var baseUrl

    class func request<T: Codable>(request: URLRequest, completion: @escaping RouterCompletion<T>) -> URLSessionTask {
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: request) { data, response, error in

            if let error = error {
                completion(.failure(.general(error)))
                return
            }

            guard let data = data else {
                completion(.failure(.custom("Empty response".localized)))
                return
            }
            do{
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode != 200 {
                        let responseObject = try JSONDecoder().decode(ErrorResponse.self, from: data)
                        completion(.failure(.custom(responseObject.message.localized)))
                    }
                    else{
                        let responseObject = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(responseObject))
                    }
                }
                else{
                    let responseObject = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(responseObject))
                }
            }
            catch{
                completion(.failure(.general(error)))
            }
        }
        dataTask.resume()
        return dataTask
    }

    class func download(request: URLRequest, completion: @escaping (Result<Data, ApiError>) -> Void) -> URLSessionTask {
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: request) { data, response, error in

            if let error = error {
                completion(.failure(.general(error)))
                return
            }

            guard let data = data else {
                completion(.failure(.custom("Empty response".localized)))
                return
            }
            completion(.success(data))
        }
        dataTask.resume()
        return dataTask
    }
}
