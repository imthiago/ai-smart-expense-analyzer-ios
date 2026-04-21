//
//  ConfidenceBadgeView.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 21/04/26.
//

import UIKit

///  Badge simples para formatar e exibir o nível de confiança da IA por cor e texto
///  Regras de exibição:
///  1. Verde >= 80% para confiança alta
///  2. Laranja >= 50% para confiança média
///  3. Vermelho < 20% para confiança baixa
final class ConfidenceBadgeView: UIView {
    // MARK: - Components
    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Public properties
    var confidence: Double = 0 {
        didSet {
            update(animated: true)
        }
    }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    // MARK: - Layout
    override var intrinsicContentSize: CGSize {
        CGSize(width: label.intrinsicContentSize.width + 24, height: 28)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }

    // MARK: - Setup
    private func setup() {
        addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        layer.masksToBounds = true
        update(animated: true)
    }

    private func update(animated: Bool) {
        let (background, foreground, text) = appearance(for: confidence)

        let apply = {
            self.backgroundColor = background
            self.label.textColor = foreground
            self.label.text = text
        }

        if animated {
            UIView.animate(withDuration: 0.25, animations: apply)
        } else {
            apply()
        }

        accessibilityLabel = "Confidence: \(text)"
        invalidateIntrinsicContentSize()
    }

    private func appearance(for confidence: Double) -> (UIColor, UIColor, String) {
        let percentage = "\(Int((confidence * 100).rounded()))%"

        switch confidence {
        case 0.80:
            return (.systemGreen.withAlphaComponent(0.15), .systemGreen, percentage)
        case 0.50..<0.80:
            return (.systemOrange.withAlphaComponent(0.15), .systemOrange, percentage)
        default:
            return (.systemRed.withAlphaComponent(0.15), .systemRed, percentage)
        }
    }
}
