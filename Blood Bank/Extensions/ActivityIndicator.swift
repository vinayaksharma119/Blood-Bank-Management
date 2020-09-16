//
//  ActivityIndicator.swift
//  Blood Bank
//
//  Created by Vinayak Sharma on 17/04/20.
//  Copyright © 2020 Vinayak Sharma. All rights reserved.
//

import UIKit
import Lottie

fileprivate var aView : UIView?

extension UIViewController {

    func showAnimation(){
        
            aView = UIView(frame: self.view.bounds)
            aView?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        
            let animationView = AnimationView(name: "loading")
            animationView.frame = CGRect(x: 0, y: 0, width: 70, height: 70)
            animationView.center = aView!.center
            animationView.contentMode = .scaleAspectFill
            animationView.loopMode = .loop
            animationView.play()
            aView?.addSubview(animationView)
            self.view.addSubview(aView!)
            
            
            Timer.scheduledTimer(withTimeInterval: 15.0, repeats: false){(t) in
            self.removeAnimation()
            
        }

    }
    func removeAnimation(){
            let animationView = AnimationView(name: "loading")
            aView?.removeFromSuperview()
            aView = nil
            animationView.stop()
            animationView.removeFromSuperview()
        
    
        
    }
}

