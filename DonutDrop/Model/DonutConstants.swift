import Foundation

enum Donuts: String, CaseIterable {
    case one = "donut1.png"
    case two = "donut2.png"
    case three = "donut3.png"
    case four = "donut4.png"
    case five = "donut5.png"
    case six = "donut6.png"
    case seven = "donut7.png"
    case eight = "donut8.png"
    case nine = "donut9.png"
}

struct DonutConstants {
    private init() { }
    static let DONUT_INTERVAL: Double = 2.0
    static let DONUT_RATE: Double = 1.0 / 60.0
    static let DONUT_VELOCITY: Double = 10.0
    static let DONUT_SCORE_VALUE: Int = 10
    static let DONUT_WIDTH: Double = 75.0
    static let DONUT_LIFE_COUNT: Int = 3
}
