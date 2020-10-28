//
//  NetworkMonitor.swift
//  Somnia
//
//  Created by Juan Felipe Torres on 28/10/20.
//

import Foundation
import Network

class NetworkMonitor {
    static let shared = NetworkMonitor()

    let monitor = NWPathMonitor()
    private var status: NWPath.Status = .requiresConnection
    var isReachable: Bool { status == .satisfied }
    var isReachableOnCellular: Bool = true
    static var connected: Bool = false

    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.status = path.status
            self?.isReachableOnCellular = path.isExpensive

            if path.status == .satisfied {
                NetworkMonitor.connected = true

                print("We're connected!, \(NetworkMonitor.connected)")
                // post connected notification
            } else {
                NetworkMonitor.connected = false
                print("No connection., \(NetworkMonitor.connected)")
                // post disconnected notification
            }
            print(path.isExpensive)
        }

        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }
}
