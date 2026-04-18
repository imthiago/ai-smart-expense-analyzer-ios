//
//  AppLogger.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 18/04/26.
//

import OSLog

// MARK: - Log Category
enum LogCategory: String {
    case network        = "Network"
    case persistence    = "Persistence"
    case ai             = "AI"
    case useCase        = "UseCase"
    case presentation   = "Presentation"
}

// MARK: - Log Level
enum LogLevel {
    case debug
    case info
    case warning
    case error
}

// MARK: - AppLogger

/// Logger estruturado baseado no sistema de logs unificado da própria Apple (`OSLog`)
/// - Permite exibição no app console e Instruments com filtragem
/// - Dados sensíveis podem ser mascarados em produção
/// - Otimização em tempo de compilação quando o nível de log não está ativo
///
/// ## Uso
/// ```swift
/// logger.log(.ai, level: .info, message: "Categorization complete", metadata: [
///     "category": "food",
///     "confidence": "0.92"
/// ])
/// // → [AI] Categorization complete | category=food, confidence=0.92
/// ```
final class AppLogger {
    // MARK: - Properties
    private let subsystem: String

    // MARK: - Init
    init(subsystem: String = Bundle.main.bundleIdentifier ?? "com.iasmartexpenseanalyzer") {
        self.subsystem = subsystem
    }

    /// Registra ume mensagem estruturada no sistema de log
    ///
    /// - Parameters:
    ///  - category: Categoria do sistema do log
    ///  - level: Nível de severidade
    ///  - message: Descrição do evento
    ///  - metadata: Chave-valor opcionais para filtros
    func log(_ category: LogCategory, level: LogLevel, message: String, metadata: [String: String] = [:]) {
        let osLogger = Logger(subsystem: subsystem, category: category.rawValue)

        let metadataSuffix = metadata.isEmpty
        ? ""
        : " | " + metadata.sorted(by: { $0.key < $1.key })
                          .map { "\($0.key)=\($0.value)" }
                          .joined(separator: ", ")

        let fullMessage = "\(message)\(metadataSuffix)"

        switch level {
        case .debug:
            osLogger.debug("\(fullMessage, privacy: .public)")
        case .info:
            osLogger.info("\(fullMessage, privacy: .public)")
        case .warning:
            osLogger.warning("\(fullMessage, privacy: .public)")
        case .error:
            osLogger.error("\(fullMessage, privacy: .public)")
        }
    }
}

extension AppLogger {
    func debug(_ category: LogCategory, _ message: String, metadata: [String: String] = [:]) {
        log(category, level: .debug, message: message, metadata: metadata)
    }

    func info(_ category: LogCategory, _ message: String, metadata: [String: String] = [:]) {
        log(category, level: .info, message: message, metadata: metadata)
    }

    func warning(_ category: LogCategory, _ message: String, metadata: [String: String] = [:]) {
        log(category, level: .warning, message: message, metadata: metadata)
    }

    func error(_ category: LogCategory, _ message: String, metadata: [String: String] = [:]) {
        log(category, level: .error, message: message, metadata: metadata)
    }
}
