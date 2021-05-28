//
//  Router.swift
//  StackOverflowTags
//
//  Created by Innocent Magagula on 2021/05/24.
//

import Foundation

typealias Parameters = [String: String]
typealias RouterCompletion<T> = (Result<T, ApiError>) -> ()

enum HttpMethod : String {
    case get = "GET"
}

enum HttpTask {
    case request
    case requestParameters(urlParameters: Parameters?)
}

protocol EndPoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: HttpMethod { get }
    var task: HttpTask { get }
}

protocol NetworkRouter: class {
    func request<T: Codable>(_ route: EndPoint, type: T.Type, completion: @escaping RouterCompletion<T>)
    func download(_ url: URL, completion: @escaping (Result<Data, ApiError>) -> Void)
    func cancel()
}

class Router: NetworkRouter {

    private var task: URLSessionTask?

    func request<T: Codable>(_ router: EndPoint, type: T.Type, completion: @escaping RouterCompletion<T>) {
        var request = URLRequest(url: router.baseURL.appendingPathComponent(router.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 30.0)
        request.httpMethod = router.method.rawValue
        switch router.task {
        case .requestParameters(let parameters):
            encode(urlRequest: &request, with: parameters)
        case _: break
        }
        task = ApiLayer.request(request: request, completion: completion)
    }

    func download(_ url: URL, completion: @escaping (Result<Data, ApiError>) -> Void) {
        var request = URLRequest(url: url,
                                 cachePolicy: .returnCacheDataElseLoad,
                                 timeoutInterval: 30.0)
        request.httpMethod = "get"
        task = ApiLayer.download(request: request, completion: completion)
    }

    func cancel() {
        task?.cancel()
    }

    private func encode(urlRequest: inout URLRequest, with parameters: Parameters? = nil) {

        guard let url = urlRequest.url, let parameters = parameters else { return }
        if var urlComponents = URLComponents(url: url,
                                             resolvingAgainstBaseURL: false),

                               !parameters.isEmpty {
            urlComponents.queryItems = [URLQueryItem]()
            for (key,value) in parameters {
                let queryItem = URLQueryItem(name: key, value: value)
                urlComponents.queryItems?.append(queryItem)
            }
            urlRequest.url = urlComponents.url
        }
    }
}
