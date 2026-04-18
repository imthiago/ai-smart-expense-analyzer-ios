//
//  Secrets.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 18/04/26.
//

import Foundation

/// Centraliza o acesso aos valores de configuração sensíveis.
///
/// Para definição das chaves de API OpenAI para builds locais:
/// 1. Product -> Scheme -> Edit Scheme -> Run -> Arguments
/// 2. Adicionar as variáveis:
///  - Name: `OPENAI_API_KEY`
///  - Value: `chave_api_open_ai
///
enum Secrets {
    /// Chave de API OpenAI lida da variável de ambiente `OPENAI_API_KEY`
    /// Retorna uma string vazia se a variável não estiver definida e lançará uma `AIProviderError.unauthorized` ao invés de travar o app
    static var openAIKey: String {
        ProcessInfo.processInfo.environment["OPENAI_API_KEY"] ?? ""
    }

    static var hasOpenAIKey: Bool {
        !openAIKey.isEmpty
    }
}
