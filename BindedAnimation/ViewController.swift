//
//  ViewController.swift
//  BindedAnimation
//
//  Created by Irina Deeva on 07/11/24.
//

import UIKit

class ViewController: UIViewController {
    lazy var squareView = UIView()
    lazy var sliderView = UISlider()
    var animatorForward: UIViewPropertyAnimator?

    private let initialSize: CGFloat = 100
    private let finalScale: CGFloat = 1.5
    private let rotationAngle: CGFloat = .pi / 2
    private let layoutMargin: CGFloat = 16

    override func viewDidLoad() {
        super.viewDidLoad()

        squareView.layer.cornerRadius = 8
        squareView.backgroundColor = .systemCyan

        [squareView, sliderView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        view.layoutMargins = UIEdgeInsets(top: layoutMargin, left: layoutMargin, bottom: layoutMargin, right: layoutMargin)

        NSLayoutConstraint.activate([
            squareView.heightAnchor.constraint(equalToConstant: initialSize),
            squareView.widthAnchor.constraint(equalToConstant: initialSize),
            squareView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 56),
            squareView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),

            sliderView.topAnchor.constraint(equalTo: squareView.bottomAnchor, constant: 62),
            sliderView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            sliderView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])

        let maxTranslation = view.frame.width - view.layoutMargins.right * 2  - initialSize / 2 - 8

        animatorForward = UIViewPropertyAnimator(duration: 1, curve: .easeInOut) { [unowned self, squareView] in
           squareView.center.x = maxTranslation
           squareView.transform = CGAffineTransform(rotationAngle: rotationAngle).scaledBy(x: finalScale, y: finalScale)
        }

        animatorForward?.pausesOnCompletion = true

        sliderView.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
        sliderView.addTarget(self, action: #selector(sliderDidEndTouching), for: [.touchUpInside, .touchUpOutside])
    }

    @objc func sliderChanged(_ sender: UISlider) {
        animatorForward?.fractionComplete = CGFloat(sender.value)
    }

    @objc private func sliderDidEndTouching(_ sender: UISlider) {
        animatorForward?.continueAnimation(withTimingParameters: nil, durationFactor: 1 - CGFloat(sender.value))

        sliderView.setValue(1, animated: true)
    }
}
