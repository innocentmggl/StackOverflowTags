//
//  QuestionRepository.swift
//  StackOverflowTags
//
//  Created by Innocent Magagula on 2021/05/24.
//

import Foundation
import Combine

protocol QuestionRepository {
    func getQuestions(tags: String, completion: @escaping (Result<[Question], ApiError>) -> Void)
    func loadImage(from url: URL, completion: @escaping (Result<Data, ApiError>) -> Void)
}

class QuestionRepositoryImplementation: QuestionRepository {

    @Inject
    private var router: NetworkRouter

    func getQuestions(tags: String, completion: @escaping (Result<[Question], ApiError>) -> Void){
        router.request(QuestionEndPoint.getQuestions(tag: tags), type: QuestionResponse.self) {result in
            switch result {
            case .success(let response):
                completion(.success(response.items))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func loadImage(from url: URL, completion: @escaping (Result<Data, ApiError>) -> Void) {
        router.download(url, completion: completion)
    }
}
