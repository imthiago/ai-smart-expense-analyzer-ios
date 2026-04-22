//
//  GenerateInsightsUseCaseProtocol.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 18/04/26.
//

import Foundation

/// Contrato para geração de insights de uma coleção de despesas
///
/// Insights são computados por demanda a partir dos dados das despesas e não são armazenados.
/// Este use case é responsável por encapsular a lógica de identificar despesas recorrentes, categoria dominante.
/// @mockable
protocol GenerateInsightsUseCaseProtocol {
    /// Analisa as despesas fornecidas e retorna uma lista de insights
    ///
    /// - Parameter expenses: Conjunto de despesas a ser analisada
    /// - Returns: Lista de insights ordenados por relevância. Pode ser vazia se nenhum padrão for detectado.
    /// - Throws: Apenas um erro interno se um erro inesperado acontecer. Para casos de insights não encontrados a lista vazia será retornada
    func execute(for expenses: [Expense]) async throws -> [Insight]
}
