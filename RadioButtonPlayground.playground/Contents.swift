//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

let hello = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
hello.backgroundColor = .red

class RadioButton: UIView {
    
    private enum Metric {
        case outerCircle
        case innerCircle
        
        var borderWidth: CGFloat {
            switch self {
            case .outerCircle: return 1
            default: fatalError()
            }
        }
        
        var inset: CGFloat {
            switch self {
            case .innerCircle: return 4
            default: fatalError()
            }
        }
    }
    
    let diameter: CGFloat
    let innerCircleDiameter: CGFloat
    
    init(selected: Bool, diameter: CGFloat) {
        self.diameter = diameter
        self.innerCircleDiameter = diameter - (2 * Metric.innerCircle.inset)
        super.init(frame: .zero)
        setup(selected: selected, diameter: diameter)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    private lazy var outerCircle: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = Metric.outerCircle.borderWidth
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var innerCircle: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private func setup(selected: Bool, diameter: CGFloat) {
        style(selected: selected, diameter: diameter)
        layout(diameter: diameter)
    }
    
    private func style(selected: Bool, diameter: CGFloat) {
        // TODO: Update colours
        outerCircle.layer.borderColor = selected ? UIColor.green.cgColor : UIColor.gray.cgColor
        outerCircle.layer.cornerRadius = diameter / 2
        
        innerCircle.backgroundColor = selected ? .green : .white
        innerCircle.layer.cornerRadius = innerCircleDiameter / 2
    }
    
    private func layout(diameter: CGFloat) {
        [outerCircle].forEach(addSubview)
        [innerCircle].forEach(outerCircle.addSubview)
        
        NSLayoutConstraint.activate([
            outerCircle.leadingAnchor.constraint(equalTo: leadingAnchor),
            outerCircle.trailingAnchor.constraint(equalTo: trailingAnchor),
            outerCircle.topAnchor.constraint(equalTo: topAnchor),
            outerCircle.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            innerCircle.leadingAnchor.constraint(equalTo: outerCircle.leadingAnchor, constant: Metric.innerCircle.inset),
            innerCircle.trailingAnchor.constraint(equalTo: outerCircle.trailingAnchor, constant: -Metric.innerCircle.inset),
            innerCircle.topAnchor.constraint(equalTo: outerCircle.topAnchor, constant: Metric.innerCircle.inset),
            innerCircle.bottomAnchor.constraint(equalTo: outerCircle.bottomAnchor, constant: -Metric.innerCircle.inset)
        ])
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: diameter, height: diameter)
    }
    
    //MARK: - Public
    func configure(selected: Bool) {
        style(selected: selected, diameter: diameter)
    }
}

class TextRadioButton: UIView {
    
    private enum Metric {
        case outerStackView
        case radioButton
        case label
        
        var spacing: CGFloat {
            switch self {
            case .outerStackView: return 8
            default: fatalError()
            }
        }
        
        var diameter: CGFloat {
            switch self {
            case .radioButton: return 25
            default: fatalError()
            }
        }
    }
    
    private lazy var outerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = Metric.outerStackView.spacing
        return stackView
    }()
    
    let radioButton: RadioButton
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(text: String, selected: Bool) {
        
        radioButton = RadioButton(selected: selected, diameter: Metric.radioButton.diameter)
        radioButton.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(frame: .zero)
        setup(text: text)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    private func setup(text: String) {
        style(text: text)
        layout()
    }
    
    private func style(text: String) {
        label.attributedText = NSAttributedString(string: text)
    }
    
    private func layout() {
        // UIView() to stretch as stackView stretches
        [label, radioButton, UIView()].forEach(outerStackView.addArrangedSubview)
        [outerStackView].forEach(addSubview)
        
        NSLayoutConstraint.activate([
            outerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            outerStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            outerStackView.topAnchor.constraint(equalTo: topAnchor),
            outerStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // MARK: - Public
    func configure(selected: Bool) {
        radioButton.configure(selected: selected)
    }
}

class RadioGroup: UIView {
    
    private lazy var outerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        return stackView
    }()
    
    private var textRadioButtons: [TextRadioButton] = []
    
    /// Initialiser for Radio Group
    ///
    /// - Parameters:
    ///   - options: Options in the radio group. The options will fill equally the width of the Radio Group View
    ///   - selectedIndex: Radio button index to select. Nil to deselect all options.
    init(options: [String], selectedIndex: Int?) {
        super.init(frame: .zero)
        setup(options: options, selectedIndex: selectedIndex)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    private func setup(options: [String], selectedIndex: Int?) {
        configure(options: options, selectedIndex: selectedIndex)
        layout()
    }
    
    private func layout() {
    
        [outerStackView].forEach(addSubview)
        
        NSLayoutConstraint.activate([
            outerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            outerStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            outerStackView.topAnchor.constraint(equalTo: topAnchor),
            outerStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // MARK: - Public
    /// Populate radio button group with new options
    ///
    /// - Parameters:
    ///   - options: New options of the radio button group
    ///   - selectedIndex: Preselected radio button index. Nil if all options deselected
    func configure(options: [String], selectedIndex: Int?) {
        outerStackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        
        textRadioButtons = options.map({ TextRadioButton(text: $0, selected: false) })
        
        textRadioButtons.forEach(outerStackView.addArrangedSubview)
        
        configure(selectedIndex: selectedIndex)
    }
    
    /// Select a specific index of the current radio group
    ///
    /// - Parameter selectedIndex: Index to select. Nil to deselect all.
    func configure(selectedIndex: Int?) {
        textRadioButtons.enumerated().forEach({
            index, radioButton in
            radioButton.configure(selected: index == selectedIndex)
        })
    }
}

class MyViewController: UIViewController {
    
    private lazy var radioButton: RadioButton = {
        let button = RadioButton(selected: true, diameter: 50)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var textRadioButton: TextRadioButton = {
        let view = TextRadioButton(text: "Yes", selected: false)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .orange
        return view
    }()
    
    private lazy var radioGroup: RadioGroup = {
        let view = RadioGroup(options: ["Yes", "No", "Yo"], selectedIndex: nil)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        title = "Radio button"
        navigationController?.navigationBar.isTranslucent = false
        setupView()
    }
    
    func setupView() {
       [radioButton, textRadioButton, radioGroup].forEach(view.addSubview)
        
        NSLayoutConstraint.activate([
            radioButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            radioButton.topAnchor.constraint(equalTo: view.topAnchor),
            
            textRadioButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textRadioButton.topAnchor.constraint(equalTo: radioButton.bottomAnchor, constant: 20),
            textRadioButton.heightAnchor.constraint(equalToConstant: 50),
            textRadioButton.widthAnchor.constraint(equalToConstant: 100),
            
            radioGroup.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            radioGroup.topAnchor.constraint(equalTo: textRadioButton.bottomAnchor),
            radioGroup.heightAnchor.constraint(equalToConstant: 50),
            radioGroup.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        radioGroup.configure(selectedIndex: 1)
    }
}

let vc = MyViewController()
let nc = UINavigationController(rootViewController: vc)

PlaygroundPage.current.liveView = nc
