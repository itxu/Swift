

import WatchKit
import Foundation

class TasksInterfaceController: WKInterfaceController {
  @IBOutlet var addTaskButton: WKInterfaceButton!
  @IBOutlet var ongoingTable: WKInterfaceTable!
  
  @IBOutlet var completedLabel: WKInterfaceLabel!
  @IBOutlet var completedTable: WKInterfaceTable!
  
  var tasks: TaskList = TaskList()
  
  override func awake(withContext context: Any?) {
    super.awake(withContext: context)
    loadSavedTasks()
    
    loadOngoingTasks()
    loadCompletedTasks()
  }
  
  override func willActivate() {
    // This method is called when watch view controller is about to be visible to user
    super.willActivate()
    updateOngoingTasksIfNeeded()
  }
  
  override func didDeactivate() {
    // This method is called when watch view controller is no longer visible
    super.didDeactivate()
  }
  
  @IBAction func onNewTask() {
    presentController(withName: NewTaskInterfaceController.ControllerName, context: tasks)
  }

  override func didAppear() {
    super.didAppear()
    animateInTableRows()
  }

  func animateInTableRows() {
    animate(withDuration:0.6) {
      for i in 0..<self.ongoingTable.numberOfRows {
        let row = self.ongoingTable.rowController(at:i)
          as! OngoingTaskRowController
        row.spacerGroup.setWidth(0)
        row.progressBackgroundGroup.setAlpha(1)
      }
    }
  }
}

// MARK: Table Interaction
extension TasksInterfaceController {
  override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
    guard table === ongoingTable else { return }
    
    let task = tasks.ongoingTasks[rowIndex]
    tasks.didTask(task)
    if task.isCompleted {
      // 1
      ongoingTable.removeRows(at: IndexSet(integer: rowIndex))

      // 2
      let newRowIndex = tasks.completedTasks.count-1
      completedTable.insertRows(at:
        IndexSet(integer: newRowIndex),
        withRowType: CompletedTaskRowController.RowType)

      // 3
      let row = completedTable.rowController(at: newRowIndex) as!
      CompletedTaskRowController
      row.populate(with: task)

      // 4
      self.updateAddTaskButton()
      self.updateCompletedLabel()

      // 5
      self.completedTable.scrollToRow(at: newRowIndex)
    }
    else {
      let row = ongoingTable.rowController(at: rowIndex) as! OngoingTaskRowController
      animate(withDuration:0.4) {
        row.updateProgress(with:task,
                           frameWidth:self.contentFrame.size.width)
      }
    }
    saveTasks()
  }
}

// MARK: Populate Tables
extension TasksInterfaceController {
  func loadOngoingTasks() {
    ongoingTable.setNumberOfRows(tasks.ongoingTasks.count, withRowType: OngoingTaskRowController.RowType)
    for i in 0..<ongoingTable.numberOfRows {
      let row = ongoingTable.rowController(at: i) as! OngoingTaskRowController
      let task = tasks.ongoingTasks[i]
      row.populate(with:task, frameWidth:contentFrame.size.width)
    }
    
    updateAddTaskButton()
  }
  
  func updateOngoingTasksIfNeeded() {
    if ongoingTable.numberOfRows < tasks.ongoingTasks.count {
      // 1
      let newRowIndex = tasks.ongoingTasks.count-1
      ongoingTable.insertRows(at: IndexSet(integer: newRowIndex),
                              withRowType: OngoingTaskRowController.RowType)

      // 2
      let row = ongoingTable.rowController(at:newRowIndex) as!
        OngoingTaskRowController
      row.populate(with: tasks.ongoingTasks.last!,
                   frameWidth: contentFrame.size.width)

      saveTasks()
      updateAddTaskButton()
    }
  }
  
  func loadCompletedTasks() {
    completedTable.setNumberOfRows(tasks.completedTasks.count, withRowType: CompletedTaskRowController.RowType)
    for i in 0..<completedTable.numberOfRows {
      let row = completedTable.rowController(at: i) as! CompletedTaskRowController
      let task = tasks.completedTasks[i]
      row.populate(with:task)
    }
    
    updateCompletedLabel()
  }
  
  func updateCompletedLabel() {
    completedLabel.setHidden(completedTable.numberOfRows == 0)
  }
  
  func updateAddTaskButton() {
    // 1
    addTaskButton.setHidden(ongoingTable.numberOfRows != 0)

    if (ongoingTable.numberOfRows == 0) {
      // 2
      addTaskButton.setAlpha(0)
      // 3
      animate(withDuration: 0.4) {
        self.addTaskButton.setAlpha(1)
      }
    }
  }
}

// MARK: Task Persistance
extension TasksInterfaceController {
  private var savedTasksPath: String {
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let docPath = paths.first!
    return (docPath as NSString).appendingPathComponent("SavedTasks")
  }
  
  func loadSavedTasks() {
    if let data = try? Data(contentsOf: URL(fileURLWithPath: savedTasksPath)) {
      let savedTasks = NSKeyedUnarchiver.unarchiveObject(with: data) as! TaskList
      tasks = savedTasks
    } else {
      tasks = TaskList()
    }
  }
  
  func saveTasks() {
    NSKeyedArchiver.archiveRootObject(tasks, toFile: savedTasksPath)
  }
}
