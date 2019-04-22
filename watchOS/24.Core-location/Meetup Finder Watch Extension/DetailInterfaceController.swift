
import WatchKit

class DetailInterfaceController: WKInterfaceController {
  
  @IBOutlet private var groupTitleLable: WKInterfaceLabel!
  @IBOutlet private var groupLocationLabel: WKInterfaceLabel!
  @IBOutlet private var nextEventLabel: WKInterfaceLabel!
  @IBOutlet private var groupDescriptionLabel: WKInterfaceLabel!
  @IBOutlet private var groupColorGroup: WKInterfaceGroup!
  @IBOutlet private var groupMembersCount: WKInterfaceLabel!
  
  override func awake(withContext context: Any?) {
    super.awake(withContext: context)
    guard let meetup = context as? Meetup else { return }
    
    groupTitleLable.setText(meetup.group.name)
    groupLocationLabel.setText(meetup.location.city + ", " + meetup.location.state)
    nextEventLabel.setText(meetup.nextEvent.name)
    groupDescriptionLabel.setText(meetup.group.description)
    groupColorGroup.setBackgroundColor(meetup.group.color)
    groupMembersCount.setText("\(meetup.group.numberOfMembers) members")
    groupMembersCount.setTextColor(meetup.group.color)
  }
  
}
