import Foundation
import Combine
import Network

public protocol NetworkMonitorService: AnyObject {
    var currentConnectionStatus: AnyPublisher<Bool, Never> { get }
}

final public class NetworkMonitoringManager: NetworkMonitorService {
    private lazy var monitor: NWPathMonitor = {
       let networkPathMonitor = NWPathMonitor()
        return networkPathMonitor
    }()
    
    private let statusCheckQueue: DispatchQueue
    
    private let connectionStatus = CurrentValueSubject<Bool, Never>(false)
    
    public var currentConnectionStatus: AnyPublisher<Bool, Never> {
        connectionStatus.eraseToAnyPublisher()
    }
    
    //MARK: - Public init we should use background queue to check network availability
    public init(statusCheckQueue: DispatchQueue = DispatchQueue(label: "NetworkMonitoringQueue", qos: .background)) {
        self.statusCheckQueue = statusCheckQueue
        startMonitoring()
    }
    
    private func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            let isConnectionAvailable = path.status == .satisfied
            self.connectionStatus.send(isConnectionAvailable)
        }
        monitor.start(queue: statusCheckQueue)
    }
    
    deinit {
        monitor.cancel()
    }
}
