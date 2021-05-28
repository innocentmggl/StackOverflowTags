//
//  QuestionListItemViewModel.swift
//  StackOverflowTags
//
//  Created by Innocent Magagula on 2021/05/25.
//

import Foundation

struct QuestionListItemViewModel {

    private let question: Question
    let title: String
    let votesCount: String
    let answersCount: String
    let viewsCount: String
    let askedBy: String?
    let isAnswered: Bool

    init(item: Question) {
        self.question = item
        self.title = item.title.html2AttributedString
        self.votesCount = QuestionListItemViewModel.getCountString(count: item.votesCount, for: "Vote")
        self.answersCount = QuestionListItemViewModel.getCountString(count: item.answerCount, for: "answer")
        self.viewsCount = QuestionListItemViewModel.getCountString(count: item.viewsCount, for: "view")
        self.askedBy = (item.owner?.displayName != nil) ? "asked by".localized + item.owner!.displayName! : nil
        self.isAnswered = item.isAnswered
    }

    private static func getCountString(count: Int, for word: String) ->  String {
        return count == 1 ?  "\(count.roundedWithAbbreviations) " + word.localized : "\(count.roundedWithAbbreviations) " + "\(word)s".localized
    }
}
