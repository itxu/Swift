
import ClockKit

class ComplicationController: NSObject, CLKComplicationDataSource {

  // MARK: Register
  func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Swift.Void) {
    // 1
    if complication.family == .utilitarianSmall {
      // 2
      let smallFlat = CLKComplicationTemplateUtilitarianSmallFlat()
      // 3
      smallFlat.textProvider = CLKSimpleTextProvider(text: "+2.6m")
      // 4
      smallFlat.imageProvider = CLKImageProvider(
        onePieceImage: UIImage(named: "tide_high")!)
      // 5
      handler(smallFlat)
    } else if complication.family == .utilitarianLarge {
      let largeFlat = CLKComplicationTemplateUtilitarianLargeFlat()
      largeFlat.textProvider = CLKSimpleTextProvider(
        text: "Rising, +2.6m", shortText:"+2.6m")
      largeFlat.imageProvider = CLKImageProvider(
        onePieceImage: UIImage(named: "tide_high")!)

      handler(largeFlat)
    }
  }

  // MARK: Provide Data
  public func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
    let conditions = TideConditions.loadConditions()
    guard let waterLevel = conditions.currentWaterLevel else {
      // No data is cached yet
      handler(nil)
      return
    }

    let tideImageName: String
    switch waterLevel.situation {
    case .High: tideImageName = "tide_high"
    case .Low: tideImageName = "tide_low"
    case .Rising: tideImageName = "tide_rising"
    case .Falling: tideImageName = "tide_falling"
    default: tideImageName = "tide_high"
    }

    // 1
    if complication.family == .utilitarianSmall {
      let smallFlat = CLKComplicationTemplateUtilitarianSmallFlat()
      smallFlat.textProvider = CLKSimpleTextProvider(
        text: waterLevel.shortTextForComplication)
      smallFlat.imageProvider = CLKImageProvider(
        onePieceImage: UIImage(named: tideImageName)!)

      // 2
      handler(CLKComplicationTimelineEntry(
        date: waterLevel.date, complicationTemplate: smallFlat))
    } else {
      let largeFlat = CLKComplicationTemplateUtilitarianLargeFlat()
      largeFlat.textProvider = CLKSimpleTextProvider(
        text: waterLevel.longTextForComplication,
        shortText:waterLevel.shortTextForComplication)
      largeFlat.imageProvider = CLKImageProvider(
        onePieceImage: UIImage(named: tideImageName)!)

      handler(CLKComplicationTimelineEntry(
        date: waterLevel.date, complicationTemplate: largeFlat))
    }
  }

  // MARK: Time Travel
  func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Swift.Void) {
    handler([])
  }

}
