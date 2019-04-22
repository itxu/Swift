
import Foundation
import WatchConnectivity

protocol ConnectivityManagerDelegate {
  func connectivityManagerDidUpdate()
}

/// Connectivity Manager refactors code related to WatchConnectivity to handle
/// sending request for poster images, receiving response from parent app and 
/// store them locally on the watch. On completion of every file received, it
/// notifies its delegate.
class ConnectivityManager: NSObject {
  
  /// The WatchConnectivity session to query poster images if needed.
  fileprivate var session: WCSession?
  
  /// A reference map to update poster images for each video clip after
  /// receiving them from the phone app.
  fileprivate let references = VideoClipProvider().clipReferences
  
  fileprivate let delegate: ConnectivityManagerDelegate
  
  init(delegate: ConnectivityManagerDelegate) {
    self.delegate = delegate
    super.init()
  }
  
  func startSession() {
    session = WCSession.default
    session!.delegate = self
    session!.activate()
  }
  
  func requestPosterImages(withSession session: WCSession) {
    let clips = VideoClipProvider().clips
    let preferences = UserDefaults.standard
    for clip in clips {
      
      let key = clip.lastPathComponent
      let hasPosterImage = preferences.bool(forKey: key)
      guard hasPosterImage == false else { continue }
      
      let message = [VideoClipProvider.WCPosterImageRequestKey : clip.lastPathComponent]
      print("⌚️ WCSession is sending message \(message)...")
      session.sendMessage(message, replyHandler: nil, errorHandler: { (error: Error) in
        print("⌚️ WCSession encountered error sending or receiving message: \(error)")
      })
    }
  }
}

extension ConnectivityManager: WCSessionDelegate {
  
  func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    print("⌚️ WCSession activationDidCompleteWith: \(String(describing: activationState)) - error: \(String(describing: error?.localizedDescription))")
    guard activationState == .activated else { return }
    requestPosterImages(withSession: session)
  }
  
  func sessionReachabilityDidChange(_ session: WCSession) {
    print("⌚️ WCSession sessionReachabilityDidChange: \(session)")
    guard session.isReachable else { return }
    requestPosterImages(withSession: session)
  }
  
  func session(_ session: WCSession, didReceive file: WCSessionFile) {
    print("⌚️ WCSession received file: \(file)")
    guard let name = file.metadata?[VideoClipProvider.WCPosterImageRequestKey] as? String else { return }
    
    let fileManager = FileManager.default
    let userDocuments = fileManager.urls(for: .documentDirectory, in: .userDomainMask).last!
    let destination = userDocuments.appendingPathComponent(name)
    do {
      try fileManager.moveItem(at: file.fileURL, to: destination)
      let preference = UserDefaults.standard
      preference.set(true, forKey: name)
    }
    catch {}
    
    delegate.connectivityManagerDidUpdate()
  }
  
}
