//
//  Question.swift
//  StackOverflowTags
//
//  Created by Innocent Magagula on 2021/05/24.
//

import Foundation

struct QuestionResponse: Codable  {
    let items: [Question]
    let errorMessage: String?

    enum CodingKeys: String, CodingKey {
        case items, errorMessage = "error_message"
    }
}

struct Question: Codable {
    let tags: [String]
    let title: String
    let body: String?
    let owner: Owner?
    let isAnswered: Bool
    let votesCount: Int
    let answerCount: Int
    let viewsCount: Int
    let createdAt: Double

    enum CodingKeys: String, CodingKey {
        case tags
        case title
        case body
        case owner
        case isAnswered = "is_answered"
        case votesCount = "score"
        case answerCount = "answer_count"
        case viewsCount = "view_count"
        case createdAt = "creation_date"
    }
}

struct Owner: Codable {
    let displayName: String?
    let profileImage: URL?
    let reputation: Int?

    enum CodingKeys: String, CodingKey {
        case displayName = "display_name"
        case profileImage = "profile_image"
        case reputation
    }

}
