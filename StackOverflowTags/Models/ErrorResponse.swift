//
//  ErrorResponse.swift
//  StackOverflowTags
//
//  Created by Innocent Magagula on 2021/05/24.
//

import Foundation

struct ErrorResponse: Codable {
    let errorCode: Int
    let message: String
    let errorName: String

    enum CodingKeys: String, CodingKey {
        case errorCode = "error_id"
        case message = "error_message"
        case errorName = "error_name"
    }
}
