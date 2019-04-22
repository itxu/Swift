

import WatchKit

class AudioPlayerInterfaceController: WKInterfaceController {
  
  private var player: WKAudioFilePlayer!
  private var asset: WKAudioFileAsset!
  private var statusObserver: NSKeyValueObservation?
  private var timer: Timer!

  @IBOutlet private var playButton: WKInterfaceButton!
  @IBOutlet private var interfaceTimer: WKInterfaceTimer!
  @IBOutlet private var titleLabel: WKInterfaceLabel!

  override func awake(withContext context: Any?) {
    super.awake(withContext: context)
    let memo = context as! VoiceMemo
    asset = WKAudioFileAsset(url: memo.url)
    titleLabel.setText(memo.filename)
    playButton.setEnabled(false)
  }
  
  override func didAppear() {
    super.didAppear()
    prepareToPlay()
  }
  
  @IBAction func playButtonTapped() {
    prepareToPlay()
  }
  
  private func prepareToPlay() {
    // 1
    let playerItem = WKAudioFilePlayerItem(asset: asset)
    // 2
    player = WKAudioFilePlayer(playerItem: playerItem)
    // 3
    statusObserver = player.observe(
      \.status,
      changeHandler: { [weak self] (player, change) in
        // 4
        guard
          player.status == .readyToPlay,
          let duration = self?.asset.duration
          else { return }
        // 5
        let date = Date(timeIntervalSinceNow: duration)
        self?.interfaceTimer.setDate(date)
        // 6
        self?.playButton.setEnabled(false)
        // 7
        player.play()
        self?.interfaceTimer.start()
        // 8
        self?.timer = Timer.scheduledTimer(withTimeInterval: duration, repeats: false, block: { _ in
          self?.playButton.setEnabled(true)
        })
    })
  }
}

