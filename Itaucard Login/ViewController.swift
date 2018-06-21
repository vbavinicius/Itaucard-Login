//
//  ViewController.swift
//  Itaucard Login
//
//  Created by Vinícius Barcelos on 10/05/18.
//  Copyright © 2018 Vinícius Barcelos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var requestCardView: UIView!
    @IBOutlet weak var digitalTokenView: UIView!
    @IBOutlet weak var helpView: UIView!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var dotsStackView: UIStackView!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var tappableView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var logoWrapper: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var middleView: UIView!
    
    // Constraints
    @IBOutlet var bottom: NSLayoutConstraint!
    @IBOutlet var top: NSLayoutConstraint!
    @IBOutlet var left: NSLayoutConstraint!
    @IBOutlet var center: NSLayoutConstraint!
    
    // Variables
    var isEditingTextField: Bool = false
    
    // Animator
    let animator = TransitionObject()
    
    // VDL
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Disable button on VDL
        loginButton.isEnabled = false
        loginButton.setTitleColor( UIColor.white.withAlphaComponent(0.5), for: .disabled)

        // Text Field Delegate
        textField.delegate = self
        
        // Initial state
        dotsStackView.alpha = 0
        textField.alpha = 0
        
        // Setup dots
        for view in dotsStackView.subviews as [UIView] {
            view.layer.cornerRadius = view.frame.width / 2
            view.backgroundColor = .white
            view.layer.borderWidth = 1
            view.layer.borderColor = UIColor.gray.cgColor
        }
        
        // Tap gesture - tappable area
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(beginEditing(gesture:)))
        tappableView.addGestureRecognizer(tapGesture)
        tappableView.isUserInteractionEnabled = true
        
        // Tap gesture - main view
        let mainViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(stopEditing(gesture:)))
        self.view.addGestureRecognizer(mainViewTapGesture)
        self.view.isUserInteractionEnabled = true
        
        // Create keyboard notification
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        // Login button corner radius
        loginButton.layer.cornerRadius = 5
        loginButton.layer.masksToBounds = true
        loginButton.clipsToBounds = true
        
        // Header View Gradient
        //func setGradientBackground() {
        let colorTop =  UIColor(red: 255.0/255.0, green: 149.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 255.0/255.0, green: 94.0/255.0, blue: 58.0/255.0, alpha: 1.0).cgColor

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = self.headerView.frame
        
        headerView.clipsToBounds = true

        self.headerView.layer.insertSublayer(gradientLayer, at: 0)
        //}
    }
    
    // Keyboard functions
    @objc func handleKeyboardWillShow(notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.headerView.transform = CGAffineTransform(translationX: 0, y: -self.logoWrapper.frame.maxY)
            self.middleView.transform = CGAffineTransform(translationX: 0, y: -self.logoWrapper.frame.maxY)
        }
    }
    
    @objc func handleKeyboardWillHide(notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.headerView.transform = .identity
            self.middleView.transform = .identity
        }
    }


    //VDA
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.layoutIfNeeded()
    }
    
    // Begin editing func
    @objc func beginEditing(gesture: UITapGestureRecognizer) {
        // Become responder
        textField.becomeFirstResponder()
        
        // Check if is editing
        guard !isEditingTextField else { return }
        
        // Deactive constraints
        bottom.isActive = false
        left.isActive = false
        
        // Animate
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            
            // Layout if need
            self.passwordLabel.layoutIfNeeded()
            self.view.layoutIfNeeded()
            
            // Alphas
            self.dotsStackView.alpha = 1
            self.lineView.alpha = 0
            
            // Set editing to true
        }) { (_) in
            self.isEditingTextField = true
        }
    }
    
    // Stop editing view tap
    @objc func stopEditing(gesture: UIGestureRecognizer) {
        endEditing()
    }
    
    // Reset to initial state
    func resetToInitialState() {

        // Constraints
        bottom.isActive = true
        left.isActive = true
        
        // Dots View
        for view in dotsStackView.subviews as [UIView] {
            view.backgroundColor = .white
            view.layer.borderColor = UIColor.gray.cgColor
        }
        dotsStackView.alpha = 0.0
        
        // Line View
        lineView.alpha = 1.0
        
        // Button
        self.loginButton.frame.origin.x = 0
        self.loginButton.frame.size.width = tappableView.frame.width
        self.loginButton.layer.cornerRadius = 5
        self.loginButton.setTitle("acessar", for: .normal)
        self.loginButton.isEnabled = false
        
        // Text Field
        textField.text = ""

        // Layout if Needed
        self.view.layoutIfNeeded()
    }

    // End editing func
    func endEditing() {
        
        // Check if is editing the text
        guard isEditingTextField else {return}
        
        // Resign responder
        textField.resignFirstResponder()
        
        // Check if is typing
        if textField.text?.count == 0 {
        
            // Animate
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                
                // Reset to initial state
                self.resetToInitialState()
            })
        }
        
        // Set editing to false
        self.isEditingTextField = false
    }
    

    // Text field did changed
    @IBAction func textDidChanged(_ sender: Any) {
        // Reset all dots to white
        for view in dotsStackView.subviews as [UIView] {
            view.backgroundColor = .white
        }

        // Text field propreties
        let textFieldText = textField.text!
        let textFieldCount = textFieldText.count

        // Dots array
        let dotsArray = dotsStackView.subviews as [UIView]

        // Loop throw text field count to fill up dots
        if textFieldCount > 0 {
            for x in 0...textFieldText.count - 1 {
                dotsArray[x].backgroundColor = .gray
            }
        } else {
            for view in dotsStackView.subviews as [UIView] {
                view.backgroundColor = .white
            }
        }
        
        // Enable login button if text field count is == 4
        if textFieldCount >= 4 {
            loginButton.isEnabled = true
        } else {
            loginButton.isEnabled = false
        }
    }
    
    // IBAction methods
    @IBAction func loginButtonDidPressed(_ sender: Any) {
        endEditing()
        
        UIView.animate(withDuration: 0.3, animations: {
            
            // Login Button animations
            self.loginButton.frame.origin.x = (self.tappableView.frame.width / 2) - 25
            self.loginButton.frame.size.width = 50
            self.loginButton.layer.cornerRadius = 25
            self.loginButton.setTitle("", for: .normal)
        }) { (_) in
            
            // Activity Indicator
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
            self.loginButton.addSubview(activityIndicator)
            activityIndicator.center = self.loginButton.convert(self.loginButton.center, from:self.loginButton.superview)
            activityIndicator.startAnimating()
            
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { (_) in
                
                // Remove activity indicator
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
                
                // Check password
                if self.textField.text == "1234" {
                
                    let sucessImageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
                    sucessImageView.image = UIImage(named: "sucess")
                    sucessImageView.alpha = 0
                    self.loginButton.addSubview(sucessImageView)
                    
                    UIView.animateKeyframes(withDuration: 1.5, delay: 0, options: UIViewKeyframeAnimationOptions.calculationModeLinear, animations: {
                        
                        UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.1, animations: {
                            sucessImageView.alpha = 1
                        })
                        
                        UIView.addKeyframe(withRelativeStartTime: 0.9, relativeDuration: 0.1, animations: {
                            sucessImageView.alpha = 0
                        })
                        
                    }, completion: { (_) in
                        
                        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SecondViewController")
                        vc.transitioningDelegate = self
                        self.present(vc, animated: true, completion: nil)
                        
                        sucessImageView.removeFromSuperview()
                    })
                }
                
                else {
                    let alert = UIAlertController(title: "Senha incorreta", message: "Preencha a senha corretamente", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: {
                        self.resetToInitialState()
                    })
                }
            })
        }
    }
    
    // Unwind func
    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {}
}

// Text field delegate methods
extension ViewController: UITextFieldDelegate {
    // Limit text field lenght to 4 digits
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 4 // Bool
    }
}

// Transition Delegate methods
extension ViewController: UIViewControllerTransitioningDelegate {
    
    // For presenting
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animator
    }
    
    // For dismissing
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
}
