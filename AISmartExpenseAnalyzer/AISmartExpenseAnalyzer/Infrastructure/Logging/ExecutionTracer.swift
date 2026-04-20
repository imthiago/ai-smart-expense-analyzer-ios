//
//  ExecutionTracer.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 20/04/26.
//

struct ExecutionTracer {
    private let logger: AppLogger

    init(logger: AppLogger) {
        self.logger = logger
    }

    func trace<T>(
        _ name: String,
        category: LogCategory,
        metadata: [String: String],
        operation: () async throws -> T
    ) async throws -> T {
        logger.debug(category, "\(name): iniciando 🚀", metadata: metadata)
        do {
            let result = try await operation()
            logger.info(category, "\(name): concluído com sucesso ✅")
            return result
        } catch {
            logger.error(category, "\(name): falhou — \(error) ⛔️")
            throw error
        }
    }
}
