//
//  AppContainer.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 20/04/26.
//

final class AppContainer {
    // MARK: - Infrastructure
    let featureFlags: FeatureFlags
    let logger: AppLogger

    // MARK: - Persistency
    let coreDataStack: CoreDataStack

    // MARK: - Repository
    private(set) lazy var expenseRepository: any ExpenseRepositoryProtocol = {
        CoreDataExpenseRepository(context: coreDataStack.viewContext)
    }()

    private(set) lazy var aiProvider: any AIProviderProtocol = {
        guard featureFlags.useRealAI else {
            logger.info(.ai, "Using MockAIProvider (USE_REAL_AI not set)")
            return MockAIProvider()
        }

        guard Secrets.hasOpenAIKey else {
            logger.warning(
                .ai,
                "USE_REAL_AI=1 but OPENAI_API_KEY is not set. Falling back to MockAIProvider. " +
                "Set OPENAI_API_KEY in the scheme's environment variables."
            )
            return MockAIProvider()
        }

        logger.info(.ai, "Using OpenAIProvider (USE_REAL_AI=1, API key present)")
        return OpenAIProvider(apiKey: Secrets.openAIKey)
    }()

    // MARK: - Use Cases
    private(set) lazy var categorizeExpenseUseCase: any CategorizeExpenseUseCaseProtocol = {
        CategorizeExpenseUseCase(
            aiProvider: aiProvider,
            expenseRepository: expenseRepository
        )
    }()

    private(set) lazy var addExpenseUseCase: any AddExpenseUseCaseProtocol = {
        AddExpenseUseCase(
            expenseRepository: expenseRepository,
            categorizeExpenseUseCase: categorizeExpenseUseCase
        )
    }()

    private(set) lazy var getExpensesUseCase: any GetExpensesUseCaseProtocol = {
        GetExpensesUseCase(expenseRepository: expenseRepository)
    }()

    private(set) lazy var generateInsightsUseCase: any GenerateInsightsUseCaseProtocol = {
        GenerateInsightsUseCase()
    }()

    private(set) lazy var deleteExpenseUseCase: any DeleteExpenseUseCaseProtocol = {
        DeleteExpenseUseCase(expenseRepository: expenseRepository)
    }()

    /// Cria o container e carrega o armazenamento persistente
    /// - Throws: Lança um erro caso `CoreDataStack` não possa ser inicializado
    init() throws {
        featureFlags = FeatureFlags()
        logger = AppLogger()
        coreDataStack = try CoreDataStack()

        logger.info(.persistence, "CoreData stack loaded successfully")
        logger.info(.ai, "AI provider mode", metadata: ["useRealAI": "\(featureFlags.useRealAI)"])
    }
}
