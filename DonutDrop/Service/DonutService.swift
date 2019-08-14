import UIKit

class DonutService {
    
    let donutImages: [UIImage]
    let count: Int
    
    init() {
        var images = [UIImage]()
        Donuts.allCases.forEach {
            images.append($0.image)
        }
        donutImages = images
        count = images.count
    }
    
    func randomDonutImage() -> UIImage {
        let randomNum = Int.random(in: 0..<9)
        return donutImages[randomNum]
    }
    
}
