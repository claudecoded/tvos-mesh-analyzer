import Foundation
import Network

public final class NetworkMeshMonitor {
    public static let shared = NetworkMeshMonitor()
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "com.appletv.meshmonitor.queue")
    
    public var onStatusChanged: ((String, String, Bool) -> Void)?
    
    private init() {
        setupMonitor()
    }
    
    private func setupMonitor() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            
            let connectionType: String
            if path.usesInterfaceType(.wifi) {
                connectionType = "Wi-Fi 7 / Local Wireless Mesh"
            } else if path.usesInterfaceType(.wiredEthernet) {
                connectionType = "Wired Gigabit Ethernet"
            } else if path.usesInterfaceType(.cellular) {
                connectionType = "Cellular Bridge"
            } else {
                connectionType = "Thread Node / Isolated Network"
            }
            
            let statusDescription = path.status == .satisfied ? "Stable Link" : "Degraded Link / Packet Loss Detected"
            let isExpensive = path.isExpensive
            
            DispatchQueue.main.async {
                self.onStatusChanged?(connectionType, statusDescription, isExpensive)
            }
        }
    }
    
    public var isExpensiveConnection: Bool {
        return monitor.currentPath.isExpensive
    }
    
    public func startAnalyzing() {
        monitor.start(queue: queue)
    }
    
    public func stopAnalyzing() {
        monitor.cancel()
    }
}
