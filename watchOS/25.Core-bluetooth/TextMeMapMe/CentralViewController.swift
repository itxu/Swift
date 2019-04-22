
import UIKit
import CoreBluetooth

class CentralViewController: UIViewController {
  
  @IBOutlet weak var textView: UITextView!
  var centralManager: CBCentralManager!
  var discoveredPeripheral: CBPeripheral?

  var textCharacteristic: CBCharacteristic?
  var data = Data()
  var mapCharacteristic: CBCharacteristic? {
    didSet {
      if let _ = self.mapCharacteristic {
        navigationItem.rightBarButtonItem?.title = "Map Me"
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    centralManager = CBCentralManager(delegate: self, queue: nil)

    // Set up rightBarButtonItem to map user's location on peripheral
    let rightButton = UIBarButtonItem(title: "wait...", style: .plain, target: self,
       action: #selector(CentralViewController.mapUserLocation))
    navigationItem.rightBarButtonItem = rightButton
  }

  override func viewWillDisappear(_ animated: Bool) {
    centralManager.stopScan()
    super.viewWillDisappear(animated)
  }

  // MARK: - Bar button action
  // Send instruction to peripheral, to open Maps at user's location
  @objc func mapUserLocation() {
    guard let characteristic = mapCharacteristic else { return }
    discoveredPeripheral?.writeValue(Data(bytes: [1]), for: characteristic, type: .withoutResponse)
  }

  // MARK: - Helper methods

  func scan() {
    centralManager.scanForPeripherals(withServices: [TextOrMapServiceUUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey: NSNumber(value: true as Bool)])
  }

  func cleanup() {
    guard discoveredPeripheral?.state != .disconnected,
      let services = discoveredPeripheral?.services else {
        centralManager.cancelPeripheralConnection(discoveredPeripheral!)
        return
    }
    for service in services {
      if let characteristics = service.characteristics {
        for characteristic in characteristics {
          if characteristic.uuid.isEqual(textCharacteristicUUID) {
            if characteristic.isNotifying {
              discoveredPeripheral?.setNotifyValue(false, for: characteristic)
              return
            }
          }
        }
      }
    }
    centralManager.cancelPeripheralConnection(discoveredPeripheral!)
  }

}

// MARK: - Central Manager delegate
extension CentralViewController: CBCentralManagerDelegate {

  func centralManagerDidUpdateState(_ central: CBCentralManager) {
    switch central.state {
    case .poweredOn: scan()
    case .poweredOff, .resetting: cleanup()
    default: return
    }
  }

  func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
    guard RSSI_range.contains(RSSI.intValue) && discoveredPeripheral != peripheral else { return }

    discoveredPeripheral = peripheral
    central.connect(peripheral, options: [:])
  }

  func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
    if let error = error { print(error.localizedDescription) }
    cleanup()
  }

  func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
    central.stopScan()
    data.removeAll()
    peripheral.delegate = self
    peripheral.discoverServices([TextOrMapServiceUUID])
  }

  func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
    if (peripheral == discoveredPeripheral) {
      cleanup()
    }
    scan()
  }

}

// MARK: - Peripheral Delegate
extension CentralViewController: CBPeripheralDelegate {

  func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
    if let error = error {
      print(error.localizedDescription)
      cleanup()
      return
    }

    guard let services = peripheral.services else { return }
    for service in services {
      peripheral.discoverCharacteristics([textCharacteristicUUID, mapCharacteristicUUID], for: service)
    }
  }

  func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
    if let error = error {
      print(error.localizedDescription)
      cleanup()
      return
    }

    guard let characteristics = service.characteristics else { return }
    for characteristic in characteristics {
      if characteristic.uuid == textCharacteristicUUID {
        textCharacteristic = characteristic
        peripheral.setNotifyValue(true, for: characteristic)
      } else if characteristic.uuid == mapCharacteristicUUID {
        mapCharacteristic = characteristic
      }
    }
  }

  func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
    if let error = error {
      print(error.localizedDescription)
      return
    }

    if characteristic == textCharacteristic {
      guard let newData = characteristic.value else { return }
      let stringFromData = String(data: newData, encoding: .utf8)

      if stringFromData == "EOM" {
        textView.text = String(data: data, encoding: .utf8)
        data.removeAll()
      } else {
        data.append(newData)
      }
    }
  }

  func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
    if let error = error { print(error.localizedDescription) }
    guard characteristic.uuid == textCharacteristicUUID else { return }
    if characteristic.isNotifying {
      print("Notification began on \(characteristic)")
    } else {
      print("Notification stopped on \(characteristic). Disconnecting...")
    }
  }

  // Stub to stop run-time warning
  func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {}

}
