import Foundation
import UIKit

class InflateBehavior : UIDynamicBehavior {
    static var maxInflation: CGFloat = 1.33 //max inflation in % of the original size
    static var minInflation: CGFloat = 0.66
    static var distThreshold: CGFloat = 100
    
    class func applyTransform(to view: UIView, withCenter point: CGPoint) {
        let d = CGFloat(distanceBetween(p1: view.center, p2: point))
        
        let diff: CGFloat = (InflateBehavior.maxInflation - InflateBehavior.minInflation)
        let startScale = InflateBehavior.minInflation + diff/2
        var scale: CGFloat = startScale + diff * (InflateBehavior.distThreshold/2 - d) / InflateBehavior.distThreshold/2
        if scale > InflateBehavior.maxInflation {
            scale = InflateBehavior.maxInflation
        } else if scale < InflateBehavior.minInflation {
            scale = InflateBehavior.minInflation
        }
        view.layer.transform = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
    }
    
    convenience init(view: UIView, point: CGPoint) {
        self.init()

        action = {InflateBehavior.applyTransform(to: view, withCenter: point)}
    }
}
