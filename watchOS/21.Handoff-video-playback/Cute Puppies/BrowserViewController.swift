
import UIKit
import AVKit
import AVFoundation

class BrowserViewController: UICollectionViewController {
  
  // MARK: Properties - private
  
  private let provider = VideoClipProvider()
  
  /// A array of AVAsset for each video clip in the bundle.
  private let videoAssets: [AVAsset]
  
  // MARK: Life Cycle
  
  required init?(coder aDecoder: NSCoder) {
    var assets: [AVAsset] = []
    for clip in provider.clips {
      let asset = AVAsset.init(url: clip)
      assets.append(asset)
    }
    videoAssets = assets
    super.init(coder: aDecoder)
  }
  
  override var prefersStatusBarHidden: Bool {
    get {
      return true
    }
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    coordinator.animate(alongsideTransition: { (_: UIViewControllerTransitionCoordinatorContext) in
      self.collectionView?.reloadData()
    }, completion: nil)
  }
  
  // MARK: Private
  
  /// Plays a video clip at a given index.
  private func playClip(at index: Int) {
    let asset = videoAssets[index]
    presentVideoPlayer(withAsset: asset)
  }
  
  /// Presents a video player view controller to playback a given AVAsset.
  private func presentVideoPlayer(withAsset asset: AVAsset) {
    let item = AVPlayerItem(asset: asset)
    let player = AVPlayer(playerItem: item)
    let controller = AVPlayerViewController()
    controller.player = player
    controller.modalPresentationStyle = .formSheet
    present(controller, animated: true) {
      player.play()
    }
  }
  
  /// Dismiss a video player (if any) and finally calls on the completion block.
  private func dismissVideoPlayer(completion: (() -> Void)?) {
    if let presentedViewController = presentedViewController {
      presentedViewController.dismiss(animated: true, completion: completion)
    } else {
      completion?()
    }
  }
  
  // MARK: Handoff
  
  override func restoreUserActivityState(_ activity: NSUserActivity) {
    super.restoreUserActivityState(activity)
    
    // Try to restore state.
    guard let userInfo = activity.userInfo else { return }
    
    switch activity.activityType {
    case Handoff.Activity.viewHome.stringValue:
      dismissVideoPlayer(completion: nil)
      
    case Handoff.Activity.playClip.stringValue:
      guard let index = userInfo[Handoff.activityValueKey] as? Int else { return }
      dismissVideoPlayer(completion: {
        self.playClip(at: index)
      })
      
    default:
      break
    }
  }
  
}

// MARK: UICollectionViewDataSource

extension BrowserViewController {
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    let count = videoAssets.count
    return count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PreviewCell.IBIdentifier, for: indexPath) as! PreviewCell
    cell.asset = videoAssets[indexPath.item]
    cell.footnote = provider.quotes[indexPath.row]
    return cell
  }
}

// MARK: UICollectionViewDelegate

extension BrowserViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    playClip(at: indexPath.item)
  }
}

// MARK: UICollectionViewDelegateFlowLayout

extension BrowserViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let collectionViewWidth = collectionView.bounds.size.width
    let collectionViewHeight = collectionView.bounds.size.height
    
    let size: CGSize
    if collectionViewWidth >= collectionViewHeight {
      size = CGSize(width: 328, height: 249)
    } else {
      size = CGSize(width: 375, height: 275)
    }
    return size
  }
}
