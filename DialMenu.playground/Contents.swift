//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

let containerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 512, height: 512))
containerView.backgroundColor = .darkGray

let items = ["Pale lager", "Witbier", "Pilsner", "Weissbier", "APA", "IPA", "English Bitter", "Dark lager", "Porter", "Stout"].map {
    MenuItem(title: $0)
}

let dialMenu = DialMenu(frame: containerView.frame)
dialMenu.itemViews = items
containerView.addSubview(dialMenu)
dialMenu.showSubitems()

PlaygroundPage.current.liveView = containerView
PlaygroundPage.current.needsIndefiniteExecution = true
