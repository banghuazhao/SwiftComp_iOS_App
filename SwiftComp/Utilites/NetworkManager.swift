//
//  Network.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 9/5/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import Foundation
import Reachability

class NetworkManager: NSObject {
    var reachability: Reachability!

    // Create a singleton instance
    static let sharedInstance: NetworkManager = { NetworkManager() }()

    override init() {
        super.init()

        // Initialise reachability
        reachability = Reachability()!

        // Register an observer for the network status
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(networkStatusChanged(_:)),
            name: .reachabilityChanged,
            object: reachability
        )

        do {
            // Start the network status notifier
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }

    @objc func networkStatusChanged(_ notification: Notification) {
        // Do something globally here!
    }

    static func stopNotifier() {
        do {
            // Stop the network status notifier
            try (NetworkManager.sharedInstance.reachability).startNotifier()
        } catch {
            print("Error stopping notifier")
        }
    }

    // Network is reachable
    static func isReachable(completed: @escaping (NetworkManager) -> Void) {
        if NetworkManager.sharedInstance.reachability.connection != .none {
            completed(NetworkManager.sharedInstance)
        }
    }

    // Network is unreachable
    static func isUnreachable(completed: @escaping (NetworkManager) -> Void) {
        if NetworkManager.sharedInstance.reachability.connection == .none {
            completed(NetworkManager.sharedInstance)
        }
    }

    // Network is reachable via WWAN/Cellular
    static func isReachableViaWWAN(completed: @escaping (NetworkManager) -> Void) {
        if NetworkManager.sharedInstance.reachability.connection == .cellular {
            completed(NetworkManager.sharedInstance)
        }
    }

    // Network is reachable via WiFi
    static func isReachableViaWiFi(completed: @escaping (NetworkManager) -> Void) {
        if NetworkManager.sharedInstance.reachability.connection == .wifi {
            completed(NetworkManager.sharedInstance)
        }
    }
}


func fetchSwiftCompHomogenizationResultJSON(API_URL: String, timeoutIntervalForRequest: Double, completion: @escaping (Result<SwiftCompHomogenizationResult, swiftcompCalculationError>) -> Void) {
    guard let urlString = API_URL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }

    guard let url = URL(string: urlString) else { return }

    let sessionConfig = URLSessionConfiguration.default
    sessionConfig.timeoutIntervalForRequest = timeoutIntervalForRequest

    URLSession(configuration: sessionConfig).dataTask(with: url) { data, _, err in

        if let err = err {
            if err._code == NSURLErrorTimedOut {
                print("Time Out: \(err)")
                completion(.failure(.timeOutError))
                return
            }

            print(err)
            completion(.failure(.networkError))
            return
        }

        // successful
        do {
            let result = try JSONDecoder().decode(SwiftCompHomogenizationResult.self, from: data!)
            completion(.success(result))

        } catch let jsonError {
            print(jsonError)
            completion(.failure(.parseJSONError))
            return
        }

    }.resume()
}
