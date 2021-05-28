//
//  QuestionTableViewCell.swift
//  StackOverflowTags
//
//  Created by Innocent Magagula on 2021/05/25.
//

import UIKit

class QuestionTableViewCell: UITableViewCell {

    static let cellReuseIdentifier = "QuestionTableViewCell"

    let containerStackView: UIStackView = {
        let stackView = UIStackView()

        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 1
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    let answeredCheckMark: UILabel = {
        let label = UILabel()
        label.text = "✓"
        label.textColor = .indigo
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 2
        label.sizeToFit()
        label.textColor = .indigo
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let askedByLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.textColor = .mountainMist
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let votesCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.textColor = .mountainMist
        return label
    }()

    let answersCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.85
        label.textColor = .mountainMist
        return label
    }()

    let viewsCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.textColor = .mountainMist
        return label
    }()

    let statsStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .fill
        view.spacing = 6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let titleContaninerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let chevronImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "icn_chevron_right")?.withRenderingMode(.alwaysTemplate)
        view.tintColor = .mountainMist
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        setupViews()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 2.5, left: 0, bottom: 2.5, right: 0))
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.mountainMist.cgColor
    }

    private func setupViews() {
        selectionStyle = .none
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .white
        addSubviews()
    }

    private func addSubviews() {
        statsStackView.addArrangedSubview(votesCountLabel)
        statsStackView.addArrangedSubview(answersCountLabel)
        statsStackView.addArrangedSubview(viewsCountLabel)
        titleContaninerView.addSubview(titleLabel)
        titleContaninerView.addSubview(askedByLabel)

        contentView.addSubview(containerStackView)
        containerStackView.addArrangedSubview(answeredCheckMark)
        containerStackView.addArrangedSubview(titleContaninerView)
        containerStackView.addArrangedSubview(statsStackView)
        containerStackView.addArrangedSubview(chevronImageView)

        NSLayoutConstraint.activate([

            containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            containerStackView.heightAnchor.constraint(equalToConstant: 80),

            chevronImageView.widthAnchor.constraint(equalToConstant: 15),
            chevronImageView.heightAnchor.constraint(equalToConstant: 15),

            titleContaninerView.heightAnchor.constraint(equalToConstant: 80),

            titleLabel.leadingAnchor.constraint(equalTo: titleContaninerView.leadingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: titleContaninerView.topAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: titleContaninerView.trailingAnchor, constant: -6),

            askedByLabel.bottomAnchor.constraint(equalTo: titleContaninerView.bottomAnchor, constant: -6),
            askedByLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            askedByLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            statsStackView.widthAnchor.constraint(equalToConstant: 70),

            answeredCheckMark.widthAnchor.constraint(equalToConstant: 16)

        ])
    }

    func configure(with viewModel: QuestionListItemViewModel) {
        self.titleLabel.text = viewModel.title
        self.answersCountLabel.text = viewModel.answersCount
        self.viewsCountLabel.text = viewModel.viewsCount
        self.votesCountLabel.text = viewModel.votesCount
        self.askedByLabel.text = viewModel.askedBy
        self.answeredCheckMark.isHidden = !viewModel.isAnswered
    }
}
