//
//  ViewController.swift
//  InertialSquare
//
//  Created by Artyom on 17.11.2023.
//

import UIKit

class ViewController: UIViewController {

    var square: UIView!
    var dynamicAnimator: UIDynamicAnimator!
    var attachmentBehavior: UIAttachmentBehavior!
    var lastLocation = CGPoint.zero

    override func viewDidLoad() {
        super.viewDidLoad()

        square = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        square.backgroundColor = UIColor.systemBlue
        square.layer.cornerRadius = 10
        square.center = self.view.center
        self.view.addSubview(square)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.view.addGestureRecognizer(tapRecognizer)
        
        dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
    }

    @objc func handleTap(recognizer: UITapGestureRecognizer) {
        let tapLocation = recognizer.location(in: self.view)

        let direction: CGFloat = tapLocation.x > lastLocation.x ? 1 : -1
        let rotationAngle = direction * CGFloat.pi / 8

        dynamicAnimator.removeAllBehaviors()
        
        attachmentBehavior = UIAttachmentBehavior(item: square, attachedToAnchor: tapLocation)
        attachmentBehavior.length = 0
        attachmentBehavior.damping = 1.0
        attachmentBehavior.frequency = 2.5
        dynamicAnimator.addBehavior(attachmentBehavior)
        
        UIView.animate(withDuration: 1.5,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 1.0,
                       options: .curveEaseInOut,
                       animations: {
                        self.square.transform = CGAffineTransform(rotationAngle: rotationAngle)
                       },
                       completion: { _ in
                        UIView.animate(withDuration: 0.5, animations: {
                            self.square.transform = CGAffineTransform.identity
                        })
                       })

        lastLocation = tapLocation
    }
}
