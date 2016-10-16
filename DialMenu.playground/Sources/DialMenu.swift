import Foundation
import UIKit

public class DialMenu : UIView {
    public var itemViews: [MenuItem] = [] {
        didSet {
            if itemViews.count != 0 {
                setup()
            }
        }
    }
    
    private var snap: UISnapBehavior?
    private var animator: UIDynamicAnimator?
    private var centerPoints: [CGPoint] = []
    
    private var dialCenter: CGPoint = .zero
    private var snapPoint: CGPoint = .zero
    
    private func setup() {
        animator = UIDynamicAnimator(referenceView: self)
        // animator?.setValue(true, forKey: "debugEnabled")
        let N = Float(self.itemViews.count)
        let dialRadius = self.frame.width / 2 - (self.itemViews.first!.frame.height * InflateBehavior.maxInflation / 2)
        dialCenter = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        let coef = 2 * Float.pi/N
        for (idx, item) in self.itemViews.enumerated() {
            let center = CGPoint(x: dialCenter.x + dialRadius * CGFloat(sin(Float(idx) * coef)), y: dialCenter.y - dialRadius * CGFloat(cos(Float(idx) * coef)))
            item.center = center
            self.addSubview(item)
            self.centerPoints.append(item.center)
        }
        snapPoint = self.centerPoints.first!
        hideSubitems()
    }

    private func hideSubitems() {
        self.itemViews.forEach {
            $0.center = self.dialCenter
            $0.alpha = 0
        }
    }

    public func showSubitems() {
        UIView.animate(withDuration: 0.3, animations: {
                for (item, center) in zip(self.itemViews, self.centerPoints) {
                    item.center = center
                    item.alpha = 1
                    InflateBehavior.applyTransform(to: item, withCenter: self.snapPoint)
                }
            }, completion: {_ in 
                self.postAppearPreparations()
        })
    }
    
    private func attach(item fromItem: UIView, to toItem: UIView) {
        let attachToPrev = UIAttachmentBehavior(item: fromItem, attachedTo: toItem)
        animator?.addBehavior(attachToPrev)
    }
    
    private func postAppearPreparations() {
        var prev: MenuItem?
        
        for item in self.itemViews {
            let attachToCenter = UIAttachmentBehavior(item: item, attachedToAnchor: dialCenter)
            animator?.addBehavior(attachToCenter)
            
            if let prevView = prev {
                attach(item: item, to: prevView)
            }

            let inflate = InflateBehavior(view: item, point: self.snapPoint)
            animator?.addBehavior(inflate)

            prev = item
        }
        // attach last item to first
        if let prevView = prev {
            attach(item: prevView, to: self.itemViews.first!)
        }

        let panRecogniser = UIPanGestureRecognizer(target: self, action: #selector(onPan))
        self.addGestureRecognizer(panRecogniser)
    }
    
    private func forceRotate(to item: UIView) {
        guard let animator = animator else {
            return
        }
        if let snap = snap {
            animator.removeBehavior(snap)
        }
        snap = UISnapBehavior(item: item, snapTo: snapPoint)
        snap!.damping = 2
        animator.addBehavior(snap!)
    }
    
    internal func onPan(recognizer: UIPanGestureRecognizer) {
        if recognizer.view != nil {
            if recognizer.state == .began {
                if let snap = snap {
                    animator?.removeBehavior(snap)
                }
                let position = recognizer.location(in: self)
                let closest = self.closestTo(point: position)
                snap = UISnapBehavior(item: closest, snapTo: position)
                snap!.damping = 1.5
                animator?.addBehavior(snap!)
            } else if recognizer.state == .ended {
                let closest = closestTo(point: snapPoint)
                forceRotate(to: closest)
            } else if recognizer.state == .changed {
                snap?.snapPoint = recognizer.location(in: self)
            }
        }
    }
    
    private func closestTo(point: CGPoint) -> MenuItem {
        var result = self.itemViews.first!
        var dist = distanceBetween(p1: result.center, p2: point)
        
        for item in self.itemViews {
            let cur = distanceBetween(p1: item.center, p2: point)
            if cur < dist {
                dist = cur
                result = item
            }
        }
        return result
    }

}
