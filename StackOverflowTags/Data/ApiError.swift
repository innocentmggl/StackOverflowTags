//
//  ApiError.swift
//  StackOverflowTags
//
//  Created by Innocent Magagula on 2021/05/24.
//

import Foundation

enum ApiError: Error {
    case custom(String?)
    case general(Error?)
}
