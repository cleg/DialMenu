import Foundation
import UIKit

class InflateBehavior : UIDynamicBehavior {
    static var maxInflation: CGFloat = 1.33 //max inflation in % of the original size
    static var minInflation: CGFloat = 0.66
    static var distThreshold: CGFloat = 100
    
    var view: UIView?
    var point: CGPoint?  //a point close to which we inflate the view
    
    class func applyTransform(to view: UIView, withCenter point: CGPoint) {
        let d = CGFloat(distanceBetween(p1: view.center, p2: point))
        
        let diff:CGFloat = (InflateBehavior.maxInflation - InflateBehavior.minInflation)
        let startScale = InflateBehavior.minInflation + diff/2
        var scale: CGFloat = startScale + diff * (InflateBehavior.distThreshold/2 - d) / InflateBehavior.distThreshold/2
        if scale > InflateBehavior.maxInflation {
            scale = InflateBehavior.maxInflation
        } else if scale < InflateBehavior.minInflation {
            scale = InflateBehavior.minInflation
        }
        view.layer.transform = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
    }
    
    override init() {
        super.init()
        action = { [unowned self] in
            guard let view = self.view,
                let point = self.point else {
                    return
            }
            InflateBehavior.applyTransform(to: view, withCenter: point)
        }
    }
}
