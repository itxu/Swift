import UIKit

struct Dog {
    var name: String!
    var age: Int!
    init(_ name: String, _ age: Int ){
        self.name = name
        self.age = age
    }
    
}

enum DogError: Error {
    case nameOutOfLength
    case ageOutOfRange
}

func checkAvailable(dog: Dog) throws -> Bool {
    if dog.name.count < 2 {
        throw DogError.nameOutOfLength
    }
    if dog.age > 5 {
        throw DogError.ageOutOfRange
    }
    return true
}
func woqu() {
let dog = Dog("ka", 4)
var a = false
do {
    try a = checkAvailable(dog: dog)
}catch{
    switch error {
    case DogError.nameOutOfLength:
        print("namefalse")
    case DogError.ageOutOfRange:
        print("agefalse")
    default:
        print("default")
    }
}
print(a)
}
woqu()
