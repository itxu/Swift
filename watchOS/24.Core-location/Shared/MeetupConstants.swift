
import Foundation

/// Meetups query radius in miles.
let MeetupQueryRadius: Double = 50

/// Since you're requesting meetups in a radius of 50 miles, here you consider 20 miles change in location a significant change that can potentially invalidate your data source. Conversion rate is 1 miles = 1609.34 meters.
let MeetupSignificantDistanceChange: Double = 20 * 1609.34

/// Assuming user travels maximum at a speed of 140 km/h, e.g. on a car, the user's location change will be 39 m/s. Since you consider approximately 32,000 meters (see MeetupSignificantDistanceChange) a significant change, the timeout will be approximately 15 minuntes.
let MeetupSignificantDistanceChangeTimeout: TimeInterval = 60 * 15

/// Maximum number of results per query you're interested.
let MeetupQueryPages = 25
