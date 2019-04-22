
import WatchKit
import WatchConnectivity

class ExtensionDelegate: NSObject {
  
  private var connectivityManager: ConnectivityManager!
  
  /// A convenient getter that returns a pointer to the root interface
  /// controller of the extension.
  private var rootInterfaceController: InterfaceController {
    return WKExtension.shared().rootInterfaceController as! InterfaceController
  }
  
}

extension ExtensionDelegate: WKExtensionDelegate {
  
  func applicationDidFinishLaunching() {
    connectivityManager = ConnectivityManager(delegate: self)
    connectivityManager.startSession()
  }
  
}

extension ExtensionDelegate: ConnectivityManagerDelegate {
  func connectivityManagerDidUpdate() {
    DispatchQueue.main.async {
      (WKExtension.shared().rootInterfaceController as? InterfaceController)?.updateTable()
    }
  }
}

