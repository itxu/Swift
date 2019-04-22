
import UIKit

class MainViewController: UIViewController {
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  @IBOutlet weak var stationNameLabel: UILabel!
  @IBOutlet weak var stationStateLabel: UILabel!
  
  @IBOutlet weak var currentWaterLevelLabel: UILabel!
  @IBOutlet weak var averageWaterLevelLabel: UILabel!
  @IBOutlet weak var tideLabel: UILabel!
  
  @IBOutlet weak var chartView: LineChart!
  @IBOutlet weak var selectedValueLabel: UILabel!
  
  var tideConditions: TideConditions = TideConditions.loadConditions()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    var xLabels = [String](repeating: "", count: 50)
    xLabels[0] = "-24h"
    xLabels[47] = "+24h"
    xLabels[23] = "Now"
    chartView.x.labels.values = xLabels
    chartView.area = false
    chartView.delegate = self
    
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(forName: NSNotification.Name(rawValue: WatchUpdatedDataNotification), object: nil, queue: nil) { notification in
      if let conditions = (notification as NSNotification).userInfo?["conditions"] as? TideConditions {
        self.tideConditions = conditions;
        DispatchQueue.main.async {
          self.populateData()
        }
      }
    }
    populateData()
    refresh(false)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let dest = segue.destination as? StationsViewController {
      dest.delegate = self
    }
  }
}

// MARK: Load Data
extension MainViewController {
  func refresh(_ newStation: Bool) {
    activityIndicator.startAnimating()
    let yesterday = Date(timeIntervalSinceNow: -24 * 60 * 60)
    let tomorrow = Date(timeIntervalSinceNow: 24 * 60 * 60)
    tideConditions.loadWaterLevels(from: yesterday, to: tomorrow) { success in
      DispatchQueue.main.async {
        self.activityIndicator.stopAnimating()
        if success {
          self.populateData()
          TideConditions.saveConditions(self.tideConditions)
          let notificationCenter = NotificationCenter.default
          notificationCenter.post(name: Notification.Name(rawValue: PhoneUpdatedDataNotification), object: self, userInfo:
            ["conditions": self.tideConditions,
              "newStation": NSNumber(value: newStation)
            ])
        }
        else {
          print("Failed to load station: \(self.tideConditions.station.name)")
        }
      }
    }
  }
  
  func populateData() {
    stationNameLabel.text = tideConditions.station.name
    stationStateLabel.text = tideConditions.station.state
    
    chartView.clearAll()
    selectedValueLabel.text = "Select a point"
    
    guard tideConditions.waterLevels.count > 0 else {
      return
    }
    
    if let currentWaterLevel = tideConditions.currentWaterLevel {
      currentWaterLevelLabel.text = String(format: "%.1fm", currentWaterLevel.height)
      tideLabel.text = currentWaterLevel.situation.rawValue
    }
    averageWaterLevelLabel.text = String(format: "%.1fm", tideConditions.averageWaterLevel)
    
    let levels = tideConditions.waterLevels.map { CGFloat($0.height) }
    chartView.addLine(levels)
    chartView.setNeedsDisplay()
  }
}

// MARK: StationsViewControllerDelegate
extension MainViewController: StationsViewControllerDelegate {
  func selectedStation(_ station: MeasurementStation) {
    _ = navigationController?.popViewController(animated: true)
    guard station.name != tideConditions.station.name else { return }
    tideConditions = TideConditions(station: station)
    refresh(true)
  }
}

// MARK: LineChartDelegate
extension MainViewController: LineChartDelegate {
  func didSelectDataPoint(_ x: CGFloat, yValues: [CGFloat]) {
    if yValues.count > 0 {
      let y = yValues[0]
      selectedValueLabel.text = String(format: "%.1fm", y)
    }
    else {
      selectedValueLabel.text = "Select a point"
    }
  }
}
