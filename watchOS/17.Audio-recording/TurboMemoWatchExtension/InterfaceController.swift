
import WatchKit

enum InterfaceState {
  case instantiated
  case awake
  case initialized
}

class InterfaceController: WKInterfaceController, MemoStoreObserver {
  
  /// A group that's shown when the controller doesn't have valid content, e.g. there is no voice or video memo.
  /// invalidContentGroup and validContentGroup are mutually exclusive and are not shown at the same time.
  @IBOutlet private var invalidContentGroup: WKInterfaceGroup!
  
  /// A group that's shown when there is content.
  /// invalidContentGroup and validContentGroup are mutually exclusive and are not shown at the same time.
  @IBOutlet private var validContentGroup: WKInterfaceGroup!
  
  /// The interface table where content is shown.
  @IBOutlet private var interfaceTable: WKInterfaceTable!
  
  private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "hh:mma\nMM/dd/yyyy"
    return dateFormatter
  }()
  
  var memos: [VoiceMemo] = []
  var interfaceState = InterfaceState.instantiated
  
  override func awake(withContext context: Any?) {
    super.awake(withContext: context)
    interfaceState = .awake
  }
  
  override func willActivate() {
    super.willActivate()
    MemoStore.shared.registerObserver(self)
  }
  
  override func didDeactivate() {
    super.didDeactivate()
    MemoStore.shared.unregisterObserver(self)
  }
  
  override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
    let memo = memos[rowIndex]
    presentController(withName: "AudioPlayerInterfaceController", context: memo)
  }
  
  // MARK: Helper
  
  /// The designated helper method to reload and update the entire interface when the data source is updated.
  func reloadInterface() {
    updateVisiblityOfInterfaceContentGroups { () -> Void in
      self.updateInterfaceTableRowCounts(completion: { () -> Void in
        self.updateInterfaceTableData()
      })
    }
  }
  
  /// A helper method to change and update visiblity of WKInterfaceGroup objects based on content.
  func updateVisiblityOfInterfaceContentGroups(completion: @escaping () -> Void) {
    let hasContent = (memos.count != 0)
    validContentGroup.setHidden(!hasContent)
    invalidContentGroup.setHidden(hasContent)
    DispatchQueue.main.async(execute: completion)
  }
  
  /// A helper method to initialize or update the number of rows in the interface table.
  func updateInterfaceTableRowCounts(completion: @escaping () -> Void) {
    switch interfaceState {
    case .instantiated:
      break
      
    case .awake:
      fallthrough
      
    case .initialized:
      interfaceTable.setNumberOfRows(memos.count, withRowType: "MemoRowController")
      interfaceState = .initialized
    }
    DispatchQueue.main.async(execute: completion)
  }
  
  /// A helper method to set and update content of the interface table
  func updateInterfaceTableData() {
    for (index, memo) in memos.enumerated() {
      let controller = interfaceTable.rowController(at: index) as! MemoRowController
      let dateString = dateFormatter.string(from: memo.date)
      controller.textLabel.setText(dateString)
    }
  }
  
  // MARK: MemoStoreObserver
  
  func memoStore(store: MemoStore, didUpdateMemos memos: [VoiceMemo]) {
    self.memos = memos
    reloadInterface()
  }
  
  // MARK: Recording
  
  @IBAction private func addVoiceMemoMenuItemTapped() {
    let outputURL = MemoFileNameHelper.newOutputURL()
    let preset = WKAudioRecorderPreset.narrowBandSpeech
    let options: [String : Any] = [WKAudioRecorderControllerOptionsMaximumDurationKey: 30]
    
    presentAudioRecorderController(
      withOutputURL: outputURL,
      preset: preset,
      options: options) { [weak self] (didSave: Bool, error: Error?) in
        print("Did save? \(didSave) - Error: \(String(describing: error))")
        guard didSave else { return }
        self?.processRecordedAudio(at: outputURL)
    }
  }
  
  private func processRecordedAudio(at url: URL) {
    let voiceMemo = VoiceMemo(filename: url.lastPathComponent, date: Date())
    MemoStore.shared.add(memo: voiceMemo)
    MemoStore.shared.save()
  }
  
}

