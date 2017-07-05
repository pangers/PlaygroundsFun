//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

let hiView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
hiView.backgroundColor = .red

class ActionButton: UIButton {
    
    enum State {
        case green
        case fadedGreen
        case white
        case grey
        
        var backgroundColor: UIColor {
            // TODO: Add proper colors
            switch self {
            case .green: return .green
            case .fadedGreen: return .purple
            case .white: return .white
            case .grey: return .gray
            }
        }
        
        var textColor: UIColor {
            // TODO: Add proper colors
            switch self {
            case .green: return .white
            case .fadedGreen: return .lightGray
            case .white: return .gray
            case .grey: return .lightGray
            }
        }
        
        var borderColor: UIColor {
            // TODO: Add proper colors
            switch self {
            case .green: return .green
            case .fadedGreen: return .purple
            case .white: return .gray
            case .grey: return .lightGray
            }
        }
    }
    
    private enum Metric {
        case layer
        
        var borderWidth: CGFloat {
            switch self {
            case .layer: return 1
            }
        }
        
        var cornerRadius: CGFloat {
            switch self {
            case .layer: return 2
            }
        }
    }
    
    let enabledState: State
    let disabledState: State
    
    /// Initialiser for ActionButton
    ///
    /// - Parameters:
    ///   - title: Title of the action button
    ///   - enabledState: The colour palette in its enabled state
    ///   - disabledState: The color palette in its disabled state
    ///   - initialEnabled: Whether the button is initially enabled or disabled
    init(title: String, enabledState: State, disabledState: State, initialEnabled: Bool) {
        self.enabledState = enabledState
        self.disabledState = disabledState
        super.init(frame: .zero)
        setup(title: title, initialEnabled: initialEnabled)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    func setup(title: String, initialEnabled: Bool) {
        style(title: title, initialEnabled: initialEnabled)
    }
    
    func style(title: String, initialEnabled: Bool) {
        setButtonTitle(text: title)
        layer.borderWidth = Metric.layer.borderWidth
        layer.cornerRadius = Metric.layer.cornerRadius
        setEnabledState(initialEnabled)
    }
    
    // MARK: - Public
    /// Update the title of the ActionButton
    ///
    /// - Parameter text: The new title
    func setButtonTitle(text: String) {
        // TODO: Set proper font
        setAttributedTitle(NSAttributedString(string: text), for: .normal)
    }
    
    /// Update whether the ActionButton is enabled or disabled. Use this method rather than the `isEnabled` property of ActionButton.
    ///
    /// - Parameter enabled: True if the button is enabled. False if disabled.
    func setEnabledState(_ enabled: Bool) {
        backgroundColor = enabled ? enabledState.backgroundColor : disabledState.backgroundColor
        layer.borderColor = enabled ? enabledState.borderColor.cgColor : disabledState.borderColor.cgColor
        isEnabled = enabled
    }
}

class MyViewController: UIViewController {
    
    private lazy var actionButton: ActionButton = {
        let button = ActionButton(title: "Submit", enabledState: .green, disabledState: .fadedGreen, initialEnabled: true)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        title = "Action Button"
        navigationController?.navigationBar.isTranslucent = false
        layout()
        actionButton.addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }
    
    func tapped() {
        print("button tapped")
    }
    
    func layout() {
        [actionButton].forEach(view.addSubview)
        
        NSLayoutConstraint.activate([
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            actionButton.topAnchor.constraint(equalTo: view.topAnchor),
            actionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

let vc = MyViewController()
let nc = UINavigationController(rootViewController: vc)


PlaygroundPage.current.liveView = nc