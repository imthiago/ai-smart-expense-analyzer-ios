//
//  AddExpenseViewController.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 20/04/26.
//

import UIKit

final class AddExpenseViewController: UIViewController {
    // MARK: - Dependencies
    private let viewModel: AddExpenseViewModel

    // MARK: - Components
    private let scrollView = UIScrollView()
    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 24
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let amountField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "R$ 0,00"
        tf.keyboardType = .decimalPad
        tf.font = .systemFont(ofSize: 32, weight: .bold)
        tf.textAlignment = .center
        tf.borderStyle = .none
        return tf
    }()

    private let descriptionField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Descrição (ex.: Sanduíche de Presunto)"
        tf.font = .systemFont(ofSize: 16)
        tf.borderStyle = .roundedRect
        tf.returnKeyType = .done
        return tf
    }()

    private let datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        dp.preferredDatePickerStyle = .compact
        dp.maximumDate = Date()
        return dp
    }()

    private let submitButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Salvar"
        config.cornerStyle = .large
        let button = UIButton(configuration: config)
        return button
    }()

    private let loadingIndicator = UIActivityIndicatorView(style: .medium)

    // MARK: - Init
    init(viewModel: AddExpenseViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupLayout()
        bindViewModel()
        bindFields()
    }

    // MARK: - Setup Layout
    private func setupNavigationBar() {
        title = "Nova Despesa"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelTapped)
        )
    }

    private func setupLayout() {
        view.backgroundColor = .systemBackground

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)

        contentStack.addArrangedSubview(makeSection(title: "Valor", content: amountField))

        contentStack.addArrangedSubview(makeSection(title: "Descrição", content: descriptionField))

        let dateRow = UIStackView(arrangedSubviews: [
            makeLabel("Data"),
            datePicker
        ])
        dateRow.axis = .horizontal
        dateRow.distribution = .equalSpacing
        contentStack.addArrangedSubview(makeSectionContainer(content: dateRow))

        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        contentStack.addArrangedSubview(submitButton)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),

            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -24),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40),

            submitButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

    private func handleState(_ state: AddExpenseViewModel.State) {
        switch state {
        case .idle:
            submitButton.configuration?.showsActivityIndicator = false
            submitButton.isEnabled = viewModel.isFormValid
        case .loading:
            submitButton.configuration?.showsActivityIndicator = true
            submitButton.isEnabled = false
        case .success:
            break
        case .failure(let message):
            submitButton.configuration?.showsActivityIndicator = false
            submitButton.isEnabled = viewModel.isFormValid
            showError(message)
        }
    }
}

// MARK: - Binding
extension AddExpenseViewController {
    private func bindViewModel() {
        viewModel.onFormValidChanged = { [weak self] isValid in
            self?.submitButton.isEnabled = isValid
            self?.submitButton.alpha = isValid ? 1.0 : 0.5
        }

        viewModel.onStateChanged = { [weak self] state in
            self?.handleState(state)
        }

        submitButton.isEnabled = viewModel.isFormValid
        submitButton.alpha = viewModel.isFormValid ? 1.0 : 0.5
    }

    private func bindFields() {
        amountField.addTarget(self, action: #selector(amountChanged), for: .editingChanged)
        descriptionField.addTarget(self, action: #selector(descriptionChanged), for: .editingChanged)
        descriptionField.delegate = self
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
    }
}

// MARK: - Actions
extension AddExpenseViewController {
    @objc private func cancelTapped() {
        viewModel.cancelTapped()
    }

    @objc private func submitTapped() {
        viewModel.submitTapped()
    }

    @objc private func amountChanged() {
        viewModel.amountText = amountField.text ?? ""
    }

    @objc private func descriptionChanged() {
        viewModel.descriptionText = descriptionField.text ?? ""
    }

    @objc private func dateChanged() {
        viewModel.date = datePicker.date
    }
}

// MARK: - Setup Components
extension AddExpenseViewController {
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Erro ao salvar", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func makeLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }

    private func makeSection(title: String, content: UIView) -> UIView {
        let stack = UIStackView(arrangedSubviews: [makeLabel(title), content])
        stack.axis = .vertical
        stack.spacing = 8
        return makeSectionContainer(content: stack)
    }

    private func makeSectionContainer(content: UIView) -> UIView {
        let container = UIView()
        container.backgroundColor = .secondarySystemBackground
        container.layer.cornerRadius = 12
        container.translatesAutoresizingMaskIntoConstraints = false
        content.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(content)
        NSLayoutConstraint.activate([
            content.topAnchor.constraint(equalTo: container.topAnchor, constant: 14),
            content.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            content.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            content.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -14),
        ])
        return container
    }
}

// MARK: - UITextFieldDelegate
extension AddExpenseViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
