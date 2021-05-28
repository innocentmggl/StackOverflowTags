//
//  DependencyManager.swift
//  StackOverflowTags
//
//  Created by Innocent Magagula on 2021/05/24.
//

import Foundation

final class DependencyManager {
    static let container = DependencyInjection.shared
    static func registerDependencies(){
        container.register(type: NetworkRouter.self, { Router() })
        container.register(type: QuestionRepository.self, { QuestionRepositoryImplementation() })
        container.register(type: LoadingIndicator.self, { LoadingIndicatorImplementation() })
    }
}


