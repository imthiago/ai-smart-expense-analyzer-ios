//
//  NetworkMonitor.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 18/04/26.
//

import Combine
import Network

/// `NetworkMonitor` é utilizado pelo app para duas coisas:
/// 1. Feedback de UI: O `ExpenseListViewController` pode observar a propriedade `isConnected` para exibir ou ocultar um banner offline.
/// 2. Retry de classificação pendente
final class NetworkMonitor {
    // MARK: - Estado da conexão

    /// `true` quando o dispositivo está conectado
    @Published private(set) var isConnected: Bool = true

    // MARK: Private properties
    private let monitor: NWPathMonitor
    private let queue = DispatchQueue(label: "com.iasmartexpenseanalyzer.network-monitor", qos: .utility)

    // MARK: - Init
    init() {
        monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }

    deinit {
        monitor.cancel()
    }
}
