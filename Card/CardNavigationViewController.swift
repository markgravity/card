//
//  CardDetailViewController.swift
//  Card
//
//  Created by Mark G on 9/21/19.
//  Copyright © 2019 Mark G. All rights reserved.
//

import UIKit

public class CardNavigationViewController: UIViewController {
    
    
    var card: Card!
    var snapshotView: UIView!
    var visualEffectView: UIVisualEffectView!
    var proxyNavigationController: UINavigationController!
    weak var activeScrollView: UIScrollView?
    weak var activeScrollViewDelegate: UIScrollViewDelegate?
    
    public var topController: CardContentViewController? {
        return proxyNavigationController.topViewController as? CardContentViewController
    }
    
    convenience init(rootViewController: CardDetailViewController) {
        self.init()
        rootViewController.cardNavigationController = self
        proxyNavigationController = UINavigationController(rootViewController: rootViewController)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }
    
    open override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
    }
}

// MARK: - Functions
extension CardNavigationViewController {
    func setup() {
        transitioningDelegate = self
        
        // Snapshot
        snapshotView = UIScreen.main.snapshotView(afterScreenUpdates: true)
        view.addSubview(snapshotView)
        snapshotView.autoPinEdgesToSuperviewEdges()
        
        // Visual Effect View
        visualEffectView = UIVisualEffectView(effect: Card.Config.visualEffect)
        view.addSubview(visualEffectView)
        visualEffectView.autoPinEdgesToSuperviewEdges()
        
        // Proxy Navigation
        proxyNavigationController.isNavigationBarHidden = true
        proxyNavigationController.view.backgroundColor = .clear
        proxyNavigationController.view.clipsToBounds = true
        proxyNavigationController.view.layer.cornerRadius = card.layer.cornerRadius
        proxyNavigationController.delegate = self
        view.addSubview(proxyNavigationController.view)
        addChild(proxyNavigationController)
        
    }
    
    func layout(in rect: CGRect) {
        guard !card.isFullScreen else {
            proxyNavigationController.view.frame = rect
            return
        }
        
    }
}

// MARK: - Navigation
extension CardNavigationViewController {
    func pushViewController(_ viewController: CardContentViewController, animated: Bool) {
        proxyNavigationController.pushViewController(viewController, animated: animated)
    }
    
    func popViewController(animated: Bool) {
        proxyNavigationController.popViewController(animated: animated)
        activeScrollViewDelegate = topController?.scrollView.delegate
    }
    
    func popToRootViewController(animated: Bool) {
        proxyNavigationController.popToRootViewController(animated: animated)
        activeScrollViewDelegate = topController?.scrollView.delegate
    }
}

// MARK: - Transitioning Delegate
extension CardNavigationViewController: UIViewControllerTransitioningDelegate {
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return Animator(for: .presented)
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return Animator(for: .dismissed)
    }
}

// MARK: - Scroll View
extension CardNavigationViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // Call delegate that set by other
        defer {
            activeScrollViewDelegate?.scrollViewDidScroll?(scrollView)
        }
        
        
        guard let scrollView = activeScrollView,
            scrollView.isScrollEnabled else { return }
        let y = scrollView.contentOffset.y
        let offset = proxyNavigationController.view.frame.origin.y - Card.Config.marginTop

        // Behavior when scroll view is pulled down
        if (y<0) {
            proxyNavigationController.view.frame.origin.y -= y/2
            scrollView.contentOffset.y = 0

            // Behavior when scroll view is pulled down and then up
        } else if ( offset > 0) {

            scrollView.contentOffset.y = 0
            proxyNavigationController.view.frame.origin.y -= y/2
        }
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        // Call delegate that set by other
        defer {
            activeScrollViewDelegate?.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
        }
        
        let offset = proxyNavigationController.view.frame.origin.y - Card.Config.marginTop

        // Pull down speed calculations
        let max = 4.0
        let min = 2.0
        var speed = Double(-velocity.y)
        if speed > max { speed = max }
        if speed < min { speed = min }
        speed = (max/speed*min)/10

        guard offset < 60 else { dismiss(animated: true); return }
        guard offset > 0 else { return }

        // Come back after pull animation
        UIView.animate(withDuration: speed, animations: { [weak self] in
            guard let `self` = self else { return }
            self.proxyNavigationController.view.frame.origin.y = Card.Config.marginTop
            self.activeScrollView?.contentOffset.y = 0
        })
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        // Call delegate that set by other
        defer {
            
            activeScrollViewDelegate?.scrollViewDidEndDecelerating?(scrollView)
        }
        
        let offset = proxyNavigationController.view.frame.origin.y - Card.Config.marginTop
        guard offset > 0 else { return }

        // Come back after pull animation
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            guard let `self` = self else { return }
            self.proxyNavigationController.view.frame.origin.y = Card.Config.marginTop
            self.activeScrollView?.contentOffset.y = 0
        })
    }
}

// MARK: - Navigation Delegate
extension CardNavigationViewController: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        guard let viewController = viewController as? CardContentProvider else { return }

        activeScrollView = viewController.scrollView
        activeScrollView?.delegate = self
        activeScrollView?.alwaysBounceVertical = true
        activeScrollView?.showsVerticalScrollIndicator = false
        activeScrollView?.showsHorizontalScrollIndicator = false
        activeScrollViewDelegate = viewController as? UIScrollViewDelegate
    }
}
