
import WatchKit

class ExtensionDelegate: NSObject, WKExtensionDelegate {
  
  func applicationDidFinishLaunching() {
    // Perform any final initialization of your application.
  }
  
  func applicationDidBecomeActive() {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }
  
  func applicationWillResignActive() {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, etc.
  }
  
  func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
    // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
    for task in backgroundTasks {
      // Use a switch statement to check the task type
      switch task {
      case let backgroundTask as WKApplicationRefreshBackgroundTask:
        // Be sure to complete the background task once you’re done.
        backgroundTask.setTaskCompleted()
      case let snapshotTask as WKSnapshotRefreshBackgroundTask:
        print("\n handling snapshot task \n")
        
        // 1
        let nextMatchDate = season.upcomingMatches.first?.date
        let lastMatchExpiresTimeInterval =
          season.playedMatches.last?.date.timeIntervalSince(
            Date().yesterday)
        // 2
        let wkExtension = WKExtension.shared()
        // Always reset back to the root controller
        wkExtension.rootInterfaceController?.popToRootController()
        
        // 3
        // Check if the last match was played recently
        if let lastMatchExpiresTimeInterval =
          lastMatchExpiresTimeInterval,
          lastMatchExpiresTimeInterval > 0 {
          let expiration =
            Date().addingTimeInterval(lastMatchExpiresTimeInterval)
          // Move to record controller
          wkExtension.rootInterfaceController?.pushController(
            withName: "RecordInterfaceControllerType", context: nil)
          // 4
          snapshotTask.setTaskCompleted(restoredDefaultState: false,
                                        estimatedSnapshotExpiration: expiration, userInfo: nil)
          break
        }
        
        // 5
        // Check if the next match will happen soon
        if let nextMatchDate = nextMatchDate,
          nextMatchDate.timeIntervalSinceNow <
            Date().tomorrow.timeIntervalSinceNow {
          // 6
          // Move to schedule controller
          wkExtension.rootInterfaceController?.pushController(
            withName: "ScheduleInterfaceControllerType",
            context: nil)
          // 7
          // Move to schedule detail controller
          // for `context` use the index of upcoming matches, first is 0
          wkExtension.rootInterfaceController?.pushController(
            withName: "ScheduleDetailInterfaceControllerType",
            context: 0)
          // 8
          snapshotTask.setTaskCompleted(restoredDefaultState: false,
                                        estimatedSnapshotExpiration: nextMatchDate, userInfo: nil)
          break
        }
        
        // 9
        // Check if there is any upcoming match
        if let nextMatchDate = nextMatchDate {
          // Move to schedule controller
          wkExtension.rootInterfaceController?.pushController(
            withName: "ScheduleInterfaceControllerType",
            context: nil)
          // Check back 24 hours before next match
          let expiration = nextMatchDate.yesterday
          snapshotTask.setTaskCompleted(
            restoredDefaultState: false,
            estimatedSnapshotExpiration: expiration, userInfo: nil)
          break
        }
        // 10
        // No recent matches. No need to update snapshot.
        
        
        
        // Snapshot tasks have a unique completion call, make sure to set your expiration date
        snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
      case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
        // Be sure to complete the connectivity task once you’re done.
        connectivityTask.setTaskCompleted()
      case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
        // Be sure to complete the URL session task once you’re done.
        urlSessionTask.setTaskCompleted()
      default:
        // make sure to complete unhandled task types
        task.setTaskCompleted()
      }
    }
  }
  
}
