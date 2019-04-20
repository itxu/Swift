
import Foundation

class WorldPopulationService: WebService {
  private let baseURL = URL(string: "http://api.population.io")!
  
  init () {
    super.init(rootURL: baseURL)
  }
  
  /**
   Gets a `PopulationRank` object from the population.io `wp-rank` Web Service.
   
   **Note:** The GET request will have a URL pattern like the following:
   
   ```
   /wp-rank/{dob}/{sex}/{country}/today/
   ```
   - parameter configuration: A configuration object that contains, gender, age and country information
   - parameter completion: A completion block that returns the rank data or an error
   */
  func getRankInCountry(_ configuration: PopulationConfiguration,
                        completion: @escaping (_ rank:PopulationRank?, _ error: Error?) -> Void) {
    
    // GET /wp-rank/{dob}/{sex}/{country}/today/
    let path = "/1.0/wp-rank/\(configuration.dobString)/\(configuration.gender.serviceKey)/\(configuration.country)/today/"
    let encodedPath = path.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)
    executeRequest(encodedPath!) { (response: PopulationRank?, error: Error?) in

      // Make sure you get a dictionary back
      guard let response = response else {
        completion(nil, error)
        return
      }
      
      // Convert the parsed dictionary to a real object
      completion(response, error)
    }
  }
  
  /**
   Gets a `LifeExpectancy` object from the population.io `life-expectancy` Web Service.
   
   **Note:** The GET request will have a URL pattern like the following:
   
   ```
   /life-expectancy/total/{sex}/{country}/{dob}/
   ```
   - parameter configuration: A configuration object that contains, gender, age and country information
   - parameter completion: A completion block that returns the life expectancy data or an error
   */
  func getLifeExpectancy(_ configuration: PopulationConfiguration,
                         completion: @escaping (_ expectancy:LifeExpectancy?, _ error: Error?) -> Void) {
    
    let path = "/1.0/life-expectancy/total/\(configuration.gender.serviceKey)/\(configuration.country)/\(configuration.dobString)/"
    let encodedPath = path.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)
    executeRequest(encodedPath!) { (response: LifeExpectancy? , error: Error?) -> Void in
      
      // Make sure you get a dictionary back
      guard let response = response else {
        completion(nil, error)
        return
      }
      
      // Convert the parsed dictionary to a real object
      completion(response, error)
    }
  }
  
  /**
   Gets a `PopulationTable` object from the population.io `population` Web Service.
   
   **Note:** The GET request will have a URL pattern like the following:
   
   ```
   /population/{year}/{country}/
   ```
   - parameter configuration: A configuration object that contains, gender, age and country information
   - parameter completion: A completion block that returns a table of population data or an error
   */
  func getPopulationTable(_ year: Int, country: String,
                          completion: @escaping (_ table:PopulationTable?, _ error: Error?) -> Void) {
    
    // 1
    let path = "/1.0/population/\(year)/\(country)"
    
    // 2
    let encodedPath = path.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)
    
    // 3
    executeRequest(encodedPath!) { (response: PopulationTable?, error: Error?) -> Void in

      // 4
      // Make sure you get an array back
      guard let response = response else {
        completion(nil, error)
        return
      }
      
      // 5
      completion(response, error)
    }
  }
}
