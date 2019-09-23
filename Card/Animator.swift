//
//  Animator.swift
//  Card
//
//  Created by Mark G on 9/21/19.
//  Copyright © 2019 Mark G. All rights reserved.
//

import UIKit

public enum AnimatorTransitioning {
    case presented, dismissed
}
public class Animator: NSObject {
    let duration: TimeInterval = 0.6
    var transition: AnimatorTransitioning!
    
    public convenience init(for transition: AnimatorTransitioning) {
        self.init()
        self.transition = transition
    }
}

// MARK: - Animated Transitioning
extension Animator: UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        let to = transitionContext.viewController(forKey: .to)!
        let from = transitionContext.viewController(forKey: .from)!
       
        
        switch transition! {
        case .presented:
            container.addSubview(from.view)
            container.addSubview(to.view)
            animatePresentTransition(context: transitionContext,
                                     from: from as! CardContainerViewController,
                                     to: to as! CardNavigationViewController)
        case .dismissed:
            container.addSubview(to.view)
            container.addSubview(from.view)
            animateDismissTransition(context: transitionContext, from: from as! CardNavigationViewController, to: to as! CardContainerViewController)
            break
        }
    }
}

// MARK: - Animation
extension  Animator {
    func animatePresentTransition(context: UIViewControllerContextTransitioning, from: CardContainerViewController, to: CardNavigationViewController) {
        guard let presentingCard = from.presentingCard,
            let detailController = to.topController as? CardDetailViewController else { return }
        
        to.view.alpha = 0
        DispatchQueue.main.async {
            to.view.alpha = 1
            
            // Move & resize dest controller match with presenting card
            let rect = presentingCard.superview!.convert(presentingCard.frame, to: from.view)
            presentingCard.alpha = 0
            to.proxyNavigationController.view.frame = rect
            to.proxyNavigationController.view.layer.cornerRadius = presentingCard.layer.cornerRadius
            to.snapshotView.alpha = 0
            to.visualEffectView.alpha = 0
            detailController.layout(in: rect)

            // Scale to 0.95%
            UIView.animate(withDuration: 0.2, animations: {
                
                to.proxyNavigationController.view.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            })

            // Scale back to normal
            UIView.animate(withDuration: 0.2, delay: 0.2, animations: {
                
                to.proxyNavigationController.view.transform = .identity
            })

            // Expand: #1
            UIView.animate(withDuration: 0.3, delay: 0.3, options: [], animations: {
                
                to.proxyNavigationController.view.frame = CGRect(x: 8, y: 8, width: from.view.frame.width - 16, height: from.view.frame.height - 100)
                to.proxyNavigationController.view.layer.cornerRadius = 0
                to.snapshotView.alpha = 1
                to.visualEffectView.alpha = 1
                detailController.view.tag = 1
                detailController.layout(in: to.proxyNavigationController.view.frame)
            })

            // Expand: #2
            UIView.animate(withDuration: 0.2, delay: 0.5, options: .curveEaseOut, animations: {

                to.proxyNavigationController.view.frame = CGRect(x: 0, y: -8, width: from.view.frame.width, height: from.view.frame.height)
                to.view.layer.cornerRadius = 0
                detailController.view.tag = 2
                detailController.layout(in: to.proxyNavigationController.view.frame)
            })

            // Completed
            UIView.animate(withDuration: 0.4, delay: 0.6, animations: {

                to.proxyNavigationController.view.frame = CGRect(x: 0, y: 0, width: from.view.frame.width, height: from.view.frame.height)
                detailController.layout(in: to.proxyNavigationController.view.frame)
            }) { _ in

                context.completeTransition(true)
            }
             
        }
    }
    
    func animateDismissTransition(context: UIViewControllerContextTransitioning, from: CardNavigationViewController, to: CardContainerViewController) {
        guard let presentingCard = to.presentingCard,
        let detailController = from.topController as? CardDetailViewController else { return }
        let rect = presentingCard.superview!.convert(presentingCard.frame, to: from.view)
        //
        from.snapshotView.alpha = 1
        from.visualEffectView.alpha = 1
        presentingCard.alpha = 0
        from.proxyNavigationController.view.layer.cornerRadius = 0
        detailController.originalCardHeight = presentingCard.frame.height
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {

            from.proxyNavigationController.view.frame.origin = CGPoint(x: rect.origin.x, y: rect.origin.y + 8)
            from.proxyNavigationController.view.frame.size = rect.size
            from.snapshotView.alpha = 0
            from.visualEffectView.alpha = 0
            from.proxyNavigationController.view.layer.cornerRadius = presentingCard.layer.cornerRadius
            
            detailController.view.tag = 3
            detailController.layout(in: rect)
        })
        
        UIView.animate(withDuration: 0.4, delay: 0.3, options: .curveEaseOut, animations: {
            from.proxyNavigationController.view.frame = rect
        }) { _ in
            presentingCard.alpha = 1
            context.completeTransition(true)
        }
    }
}
