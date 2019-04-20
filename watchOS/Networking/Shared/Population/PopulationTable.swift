
import Foundation

class PopulationTable : Decodable {
  let data:[PopulationData]
  var malePopulationByDecade: [Int]
  var femalePopulationByDecade: [Int]

  required public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    data = try container.decode(Array.self)

    malePopulationByDecade = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    femalePopulationByDecade = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

    for popData in self.data {
      let index: Int = popData.ageCohort / 10
      malePopulationByDecade[index] += popData.malesPopulation
      femalePopulationByDecade[index] += popData.femalesPopulation
    }
  }
}
