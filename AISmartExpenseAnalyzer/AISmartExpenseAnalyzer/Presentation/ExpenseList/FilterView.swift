//
//  FilterView.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 20/04/26.
//

import UIKit

final class FilterView: UIView {
    var onCategorySelected: ((Category?) -> Void)?

    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsHorizontalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private var chipButtons: [UIButton] = []
    private var chipButtonCategories: [Category?] = []
    private var activeCategory: Category? = nil

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    // MARK: - Setup
    private func setup() {
        backgroundColor = .systemBackground
        addSubview(scrollView)
        scrollView.addSubview(stackView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -8),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, constant: -16)
        ])

        buildChips()
    }

    private func buildChips() {
        let allChip = makeChip(title: "Todos", category: nil)
        stackView.addArrangedSubview(allChip)
        chipButtons.append(allChip)
        chipButtonCategories.append(nil)

        for category in Category.allCases {
            let chip = makeChip(title: category.displayName, category: category)
            stackView.addArrangedSubview(chip)
            chipButtons.append(chip)
            chipButtonCategories.append(category)
        }

        updateSelection(activeCategory: nil)
    }

    private func makeChip(title: String, category: Category?) -> UIButton {
        var config = UIButton.Configuration.tinted()
        config.title = title
        config.cornerStyle = .capsule
        config.baseForegroundColor = category?.color ?? .label
        config.baseBackgroundColor = category?.color ?? .label

        let button = UIButton(configuration: config)
        button.addAction(
            UIAction { [weak self] _ in self?.chipTapped(category: category) },
            for: .touchUpInside
        )
        return button
    }

    private func chipTapped(category: Category?) {
        guard category != activeCategory else { return }
        activeCategory = category
        updateSelection(activeCategory: category)
        onCategorySelected?(category)
    }

    private func updateSelection(activeCategory: Category?) {
        for (button, buttonCategory) in zip(chipButtons, chipButtonCategories) {
            let isActive = buttonCategory == activeCategory
            let ownColor: UIColor = buttonCategory?.color ?? .label

            if isActive {
                button.configuration?.baseForegroundColor = .systemBackground
                button.configuration?.baseBackgroundColor = ownColor
            } else {
                button.configuration?.baseForegroundColor = ownColor
                button.configuration?.baseBackgroundColor = ownColor
            }
            button.isSelected = isActive
        }
    }
}
