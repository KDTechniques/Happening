//
//  NetworkManager.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-02-17.
//

import Foundation
import Network

class NetworkManger: ObservableObject {
    
    // MARK: PROPERTIES
    
    // singleton
    static let  shared = NetworkManger()
    
    let monitor = NWPathMonitor()
    
    let queue = DispatchQueue(label: "Monitor")
    
    @Published var connectionStatus: ConnectionStatus = .noConnection
    
    enum ConnectionStatus {
        case connected
        case noConnection
    }
    
    // MARK: INITIALIZER
    
    init() {
        startNetworkMonitor()
    }
    
    // MARK: FUNCTIONS
    
    // MARK: startNetworkMonitor
    func startNetworkMonitor() {
        print("Initializer is called")
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("We're connected! 👨🏻‍💻👨🏻‍💻👨🏻‍💻")
                DispatchQueue.main.async {
                    self.connectionStatus = .connected
                }
            } else {
                print("No connection. 😕😕😕")
                DispatchQueue.main.async {
                    self.connectionStatus = .noConnection
                }
            }
        }
        
        self.monitor.start(queue: self.queue)
    }
}
