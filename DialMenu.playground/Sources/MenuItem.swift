import Foundation
import UIKit

public class MenuItem: UIView {
    static let bubbleSize: CGFloat = 100
    
    var title: String = ""
    
    public convenience init(title: String) {
        self.init(frame: CGRect(x: 0, y: 0, width: MenuItem.bubbleSize, height: MenuItem.bubbleSize))
        self.title = title
        
        self.backgroundColor = rndColor()
        
        let caption = UILabel()
        caption.text = title
        caption.font = UIFont(name: "HelveticaNeue-Medium", size: 12)
        caption.textColor = .white
        caption.textAlignment = .center
        caption.sizeToFit()
        caption.center = self.center
        caption.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.layer.cornerRadius = MenuItem.bubbleSize / 2
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.layer.shadowOpacity = 0.7
        self.layer.shadowRadius = 3
        
        self.addSubview(caption)
    }
}
