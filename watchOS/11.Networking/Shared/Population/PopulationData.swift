

import Foundation

protocol PopulationFactObject {
  var country: String {get}
  var populationFactString: String {get}
}

extension PopulationFactObject {
  var readableCountryName: String {
    switch country {
    case "World":                     return "the world"
    case "United States":             return "the United States"
    case "United Kingdom":            return "the United Kingdom"
    case "Rep of Korea":              return "South Korea"
    case "Dem Peoples Rep of Korea":  return "North Korean"
    case "Islamic Republic of Iran":  return "Iran"
      
    default: return country
    }
  }
}

struct PopulationRank : PopulationFactObject, Decodable {
  let gender: Gender
  let country: String
  let rank: Double

  var populationFactString: String {
    return "You are older than \(commaFormatter.string(from: NSNumber(value: rank))!) of the \(gender.genderNoun) in \(readableCountryName)."
  }

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		gender = try container.decode(Gender.self, forKey: .gender)
		country = try container.decode(String.self, forKey: .country)
		rank = try container.decode(Double.self, forKey: .rank)
	}

	private enum CodingKeys: String, CodingKey {
		case gender = "sex"
		case country
		case rank
	}
}

struct LifeExpectancy : PopulationFactObject, Decodable {
  let gender: Gender
  let country: String
  let lifeExpectancy: Double
  
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		gender = try container.decode(Gender.self, forKey: .gender)
		country = try container.decode(String.self, forKey: .country)
		lifeExpectancy = try container.decode(Double.self, forKey: .lifeExpectancy)
	}

	private enum CodingKeys: String, CodingKey {
		case gender = "sex"
		case country
		case lifeExpectancy = "total_life_expectancy"
	}

	var populationFactString: String {
    return "The life expectancy of \(gender.genderNoun) in \(readableCountryName) is \(numberFormatter.string(from: NSNumber(value: lifeExpectancy))!) years."
  }
}

struct PopulationData: Decodable {
  let year: Int
  let ageCohort: Int
  
  let totalPopulation: Int
  let malesPopulation: Int
  let femalesPopulation: Int

	private enum CodingKeys: String, CodingKey {
		case year = "year"
		case ageCohort = "age"
		case totalPopulation = "total"
		case malesPopulation = "males"
		case femalesPopulation = "females"
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		year = try container.decode(Int.self, forKey: .year)
		ageCohort = try container.decode(Int.self, forKey: .ageCohort)
		totalPopulation = try container.decode(Int.self, forKey: .totalPopulation)
		malesPopulation = try container.decode(Int.self, forKey: .malesPopulation)
		femalesPopulation = try container.decode(Int.self, forKey: .femalesPopulation)
	}
}

