//
//  SlideInTransition.swift
//  CheckWise2
//
//  Created by Jakob Wiemer on 28.06.19.
//  Copyright © 2019 Jakob Wiemer. All rights reserved.
//

import UIKit

class SlideInTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    var isPresenting = false
    let dimmingView = UIView()
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    //Animation
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toViewController = transitionContext.viewController(forKey: .to),
            let fromViewController = transitionContext.viewController(forKey: .from) else {return}
        
        let containerView = transitionContext.containerView
        
        let finalWidth = toViewController.view.bounds.width * 1
        let finalHeight = toViewController.view.bounds.width * 4
        
        if isPresenting {
            //Dimming View for Background
            dimmingView.backgroundColor = .darkGray
            dimmingView.alpha = 0.0
            containerView.addSubview(dimmingView)
            dimmingView.frame = containerView.bounds
            
            //Adds Menu View controller to container
            containerView.addSubview(toViewController.view)
            
            //Init frame of the screen
            toViewController.view.frame = CGRect (x: -finalWidth, y: 0, width: finalWidth, height: finalHeight)
        }
        
        //Animate on screen
        let transform = {
            self.dimmingView.alpha = 0.8
            toViewController.view.transform = CGAffineTransform(translationX: finalWidth, y: 0)
        }
        
        //Animate back off screen
        let identity = {
            self.dimmingView.alpha = 0.0
            fromViewController.view.transform = .identity
        }
        
        //Acctual Animation of the transiation
        let duration = transitionDuration(using: transitionContext)
        let isCancelled = transitionContext.transitionWasCancelled
        UIView.animate(withDuration: duration, animations: {
            self.isPresenting ? transform(): identity()
        }) {(_) in
            transitionContext.completeTransition(!isCancelled)}

    }
    

}
