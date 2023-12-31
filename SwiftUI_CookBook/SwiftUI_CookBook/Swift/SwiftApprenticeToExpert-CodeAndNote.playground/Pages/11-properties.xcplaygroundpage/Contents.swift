/*:
 ![method-or-computed-property](method-or-computed-property.png)
 */

import Foundation

//: ## Chapter 11: Properties

struct Car {
  let make: String
  let color: String
}

struct Contact {
  var fullName: String
  let emailAddress: String
  var relationship = "Friend"
}

var person = Contact(fullName: "Grace Murray",
                     emailAddress: "grace@navy.mil")
person.relationship // Friend

var boss = Contact(fullName: "Ray Wenderlich",
                   emailAddress: "ray@raywenderlich.com",
                   relationship: "Boss")

person.fullName // Grace Murray
person.emailAddress // grace@navy.mil

person.fullName = "Grace Hopper"
person.fullName // Grace Hopper

//person.emailAddress = "grace@gmail.com" // Error!

struct TV {
  var height: Double
  var width: Double
  
  var diagonal: Int {
    get {
      let result = (height * height + width * width).squareRoot().rounded()
      return Int(result)
    }
    set {
      let ratioWidth = 16.0
      let ratioHeight = 9.0
      let ratioDiagonal = (ratioWidth * ratioWidth + ratioHeight * ratioHeight).squareRoot()
      height = Double(newValue) * ratioHeight / ratioDiagonal
      width = height * ratioWidth / ratioHeight
    }
  }
}

var tv = TV(height: 53.93, width: 95.87)
tv.diagonal // 110

tv.width = tv.height
tv.diagonal

tv.diagonal = 70
tv.height // 34.32...
tv.width // 61.01...

struct Level {
  static var highestLevel = 1
  let id: Int
  var boss: String
  var unlocked: Bool {
    didSet {
      if unlocked && id > Self.highestLevel {
        Self.highestLevel = id
      }
    }
  }
}

let level1 = Level(id: 1, boss: "Chameleon", unlocked: true)
let level2 = Level(id: 2, boss: "Squid", unlocked: false)
let level3 = Level(id: 3, boss: "Chupacabra", unlocked: false)
let level4 = Level(id: 4, boss: "Yeti", unlocked: false)

// Error: you can't access a type property on an instance
//let highestLevel = level3.highestLevel

Level.highestLevel // 1

struct LightBulb {
  static let maxCurrent = 40
  var current = 0 {
    didSet {
      if current > Self.maxCurrent {
        print("""
              Current is too high,
              falling back to previous setting.
              """)
        current = oldValue
      }
    }
  }
}


var light = LightBulb()
light.current = 50
light.current // 0
light.current = 40
light.current // 40

struct Circle {
  lazy var pi = {
    ((4.0 * atan(1.0 / 5.0)) - atan(1.0 / 239.0)) * 4.0
  }()
  var radius = 0.0
  var circumference: Double {
    // 由于 的值发生pi变化，因此circumferencegetter 必须标记为mutating。
    mutating get {
      pi * radius * 2
    }
  }
  init(radius: Double) {
    self.radius = radius
  }
}

var circle = Circle(radius: 5) // got a circle, pi has not been run
circle.circumference // 31.42
// also, pi now has a value
