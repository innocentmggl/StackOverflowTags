//
//  QuestionEndPoint.swift
//  StackOverflowTags
//
//  Created by Innocent Magagula on 2021/05/24.
//

import Foundation

public enum QuestionEndPoint {
    case getQuestions(tag: String)
}

extension QuestionEndPoint: EndPoint {

    var baseURL: URL {
        guard let url = URL(string: ApiLayer.baseUrl) else {
            fatalError("\(ApiLayer.baseUrl) is not a valid URL")
        }
        return url
    }

    var path: String {
        switch self {
        case .getQuestions(_):
            return "2.2/questions"
        }
    }

    var method: HttpMethod {
        return .get
    }

    var task: HttpTask {
        switch self {
        case .getQuestions(let tag):
            return .requestParameters(urlParameters: ["pagesize":"20",
                                                      "order":"desc",
                                                      "sort":"activity",
                                                      "site":"stackoverflow",
                                                      "filter":"withbody",
                                                      "tagged": tag])
        }
    }
}
