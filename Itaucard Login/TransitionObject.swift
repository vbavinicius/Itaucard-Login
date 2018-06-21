//
//  TransitionObject.swift
//  Itaucard Login
//
//  Created by Vinícius Barcelos on 19/05/18.
//  Copyright © 2018 Vinícius Barcelos. All rights reserved.
//

import UIKit

class TransitionObject: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        let fromView = transitionContext.view(forKey: .from)!
        let fromVC = transitionContext.viewController(forKey: .from) as! ViewController
        
        toView.alpha = 1.0
        containerView.bringSubview(toFront: fromView)
        containerView.addSubview(toView)
        containerView.sendSubview(toBack: toView)
    
        let scaleFactor = (fromVC.view.frame.height / fromVC.loginButton.frame.height) * 2
        
        // Start animation
        UIView.animateKeyframes(withDuration: 1.2, delay: 0, options: UIViewKeyframeAnimationOptions.calculationModeLinear, animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.3, animations: {
                fromVC.loginButton.transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.3, animations: {
                fromVC.loginButton.backgroundColor = .white
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                fromView.alpha = 0.0
            })
            
        }) { (_) in

            fromView.alpha = 1.0
            fromVC.loginButton.transform = .identity
            fromVC.loginButton.backgroundColor = UIColor(red: 246/255, green: 94/255, blue: 1/255, alpha: 1)
            fromVC.resetToInitialState()
            fromVC.isEditingTextField = false
            transitionContext.completeTransition(true)
        }
    }
}
