//
//  TranstionAnimationDesign.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 3/10/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import UIKit

class CircleTransitionDesign: NSObject {
    
    var circle = UIView()
    
    var startingPoint = CGPoint.zero {
        didSet {
            circle.center = startingPoint
        }
    }
    
    var circleColor = UIColor.white
    
    var duration = 0.3
    
    enum CirclarTransitionMode: Int {
        case present, dismiss, pop
    }
    
    var transitionMode: CirclarTransitionMode = .present
    
}

extension CircleTransitionDesign: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        if transitionMode == .present {
            if let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to) {
                let viewCenter = presentedView.center
                let viewSize = presentedView.frame.size
                
                circle = UIView()
                
                circle.frame = frameForCircle(withViewCenter: viewCenter, size: viewSize, startPoint: startingPoint)
                
                circle.layer.cornerRadius = circle.frame.size.height / 2
                
                circle.center = startingPoint
                
                circle.backgroundColor = circleColor
                
                circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)

                presentedView.center = startingPoint
                
                presentedView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                
                presentedView.alpha = 0
                
                containerView.addSubview(presentedView)
                
                containerView.addSubview(circle)
                
                UIView.animate(withDuration: duration, animations: {
                    self.circle.transform = CGAffineTransform.identity
                    presentedView.transform = CGAffineTransform.identity
                    presentedView.alpha = 1
                    presentedView.center = viewCenter
                }, completion: { (success:Bool) in
                    self.circle.removeFromSuperview()
                    
                    transitionContext.completeTransition(success)
                })
                
            }
            
        } else {
            
            // Need to do more research
            
            if let returningView = transitionContext.view(forKey: UITransitionContextViewKey.from), let returnedView = transitionContext.view(forKey: UITransitionContextViewKey.to) {
                
                let viewCenter = returningView.center
                let viewSize = returningView.frame.size
                
                circle.frame = frameForCircle(withViewCenter: viewCenter, size: viewSize, startPoint: startingPoint)
                
                circle.layer.cornerRadius = circle.frame.size.height / 2
                
                circle.center = startingPoint
                
                circle.backgroundColor = circleColor
                
                returningView.alpha = 0
                
                containerView.addSubview(returnedView)
                containerView.addSubview(returningView)
                containerView.addSubview(circle)
                
                UIView.animate(withDuration: duration, animations: {
                    self.circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                    returningView.transform = CGAffineTransform(scaleX: 0.001, y: 0001)
                    returningView.center = self.startingPoint
                    returningView.alpha = 0
                    
                }) { (success:Bool) in
                    returningView.center = viewCenter
                    returningView.removeFromSuperview()
                    self.circle.removeFromSuperview()
                    
                    transitionContext.completeTransition(success)
                }
                
            }
            
        }
    }
    
    func frameForCircle(withViewCenter viewCenter: CGPoint, size viewSize: CGSize, startPoint: CGPoint) -> CGRect {
        let xLength = fmax(startPoint.x, viewSize.width - startPoint.x)
        let yLength = fmax(startPoint.y, viewSize.height - startPoint.y)
        
        let offsetVector = sqrt(xLength * xLength + yLength * yLength) * 2
        let size = CGSize(width: offsetVector, height: offsetVector)
        
        return CGRect(origin: CGPoint.zero, size: size)
        
    }
    
}
