
import Foundation

class Movie {
  var id: String
  var time: String
  var title: String
  var synopsis: String
  var poster: String
  var director: String
  var actors: String
  
  init(dictionary:NSDictionary, time: String) {
    self.id = dictionary["id"] as! String
    self.time = time
    self.title = dictionary["title"] as! String
    self.synopsis = dictionary["synopsis"] as! String
    self.poster = dictionary["poster"] as! String
    self.director = dictionary["director"] as! String
    self.actors =  dictionary["actors"] as! String
  }
}
