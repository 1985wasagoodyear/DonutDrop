import UIKit

extension Donuts {
    var image: UIImage {
        guard let im = UIImage(named: self.rawValue) else {
            fatalError("\(self.rawValue) not found!")
        }
        return im
    }
}

extension CGFloat {
    static func *(lhs: CGFloat, rhs: Int) -> CGFloat {
        return lhs * CGFloat(rhs)
    }
    static func *(lhs: Int, rhs: CGFloat) -> CGFloat {
        return CGFloat(lhs) * rhs
    }
    static func -(lhs: CGFloat, rhs: Double) -> CGFloat {
        return lhs - CGFloat(rhs)
    }
    static func -(lhs: Double, rhs: CGFloat) -> CGFloat {
        return CGFloat(lhs) - rhs
    }
    static func +(lhs: CGFloat, rhs: Double) -> CGFloat {
        return lhs + CGFloat(rhs)
    }
    static func +(lhs: Double, rhs: CGFloat) -> CGFloat {
        return CGFloat(lhs) + rhs
    }
}
