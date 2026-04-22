//
//  NetworkMonitor.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 18/04/26.
//

import Network

final class NetworkMonitor {

    var onConnectionChanged: ((Bool) -> Void)?

    private(set) var isConnected: Bool = true {
        didSet {
            guard isConnected != oldValue else { return }
            onConnectionChanged?(isConnected)
        }
    }

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
