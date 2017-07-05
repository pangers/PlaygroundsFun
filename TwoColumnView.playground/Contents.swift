//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

let hello = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
hello.backgroundColor = .red

class InlineLinkLabel: UITextView, UITextViewDelegate {
    
    private struct Action {
        
        let identifier: String
        let block: ((Void) -> Void)
    }
    
    private var links: [Action] = []
    private var shouldClearLinks = true
    
    private func newIdentifier() -> String {
        return "action://" + NSUUID().uuidString
    }
    
    required init() {
        super.init(frame: .zero, textContainer: nil)
        isScrollEnabled = false
        isEditable = false
        dataDetectorTypes = []
        delegate = self
        textContainerInset = .zero
        textContainer.lineFragmentPadding = 0
        linkTextAttributes = [NSForegroundColorAttributeName: UIColor.green]
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    override var attributedText: NSAttributedString! {
        didSet {
            if shouldClearLinks {
                links = []
            }
        }
    }
    
    func addLink(for substring: String, action: @escaping ((Void) -> Void)) {
        
        let identifier = newIdentifier()
        let action = Action(identifier: identifier, block: action)
        
        let range = (attributedText.string as NSString).range(of: substring)
        let mutableAttributedCopy = attributedText.mutableCopy() as!  NSMutableAttributedString
        
        let url = URL(string: identifier)!
        mutableAttributedCopy.addAttributes([NSLinkAttributeName: url], range: range)
        
        shouldClearLinks = false
        attributedText = mutableAttributedCopy.copy() as! NSAttributedString
        shouldClearLinks = true
        
        links.append(action)
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        
        guard let action = links.first(where: { $0.identifier == URL.absoluteString }) else { return false }
        action.block()
        
        return false
    }
}


class TwoColumnView: UIView {
    
    private enum Metric {
        case outerStackView
        
        var spacing: CGFloat {
            switch self {
            case .outerStackView: return 16
            }
        }
    }
    
    private lazy var outerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = Metric.outerStackView.spacing
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private lazy var leftLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .red
        return label
    }()
    
    private lazy var rightLabel: InlineLinkLabel = {
        let label = InlineLinkLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .yellow
        return label
    }()
    
    typealias Action = (Void) -> Void
    
    init(leftText: NSAttributedString, rightText: NSAttributedString, leftProportion: CGFloat, rightProportion: CGFloat, rightAction: Action? = nil) {
        super.init(frame: .zero)
        setup(leftText: leftText, rightText: rightText, leftProportion: leftProportion, rightProportion: rightProportion, rightAction: rightAction)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    private func setup(leftText: NSAttributedString, rightText: NSAttributedString, leftProportion: CGFloat, rightProportion: CGFloat, rightAction: Action?) {
        style(leftText: leftText, rightText: rightText, rightAction: rightAction)
        layout(leftProportion: leftProportion, rightProportion: rightProportion)
    }
    
    private func style(leftText: NSAttributedString, rightText: NSAttributedString, rightAction: Action?) {
        configure(leftText: leftText)
        configure(rightText: rightText, rightAction: rightAction)
    }
    
    private func layout(leftProportion: CGFloat, rightProportion: CGFloat) {
        [leftLabel, rightLabel].forEach(outerStackView.addArrangedSubview)
        [outerStackView].forEach(addSubview)
        
        let labelWidthMultiplier = leftProportion / rightProportion
        
        NSLayoutConstraint.activate([
            outerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            outerStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            outerStackView.topAnchor.constraint(equalTo: topAnchor),
            outerStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            leftLabel.widthAnchor.constraint(equalTo: rightLabel.widthAnchor, multiplier: labelWidthMultiplier)
        ])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            print("Left width: \(self.leftLabel.bounds.width)")
            print("Right width: \(self.rightLabel.bounds.width)")
        })
    }
    
    // MARK: - Public
    func configure(leftText: NSAttributedString, rightText: NSAttributedString) {
        configure(leftText: leftText)
        configure(rightText: rightText)
    }
    
    func configure(leftText: NSAttributedString) {
        leftLabel.attributedText = leftText
    }
    
    func configure(rightText: NSAttributedString, rightAction: Action? = nil) {
        rightLabel.attributedText = rightText
        if let action = rightAction {
            rightLabel.addLink(for: rightText.string, action: action)
        }
    }
    
    func configure(margins: UIEdgeInsets) {
        outerStackView.layoutMargins = margins
    }
}

class TwoColumnSection: UIView {
    
    private lazy var outerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    let widthRatio: (leftProportion: CGFloat, rightProportion: CGFloat)
    let rowHeight: CGFloat
    
    typealias RowData = (leftText: NSAttributedString, rightText: NSAttributedString, rightAction: ((Void) -> Void)?)
    
    init(pairs: [RowData], leftProportion: CGFloat, rightProportion: CGFloat, rowHeight: CGFloat) {
        self.rowHeight = rowHeight
        self.widthRatio = (leftProportion, rightProportion)
        super.init(frame: .zero)
        setup(pairs: pairs)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    private func setup(pairs: [RowData]) {
        layout()
        configure(pairs: pairs)
    }
    
    func layout() {
        [outerStackView].forEach(addSubview)
        
        NSLayoutConstraint.activate([
            outerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            outerStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            outerStackView.topAnchor.constraint(equalTo: topAnchor),
            outerStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    
    // MARK: - Public
    func configure(pairs: [RowData]) {
        outerStackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        
        pairs.forEach({ pair in
            let view = TwoColumnView(leftText: pair.leftText, rightText: pair.rightText, leftProportion: widthRatio.leftProportion, rightProportion: widthRatio.rightProportion, rightAction: pair.rightAction)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.heightAnchor.constraint(equalToConstant: self.rowHeight).isActive = true
            self.outerStackView.addArrangedSubview(view)
        })
    }
}


class MyViewController: UIViewController {
    
    private lazy var twoColumnView: TwoColumnView = {
        let view = TwoColumnView(leftText: NSAttributedString(string: "Hello"), rightText: NSAttributedString(string: "Goodbye"), leftProportion: 1, rightProportion: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .purple
        return view
    }()
    
    private lazy var twoColumnSection: TwoColumnSection = {
        let view = TwoColumnSection(pairs: [
            (leftText: NSAttributedString(string: "Hello"), rightText: NSAttributedString(string: "Goodbye"), rightAction: { print("goodbye tapped") }),
            (leftText: NSAttributedString(string: "Hello1"), rightText: NSAttributedString(string: "Goodbye1"), rightAction: { print("goodbye1 tapped") }),
            (leftText: NSAttributedString(string: "Yolo"), rightText: NSAttributedString(string: "Bolo"), rightAction: nil)
            ], leftProportion: 0.6, rightProportion: 0.6, rowHeight: 40)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .green
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        title = "Two Column View"
        navigationController?.navigationBar.isTranslucent = false
        setupView()
    }
    
    func setupView() {
        [twoColumnView, twoColumnSection].forEach(view.addSubview)
        
        NSLayoutConstraint.activate([
            twoColumnView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            twoColumnView.topAnchor.constraint(equalTo: view.topAnchor),
            twoColumnView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            twoColumnView.heightAnchor.constraint(equalToConstant: 40),
            
            twoColumnSection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            twoColumnSection.topAnchor.constraint(equalTo: twoColumnView.bottomAnchor, constant: 20),
            twoColumnSection.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

let vc = MyViewController()
let nc = UINavigationController(rootViewController: vc)

PlaygroundPage.current.liveView = nc
