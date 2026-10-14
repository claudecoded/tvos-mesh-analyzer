import UIKit

public final class AnalyzerDashboardController: UIViewController {
    
    private let statusCard = UIView()
    private let interfaceLabel = UILabel()
    private let healthLabel = UILabel()
    private let hardwareMetricsLabel = UILabel()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUIStage()
        bindMonitorEngine()
    }
    
    private func setupUIStage() {
        view.backgroundColor = UIColor.black
        
        // Configuration for the main telemetry visualization card
        statusCard.translatesAutoresizingMaskIntoConstraints = false
        statusCard.backgroundColor = UIColor(white: 0.12, alpha: 1.0)
        statusCard.layer.cornerRadius = 24
        statusCard.layer.borderWidth = 2
        statusCard.layer.borderColor = UIColor.systemGray.cgColor
        view.addSubview(statusCard)
        
        // Title Configuration
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Apple TV 4K Network & Hub Diagnostics"
        titleLabel.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
        
        // Labels layout within the telemetry card
        setupLabel(interfaceLabel, text: "Interface: Detecting Active Nodes...", size: 28, color: .lightGray)
        setupLabel(healthLabel, text: "Link Integrity: Processing Link State...", size: 32, color: .systemGreen)
        setupLabel(hardwareMetricsLabel, text: "Hardware Platform: Apple A19 Eco-System Mode Active", size: 24, color: .gray)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        statusCard.addSubview(activityIndicator)
        
        // Auto Layout constraints optimized for large 4K TV screens
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            statusCard.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusCard.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 40),
            statusCard.widthAnchor.constraint(equalToConstant: 1100),
            statusCard.heightAnchor.constraint(equalToConstant: 450),
            
            healthLabel.topAnchor.constraint(equalTo: statusCard.topAnchor, constant: 60),
            healthLabel.centerXAnchor.constraint(equalTo: statusCard.centerXAnchor),
            
            interfaceLabel.topAnchor.constraint(equalTo: healthLabel.bottomAnchor, constant: 40),
            interfaceLabel.centerXAnchor.constraint(equalTo: statusCard.centerXAnchor),
            
            hardwareMetricsLabel.bottomAnchor.constraint(equalTo: statusCard.bottomAnchor, constant: -60),
            hardwareMetricsLabel.centerXAnchor.constraint(equalTo: statusCard.centerXAnchor),
            
            activityIndicator.centerYAnchor.constraint(equalTo: hardwareMetricsLabel.centerYAnchor),
            activityIndicator.leadingAnchor.constraint(equalTo: hardwareMetricsLabel.trailingAnchor, constant: 20)
        ])
    }
    
    private func setupLabel(_ label: UILabel, text: String, size: CGFloat, color: UIColor) {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = UIFont.systemFont(ofSize: size, weight: .medium)
        label.textColor = color
        label.textAlignment = .center
        statusCard.addSubview(label)
    }
    
    private func bindMonitorEngine() {
        NetworkMeshMonitor.shared.onStatusChanged = { [weak self] connectionType, status, isExpensive in
            guard let self = self else { return }
            self.interfaceLabel.text = "Active Transport: \(connectionType)"
            self.healthLabel.text = "Link Integrity: \(status)"
            
            if isExpensive {
                self.healthLabel.textColor = .systemOrange
                self.hardwareMetricsLabel.text = "Network Topology: High-Load Overhead Detected on Cluster"
            } else {
                self.healthLabel.textColor = .systemGreen
                self.hardwareMetricsLabel.text = "Network Topology: Optimized Hub Mode [A19 Processor Engine]"
            }
        }
        
        NetworkMeshMonitor.shared.startAnalyzing()
    }
    
    deinit {
        NetworkMeshMonitor.shared.stopAnalyzing()
    }
}
