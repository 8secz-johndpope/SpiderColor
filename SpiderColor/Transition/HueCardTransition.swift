//
//  HueCardTransition.swift
//  SpiderColor
//
//  Created by Ailton Vieira Pinto Filho on 11/04/20.
//  Copyright © 2020 Veevaz. All rights reserved.
//

import UIKit

class HueCardTransition: NSObject {
    var logoImageView: UIImageView!
}

//MARK: - UIViewControllerAnimatedTransitioning

extension HueCardTransition: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval { 1.5 }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView

        guard let presentedView = transitionContext.view(forKey: .to) else { return }

        let maskSize = 0.4 * logoImageView.frame.width
        let maskCenterX = logoImageView.center.x - maskSize / 2
        let maskCenterY = logoImageView.center.y - maskSize / 2

        let maskImageView = UIImageView(image: #imageLiteral(resourceName: "maskHueCard"))
        maskImageView.frame = CGRect(x: maskCenterX, y: maskCenterY, width: maskSize, height: maskSize)
        maskImageView.alpha = 0

        presentedView.mask = maskImageView

        containerView.addSubview(presentedView)

        UIView.animate(withDuration: 1.0) {
            maskImageView.alpha = 1
        }

        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            self.logoImageView.transform = CGAffineTransform(scaleX: 20, y: 20)
            maskImageView.transform = CGAffineTransform(scaleX: 20, y: 20)
        }) { success in
            transitionContext.completeTransition(success)
        }
    }
}
