
import Foundation
import HealthKit

extension WorkoutSessionService {
  
  fileprivate func genericSamplePredicate (withStartDate start: Date) -> NSPredicate {
    let datePredicate = HKQuery.predicateForSamples(withStart: start, end: nil, options: .strictStartDate)
    let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()])
    return NSCompoundPredicate(andPredicateWithSubpredicates: [datePredicate, devicePredicate])
  }
  
  internal func heartRateQuery(withStartDate start: Date) -> HKQuery {
    // Query all HR samples from the beginning of the workout session on the current device
    let predicate = genericSamplePredicate(withStartDate: start)
    
    let query:HKAnchoredObjectQuery = HKAnchoredObjectQuery(type: hrType,
      predicate: predicate,
      anchor: hrAnchorValue,
      limit: Int(HKObjectQueryNoLimit)) {
        (query, sampleObjects, deletedObjects, newAnchor, error) in

        self.hrAnchorValue = newAnchor
        self.newHRSamples(sampleObjects)
    }
    
    query.updateHandler = {(query, samples, deleteObjects, newAnchor, error) in
      self.hrAnchorValue = newAnchor
      self.newHRSamples(samples)
    }

    return query
  }
  
  fileprivate func newHRSamples(_ samples: [HKSample]?) {
    // Abort if the data isn't right
    guard let samples = samples as? [HKQuantitySample], samples.count > 0 else {
      return
    }
    
    DispatchQueue.main.async {
      self.hrData += samples
      if let hr = samples.last?.quantity {
        self.heartRate = hr
        self.delegate?.workoutSessionService(self, didUpdateHeartrate: hr.doubleValue(for: hrUnit))
      }
    }
  }
  
  internal func distanceQuery(withStartDate start: Date) -> HKQuery {
    // Query all distance samples from the beginning of the workout session on the current device
    let predicate = genericSamplePredicate(withStartDate: start)
    
    let query = HKAnchoredObjectQuery(type: distanceType,
      predicate: predicate,
      anchor: distanceAnchorValue,
      limit: Int(HKObjectQueryNoLimit)) {
        (query, samples, deleteObjects, anchor, error) in
        
        self.distanceAnchorValue = anchor
        self.newDistanceSamples(samples)
    }
    
    query.updateHandler = {(query, samples, deleteObjects, newAnchor, error) in
      self.distanceAnchorValue = newAnchor
      self.newDistanceSamples(samples)
    }
    return query
  }
  
  internal func newDistanceSamples(_ samples: [HKSample]?) {
    // Abort if the data isn't right
    guard let samples = samples as? [HKQuantitySample], samples.count > 0 else {
      return
    }
    
    DispatchQueue.main.async {
      self.distance = self.distance.addSamples(samples, unit: distanceUnit)
      self.distanceData += samples
      
      self.delegate?.workoutSessionService(self, didUpdateDistance: self.distance.doubleValue(for: distanceUnit))
    }
  }
  
  internal func energyQuery(withStartDate start: Date) -> HKQuery {
    // Query all Energy samples from the beginning of the workout session on the current device
    let predicate = genericSamplePredicate(withStartDate: start)
    
    let query = HKAnchoredObjectQuery(type: energyType,
      predicate: predicate,
      anchor: energyAnchorValue,
      limit: 0) {
        (query, sampleObjects, deletedObjects, newAnchor, error) in
        
        self.energyAnchorValue = newAnchor
        self.newEnergySamples(sampleObjects)
    }
    
    query.updateHandler = {(query, samples, deleteObjects, newAnchor, error) in
      self.energyAnchorValue = newAnchor
      self.newEnergySamples(samples)
    }
    
    return query
  }
  
  internal func newEnergySamples(_ samples: [HKSample]?) {
    // Abort if the data isn't right
    guard let samples = samples as? [HKQuantitySample], samples.count > 0 else {
      return
    }
    
    DispatchQueue.main.async {
      self.energyBurned = self.energyBurned.addSamples(samples, unit: energyUnit)
      self.energyData += samples
      
      self.delegate?.workoutSessionService(self, didUpdateEnergyBurned: self.energyBurned.doubleValue(for: energyUnit))
    }
  }
}
