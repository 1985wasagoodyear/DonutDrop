import UIKit

class DonutService {
    
    private let donutImages: [UIImage]
    private var count: Int
    private let allDonutCases = Donuts.allCases
    private let allDonutCount = Donuts.allCases.count
    
    init() {
        var images = [UIImage]()
        var count = 0
        allDonutCases.forEach {
            images.append($0.image)
            count += 1
        }
        donutImages = images
        self.count = count
    }
    
    func randomDonutImage() -> UIImage {
        let randomNum = Int.random(in: 0..<allDonutCount)
        return donutImages[randomNum]
    }
    
}
