
import Foundation
import WatchKit

protocol ConfigurationControllerDelegate: class {

  /// This method is called when a configuration is saved by the controller
  func configurationController(_ controller: ConfigurationController,
    didUpdateConfiguration configuration: PopulationConfiguration)
  
  /// This method is called when a configuration is saved by the controller
  func configurationController(_ controllerDidCancel: ConfigurationController)
}

class ConfigurationContext {
  weak var delegate: ConfigurationControllerDelegate?
  var configuration: PopulationConfiguration?
}


class ConfigurationController : WKInterfaceController {
  
  // MARK: - ****** Models ******
  
  weak var delegate: ConfigurationControllerDelegate?
  var localConfiguration: PopulationConfiguration?
  
  // MARK: - ****** UI ******
  
  @IBOutlet var countryPicker: WKInterfacePicker!
  @IBOutlet var genderPicker: WKInterfacePicker!
  @IBOutlet var dateMonthPicker: WKInterfacePicker!
  @IBOutlet var dateYearPicker: WKInterfacePicker!
  
  // MARK: - ****** Lifecycle ******
  
  override func awake(withContext context: Any?) {
    super.awake(withContext: context)
    
    // Configure the Country Picker
    countryPicker.setItems(countryOptions.map { (country) -> WKPickerItem in
      let item = WKPickerItem()
      item.title = country
      return item
      })
    
    // Configure the Gender Picker
    genderPicker.setItems(Gender.allValues.map{ (gender) -> WKPickerItem in
      let item = WKPickerItem()
      item.title = gender.rawValue
      return item
      })
    
    // Date Pickers
    dateMonthPicker.setItems(monthOptions.map { (month) -> WKPickerItem in
      let item = WKPickerItem()
      item.title = month
      return item
      })
    dateYearPicker.setItems(yearOptions.map { (year) -> WKPickerItem in
      let item = WKPickerItem()
      item.title = "\(year)"
      return item
      })
    
    guard let context = context as? ConfigurationContext else {
      localConfiguration = PopulationConfiguration()
      countryPicker.setSelectedItemIndex(0)
      genderPicker.setSelectedItemIndex(0)
      return
    }
    
    delegate = context.delegate

    if let configuration = context.configuration {
      localConfiguration = configuration
    } else {
      localConfiguration = PopulationConfiguration()
    }
  
    if let index = countryOptions.index(of: localConfiguration!.country) {
      countryPicker.setSelectedItemIndex(index)
    } else {
      countryPicker.setSelectedItemIndex(0)
    }
    
    if let index = Gender.allValues.index(of: localConfiguration!.gender) {
      genderPicker.setSelectedItemIndex(index)
    } else {
      genderPicker.setSelectedItemIndex(0)
    }
    
    if let index = yearOptions.index(of: localConfiguration!.dobYear) {
      dateYearPicker.setSelectedItemIndex(index)
    } else {
      dateYearPicker.setSelectedItemIndex(0)
    }
    dateMonthPicker.setSelectedItemIndex(localConfiguration!.dobMonth-1)
}
  

  // MARK: - ****** Actions ******
  
  @IBAction func save(_ sender: AnyObject?) {
    if let delegate = delegate {
      delegate.configurationController(self, didUpdateConfiguration: localConfiguration!)
    }
  }
  
  @IBAction func cancel(_ sender: AnyObject?) {
    if let delegate = delegate {
      delegate.configurationController(self)
    }
  }
  
  @IBAction func pickGender(_ value: Int) {
    localConfiguration?.gender = Gender.allValues[value]
  }
  
  @IBAction func pickCountry(_ value: Int) {
    localConfiguration?.country = countryOptions[value]
  }
  
  @IBAction func pickYear(_ value: Int) {
    localConfiguration?.dobYear = yearOptions[value]
  }

  @IBAction func pickMonth(_ value: Int) {
    localConfiguration?.dobMonth = value + 1
  }
}
