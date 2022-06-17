//
//  ViewController.swift
//  swift_tap_pan_gestures
//
//  Created by Paulis Zabarovskis on 09/06/2022.
//

import UIKit

class ViewController: UIViewController {
//MARK: - Outlets
    
    @IBOutlet weak var tapView: UIView!
    
    @IBOutlet weak var panAreaTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var footherHighConstraint: NSLayoutConstraint!
    @IBOutlet weak var handleWiew: UIView!
    @IBOutlet weak var footherView: UIView!
    
    
    var panAreaMarginTo: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
//Gesture configuration
        //Single tap
        let tap = UITapGestureRecognizer(target: self, action: #selector(singleTap))
        self.tapView?.addGestureRecognizer(tap)
// Multitap
        let multiTap = UITapGestureRecognizer(target: self, action: #selector(multiTap))
        multiTap.numberOfTouchesRequired = 1
        multiTap.numberOfTapsRequired = 3
        self.tapView?.addGestureRecognizer(multiTap)
        
        //MARK: - Pan recogniser
             let pan = UIPanGestureRecognizer.init(target: self, action: #selector(handlePan))
             self.handleWiew?.addGestureRecognizer(pan)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.swipeDown(withAnimation: false)
    }

 //MARK: - Tap recogniser
    @objc func singleTap() {
        print("TAP")
    }
    
    @objc func multiTap() {
        print("MultiTAP")
    }
    

    @objc func handlePan(gestureRecogniser: UIPanGestureRecognizer) {
        // Calculate visible area high
        let saveAreaInsets = self.view.safeAreaInsets
        let visibleAreaHigh = self.view.bounds.size.height - saveAreaInsets.top - saveAreaInsets.bottom - self.footherView.bounds.size.height - self.handleWiew.bounds.size.height
        // Divide to 3 parts
        //-----------Save area top
        //
        //------------Treshhold top
        //
        //-------------Treshhold bottom
        //
        //------------------Foother view top
        let tresholdTop = visibleAreaHigh * 1/3
        let tresholdBottom = visibleAreaHigh * 2/3
        
        let translation = gestureRecogniser.translation(in: self.view)
        
        var panAreaMarginTopCurrent = self.panAreaMarginTo + translation.y
        
//                             self.panAreaTopConstraint.constant = panAreaMarginTopCurrent
        
        // Apstrādā Pan recogniser states
        if gestureRecogniser.state == .began {
// Fix initial constraint value
            self.panAreaMarginTo = self.panAreaTopConstraint.constant
        }
        
        else if gestureRecogniser.state == .changed {
            // Sanity check
            if panAreaMarginTopCurrent < 0 {
                // Out of range
                panAreaMarginTopCurrent = 0
            }
            if panAreaMarginTopCurrent > visibleAreaHigh {
                panAreaMarginTopCurrent = visibleAreaHigh
            }
            // Set actual value
            self.panAreaTopConstraint.constant = panAreaMarginTopCurrent
         }
            
        else if gestureRecogniser.state == .ended {
            if panAreaMarginTopCurrent < tresholdTop {
                self.swipeUp()
            }
            else if panAreaMarginTopCurrent < tresholdBottom {
                if translation.y < 0 {
                    self.swipeUp()
                } else {
                    self.swipeDown(withAnimation: true)
                }
            } else {
                self.swipeDown(withAnimation: true)

            }
          
        }
        print("translation = \(translation.y)")
    }
    
    func swipeDown(withAnimation animation: Bool) {
        let saveAreaInsets = self.view.safeAreaInsets
        
        self.panAreaTopConstraint.constant = self.view.bounds.size.height - saveAreaInsets.top - saveAreaInsets.bottom - self.footherView.bounds.size.height - self.handleWiew.bounds.size.height
        
        if animation {
        UIView.animate(withDuration: 3.0) {
            
            self.view.layoutIfNeeded()
            
        } completion:{ finish in
            if finish == true {
                self.footherHighConstraint.priority = UILayoutPriority.init(rawValue: 200)
            }
        }
        
        }
                       else {
                           self.view.layoutIfNeeded()
                           self.footherHighConstraint.priority = UILayoutPriority.init(rawValue: 200)
                       }
            
        }
    func swipeUp() {
        self.panAreaTopConstraint.constant = 0

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        } completion: { finish in
            if finish == true {
                self.footherHighConstraint.priority = UILayoutPriority.init(rawValue: 999)
            }
        }

   }

 
                       
                       
}

