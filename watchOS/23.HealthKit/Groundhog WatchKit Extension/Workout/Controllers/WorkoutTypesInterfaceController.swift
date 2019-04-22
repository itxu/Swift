
import WatchKit
import Foundation

class WorkoutTypesInterfaceController: WKInterfaceController {
  
  // MARK: ****** UI Elements ******
  @IBOutlet weak var table: WKInterfaceTable!

  // MARK: ****** Lifecycle ******
  override func awake(withContext context: Any?) {
    super.awake(withContext: context)
    
    setupTable()
  }
  
  override func willActivate() {
    super.willActivate()
    
    let healthService:HealthDataService = HealthDataService()
    healthService.authorizeHealthKitAccess { (success, error) in
      if success {
        print("HealthKit authorization received.")
      } else {
        print("HealthKit authorization denied!")
        if error != nil {
          print("\(String(describing: error))")
        }
      }
    }
  }
  
  // MARK: ****** Navigation ******
  override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
    let row = table.rowController(at: rowIndex) as! ExerciseTypeRowController
    guard let exercise = row.exerciseType else {return nil}
    return WorkoutConfiguration(exerciseType: exercise)
  }
  
  // MARK: ****** Helpers ******
  func setupTable() {
    let allExercises = ExerciseType.allValues
    table.setNumberOfRows(allExercises.count, withRowType: "ExerciseTypeRowController")
    
    var i = 0
    for exercise in allExercises {
      let row = table.rowController(at: i) as! ExerciseTypeRowController
      row.exerciseType = exercise
      i += 1
    }
  }
}
