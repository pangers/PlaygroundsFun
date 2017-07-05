//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

//FOR MORE INFO: http://binaryadventures.com/blog/snippet-of-the-week-prototyping-views-in-playgrounds/?utm_campaign=This+Week+in+Swift&utm_medium=email&utm_source=This_Week_in_Swift_120

let view = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
view.backgroundColor = .black

let redView = UIView()
redView.translatesAutoresizingMaskIntoConstraints = false
view.addSubview(redView)
redView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
redView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
redView.widthAnchor.constraint(equalToConstant: 100).isActive = true
redView.heightAnchor.constraint(equalToConstant: 100).isActive = true
redView.backgroundColor = .ferryOrange()

class MyViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ferryBlue()
        title = "My View Controller"
    }
}

let vc = MyViewController()
let nc = UINavigationController(rootViewController: vc)


PlaygroundPage.current.liveView = nc


"A" < "B"

"A" > "K"

"K" < "#"

"K" > "#"


