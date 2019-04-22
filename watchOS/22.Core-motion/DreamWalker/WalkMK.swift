
import Foundation
import MapKit
import Contacts

extension Walk: MKAnnotation {
  var title: String? {
    return walkTitle
  }
  var subtitle: String? {
    return location
  }
  var coordinate: CLLocationCoordinate2D {
    return mapCoordinates
  }
  
  // map button opens this mapItem in Maps app
  func mapItem() -> MKMapItem {
    let addressDictionary = [CNPostalAddressStreetKey: subtitle!]
    let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
    
    let mapItem = MKMapItem(placemark: placemark)
    mapItem.name = title
    
    return mapItem
  }

}
