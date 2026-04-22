//
//  MetadataCardView.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 21/04/26.
//

import UIKit

final class MetadataCardView: CardView {
    private let providerValueLabel = UILabel()
    private let dateValueLabel = UILabel()

    init() {
        super.init(spacing: 12)
        contentStack.addArrangedSubview(makeRow(icon: "cpu",
                                                staticLabel: "Provider",
                                                valueLabel: providerValueLabel))
        
        contentStack.addArrangedSubview(makeRow(icon: "clock",
                                                staticLabel: "Classificado em",
                                                valueLabel: dateValueLabel))
    }

    required init?(coder: NSCoder) { nil }

    func configure(provider: String, processedAt: String) {
        providerValueLabel.text = provider
        dateValueLabel.text = processedAt
    }

    private func makeRow(icon: String, staticLabel: String, valueLabel: UILabel) -> UIView {
        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor = .secondaryLabel
        iconView.contentMode = .scaleAspectFit
        iconView.widthAnchor.constraint(equalToConstant: 16).isActive = true

        let labelView = UILabel()
        labelView.text = staticLabel
        labelView.font = .systemFont(ofSize: 14)
        labelView.textColor = .secondaryLabel

        valueLabel.font = .systemFont(ofSize: 14, weight: .medium)
        valueLabel.textAlignment = .right

        let row = UIStackView(arrangedSubviews: [iconView, labelView, UIView(), valueLabel])
        row.axis = .horizontal
        row.spacing = 8
        row.alignment = .center
        return row
    }
}
