
import Foundation

/**
 * NetworkRequestManager is responsible to handle dispatching network request,
 * manange the session, cancel tasks and handle background modes.
 **/
class NetworkRequestManager {
  
  /// Data task the receiver has dispatched so that it can be canceled later on if needed.
  private var dataTask: URLSessionDataTask?
  
  /// Maximum timeout for a network request to return from server.
  private let maximumTimeout: Int64 = 30
  
  /// Ask for a background task assertion and have the semphore either wait or release based on the state of the assertion.
  private func askForAssretionWithSemaphore(_ semaphore: DispatchSemaphore) {
    ProcessInfo.processInfo.performExpiringActivity(withReason: "network_request", using: { (expired: Bool) -> Void in
      if !expired {
        // You have a background task assertion. Good to go!
        let timeout: DispatchTime = DispatchTime.now() + Double(self.maximumTimeout) / Double(NSEC_PER_SEC)
        _ = semaphore.wait(timeout: timeout)
      } else {
        // No background task assetion.
        self.releaseAssretionWithSemaphore(semaphore)
      }
    })
  }
  
  /// Signal and release a semaphore.
  private func releaseAssretionWithSemaphore(_ semaphore: DispatchSemaphore) {
    dataTask?.cancel()
    semaphore.signal()
  }
  
  // MARK: Public
  
  /// Dispatches a request. The completion block is called on a secondary thread. This is intentional.
  func dispatchRequest(_ request: URLRequest, completion:@escaping (_ data: Data?, _ error: Error?) -> Void) {
    let state = dataTask?.state
    if let state = state , state == URLSessionTask.State.running {
      print("There's a similar network task in running state. Duplicated request is ignored.")
      return
    }
    
    // Create a semaphore for background task assertion.
    let semaphore: DispatchSemaphore = DispatchSemaphore(value: 0)
    askForAssretionWithSemaphore(semaphore)
    
    weak var weakSelf = self
    let session = URLSession.shared
    let task: URLSessionDataTask = session.dataTask(with: request, completionHandler: { (sessionData: Data?, sessionResponse: URLResponse?, sessionError: Error?) -> Void in
      let sessionError = sessionError as NSError?
      weakSelf?.dataTask = nil
      
      // Don't notify the completion block if canceled.
      var isTaskCancelled = false
      if let error = sessionError {
        isTaskCancelled = (error.code == NSURLErrorCancelled)
      }
      
      if !isTaskCancelled {
        completion(sessionData, sessionError)
      }
      
      // Release semaphore.
      weakSelf?.releaseAssretionWithSemaphore(semaphore)
    })
    
    task.resume()
    dataTask = task
  }
  
  /// Performs a given block on the main thread.
  func performBlockOnTheMainThread(_ block: @escaping () -> Void) {
    OperationQueue.main.addOperation(block)
  }
  
}
