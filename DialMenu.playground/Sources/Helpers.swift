import Foundation
import UIKit

func rndColor() -> UIColor {
    let red = CGFloat(arc4random_uniform(255))/255.0
    let green = CGFloat(arc4random_uniform(255))/255.0
    let blue = CGFloat(arc4random_uniform(255))/255.0
    return UIColor(red: red, green: green, blue: blue, alpha: 1)
}

func distanceBetween(p1 : CGPoint, p2 : CGPoint) -> CGFloat {
    let dx : CGFloat = p1.x - p2.x
    let dy : CGFloat = p1.y - p2.y
    return sqrt(dx * dx + dy * dy)
}
