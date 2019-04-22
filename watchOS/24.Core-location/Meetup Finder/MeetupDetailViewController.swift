
import UIKit

class MeetupDetailViewController: UITableViewController {
  
  @IBOutlet private var meetupDetailCell: MeetupDetailCell!
  @IBOutlet private var mapViewCell: UITableViewCell!
  var meetup: Meetup?
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if let meetup = meetup {
      meetupDetailCell.nameLabel.text = meetup.group.name
      meetupDetailCell.locationLabel.text = meetup.location.city + ", " + meetup.location.state
      meetupDetailCell.eventLabel.text = meetup.nextEvent.name
      meetupDetailCell.descriptionLabel.text = meetup.group.description
      meetupDetailCell.membersLabel.text = "\(meetup.group.numberOfMembers)"
    }
  }
}
