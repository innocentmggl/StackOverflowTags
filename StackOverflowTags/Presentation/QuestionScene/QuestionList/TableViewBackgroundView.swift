//
//  TableViewBackgroundView.swift
//  StackOverflowTags
//
//  Created by Innocent Magagula on 2021/05/25.
//

import UIKit

protocol TableViewBackgroundViewDelegate: class {
    func didTapRetry()
}

class TableViewBackgroundView: UIView {

    weak var delegate: TableViewBackgroundViewDelegate?
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var infoLabel: UILabel!
    @IBOutlet private weak var retryButton: UIButton!
    private let xibName = "TableViewBackgroundView"

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromNib()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadFromNib()
    }

    private func loadFromNib(){
        Bundle.main.loadNibNamed(xibName, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        infoLabel.textColor = .mountainMist
    }

    @IBAction func retryButtonPressed(_ sender: Any) {
        delegate?.didTapRetry()
    }

    func setInfoLabelText(text: String?, withRetry: Bool = false){
        self.infoLabel.text = text
        self.retryButton.isHidden = !withRetry
    }
}
