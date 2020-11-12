//
//  ViewController.swift
//  TransitionDemo
//
//  Created by mr.zhou on 2020/11/12.
//

import UIKit

class ViewController: UIViewController {

    let transitionDelegate = TransitionDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton(frame: CGRect(x: 100, y: 200, width: 100, height: 40))
        button.backgroundColor = .red
        view.addSubview(button)
        button.addTarget(self, action: #selector(tapButton), for: .touchUpInside)

    }
    @objc
    func tapButton() {
        let vc = NextViewController()
        vc.modalPresentationStyle = .custom
        transitionDelegate.percentDriven = UIPercentDrivenInteractiveTransition()
        vc.transitioningDelegate = transitionDelegate
        vc.percent = transitionDelegate.percentDriven
        present(vc, animated: true, completion: nil)
    }
}

class TransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    var isTap: Bool = false
    
    var percentDriven: UIPercentDrivenInteractiveTransition?
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return Transition(true)
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return Transition(false)
    }
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if isTap {
            return nil
        }
        return percentDriven
    }
}

class Transition: NSObject, UIViewControllerAnimatedTransitioning {
    
    var isPresent: Bool = false
    init(_ isPresent: Bool) {
        super.init()
        self.isPresent = isPresent
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if let fromVC = transitionContext.viewController(forKey: .from),
           let toVC = transitionContext.viewController(forKey: .to) {
            let container = transitionContext.containerView
            if isPresent {
                container.addSubview(toVC.view)
                toVC.view.frame = CGRect(x: 0, y: container.bounds.height, width: container.bounds.width, height: container.bounds.height - 100)
                UIView.animate(withDuration: 0.4) {
                    toVC.view.frame = CGRect(x: 0, y: 100, width: container.bounds.width, height: container.bounds.height)
                } completion: { (flag) in
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                }
            } else {
                UIView.animate(withDuration: 0.4) {
                    fromVC.view.frame = CGRect(x: 0, y: container.bounds.height, width: container.bounds.width, height: container.bounds.height - 100)

                } completion: { (flag) in
                    if !transitionContext.transitionWasCancelled {
                        fromVC.view.removeFromSuperview()
                    }
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)

                }
            }
        }
    }
    func animationEnded(_ transitionCompleted: Bool) {
        
    }
}


