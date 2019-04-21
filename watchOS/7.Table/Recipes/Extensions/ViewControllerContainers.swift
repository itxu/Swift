import UIKit

extension UIViewController {

  func addSubViewController(_ controller: UIViewController) {
    addChildViewController(controller)
    controller.view.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(controller.view)

    view.addConstraint(NSLayoutConstraint(item: controller.view,
      attribute: .trailing, relatedBy: .equal, toItem: view,
      attribute: .trailing, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: controller.view,
      attribute: .leading, relatedBy: .equal, toItem: view,
      attribute: .leading, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: controller.view,
      attribute: .top, relatedBy: .equal, toItem: view,
      attribute: .top, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: controller.view,
      attribute: .bottom, relatedBy: .equal, toItem: view,
      attribute: .bottom, multiplier: 1, constant: 0))

    controller.didMove(toParentViewController: self)
  }

  func removeFromSuperViewController() {
    willMove(toParentViewController: nil)
    view.removeFromSuperview()
    removeFromParentViewController()
  }

}
