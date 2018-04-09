//
//  SingleCityViewController.swift
//  Rippal
//
//  Created by Tao Wang on 3/18/18.
//  Copyright © 2018 Rippal. All rights reserved.
//

import UIKit

class SingleCityViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showWithAnimation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnClosePressed(_ sender: Any) {
        dismissWithAnimation()
    }
    
    func showWithAnimation() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25) {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
    func dismissWithAnimation() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0
        }) { finished in
            for view in (self.parent?.view.subviews)! {
                if view.tag == 0x26 {                       // Hardcoded tag
                    view.removeFromSuperview()
                }
            }
            self.view.removeFromSuperview()
        }
    }
}
