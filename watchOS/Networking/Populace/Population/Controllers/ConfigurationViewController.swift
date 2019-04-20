

import UIKit

protocol ConfigurationControllerDelegate: class {
  
  /// This method is called when a configuration is saved by the controller
  func configurationController(_ controller: ConfigurationViewController,
    didUpdateConfiguration configuration: PopulationConfiguration)
  
  /// This method is called when a configuration is saved by the controller
  func configurationController(_ controllerDidCancel: ConfigurationViewController)
}


class ConfigurationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
  
  // MARK: - ****** Models ******
  
  weak var delegate: ConfigurationControllerDelegate?
  var localConfiguration: PopulationConfiguration?
  
  // MARK: - ****** UI ******
  
  @IBOutlet var table: UITableView!
  @IBOutlet var datePicker: UIPickerView!
  
  
  // MARK: - ****** Lifecycle ******

  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    if localConfiguration == nil {
      localConfiguration = PopulationConfiguration()
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
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
  

  // MARK: - ****** UIPickerViewDelegate ******

  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    if component == 0 {
      localConfiguration?.dobMonth = row + 1
    } else {
      localConfiguration?.dobYear = yearOptions[row]
    }
  }
  
  
  // MARK: - ****** UIPickerViewDataSource ******

  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 2
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    if component == 0 {
      return monthOptions.count
    } else {
      return yearOptions.count
    }
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    if component == 0 {
      return monthOptions[row]
    } else {
      return "\(yearOptions[row])"
    }
  }
  
  // MARK: - ****** Table view data source ******
  
  let kGenderSection = 0
  let kCountrySection = 1
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case kGenderSection:
      return Gender.allValues.count
    case kCountrySection:
      return countryOptions.count
    default: return 0
    }
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if section == kGenderSection {
      return "Select Your Gender"
    } else if section == kCountrySection {
      return "Select Your Country of Birth"
    }
    return nil
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell", for: indexPath)
    if (indexPath as NSIndexPath).section == kGenderSection {
      cell.textLabel?.text = Gender.allValues[(indexPath as NSIndexPath).row].rawValue
      if let index = Gender.allValues.index(of: localConfiguration!.gender) , index == (indexPath as NSIndexPath).row {
        genderSelectedIndex = index
        cell.accessoryType = .checkmark
      } else {
        cell.accessoryType = .none
      }
    } else {
      cell.textLabel?.text = countryOptions[(indexPath as NSIndexPath).row]
      if let index = countryOptions.index(of: localConfiguration!.country) , index == (indexPath as NSIndexPath).row {
        countrySelectedIndex = index
        cell.accessoryType = .checkmark
      } else {
        cell.accessoryType = .none
      }
    }
    
    return cell
  }

  
  // MARK: - UITableViewDelegate
  
  var genderSelectedIndex = 0
  var countrySelectedIndex = 0
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    var previousItemIndex: Int
    
    // Get the correct index and set values
    if (indexPath as NSIndexPath).section == kGenderSection {
      previousItemIndex = genderSelectedIndex
      genderSelectedIndex = (indexPath as NSIndexPath).row
      localConfiguration?.gender = Gender.allValues[genderSelectedIndex]
    } else {
      previousItemIndex = countrySelectedIndex
      countrySelectedIndex = (indexPath as NSIndexPath).row
      localConfiguration?.country = countryOptions[countrySelectedIndex]
    }

    // Remove the old checkmark
    let cell = tableView.cellForRow(at: IndexPath(row: previousItemIndex, section: (indexPath as NSIndexPath).section))
    cell?.accessoryType = .none
    
    // Set the new checkmark
    let newCell = tableView.cellForRow(at: indexPath)
    newCell?.accessoryType = .checkmark
    
  }
}
