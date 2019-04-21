import Foundation

struct Photo {
  
  let imageName: String
  let username: String
  let timePosted: String
  let comment: String
  
  static var samplePhotos: [Photo] {
    return [
      Photo(imageName: "wwdc", username: "@ryannystrom", timePosted: "13m", comment: "I absolutely loved my first visit to WWDC! Can't wait to go back next year!"),
      Photo(imageName: "clouds", username: "@rwenderlich", timePosted: "59m", comment: "Some crazy looking clouds overhead tonight."),
      Photo(imageName: "gourmet", username: "@micpringle", timePosted: "4h", comment: "Check out this crazy dish I had tonight. This place is too fancy!"),
      Photo(imageName: "pizza", username: "@JackTripleU", timePosted: "16h", comment: "So. Much. Pizza."),
      Photo(imageName: "vineyard", username: "@moayes", timePosted: "2d", comment: "Beautiful afternoon to go and visit a winery. Rolling hills and wonderful people. The wine isn't too bad either!")
    ]
  }
  
}
