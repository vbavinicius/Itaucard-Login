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
    var passwordLeftConstraint: NSLayoutConstraint!
    var passwordLeft2Constraint: NSLayoutConstraint!
    var passwordBottomConstraint: NSLayoutConstraint!
    var passwordTopConstraint: NSLayoutConstraint!
    var passwordHeightConstraint: NSLayoutConstraint!
    
    
    // Variables
    var isEditingTextField: Bool = false
    var isMoreThanZeroDigits: Bool = false
    
    
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(gesture:)))
        tappableView.addGestureRecognizer(tapGesture)
        tappableView.isUserInteractionEnabled = true
        
        // Tap gesture - main view
        let mainViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(stopEditing(gesture:)))
        self.view.addGestureRecognizer(mainViewTapGesture)
        self.view.isUserInteractionEnabled = true
        
        // Create keyboard notification
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillChange(notification:)), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        // Login button corner radius
        loginButton.layer.cornerRadius = 5
        loginButton.layer.masksToBounds = true
        loginButton.clipsToBounds = true
    }
    
    // Keyboard functions
    @objc func handleKeyboardWillShow(notification: Notification) {
        print("show")
        UIView.animate(withDuration: 0.3) {
            self.headerView.transform = CGAffineTransform(translationX: 0, y: -self.logoWrapper.frame.maxY)
            self.middleView.transform = CGAffineTransform(translationX: 0, y: -self.logoWrapper.frame.maxY)
        }
    }
    
    @objc func handleKeyboardWillHide(notification: Notification) {
        print("hide")
        UIView.animate(withDuration: 0.3) {

            self.headerView.transform = .identity
            self.middleView.transform = .identity
        }
    }
    
    @objc func handleKeyboardWillChange(notification: Notification) {
        print("change")
    }

    //VDA
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Setup constraints after view did load
        createPasswordLabelConstraints()
        NSLayoutConstraint.activate([passwordLeftConstraint, passwordHeightConstraint, passwordBottomConstraint])
        self.view.layoutIfNeeded()
    }
    
    @objc func handleTap(gesture: UITapGestureRecognizer) {
        beginEditing()
    }
    
    @objc func stopEditing(gesture: UIGestureRecognizer) {
        endEditing()
    }
    
    func beginEditing() {
        
        textField.becomeFirstResponder()
        
        guard !isEditingTextField else { return }
        
        passwordTopConstraint.isActive = true
        passwordBottomConstraint.isActive = false

        passwordLeftConstraint.isActive = false
        passwordLeft2Constraint.isActive = true
        
 
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            
            self.passwordLabel.layoutIfNeeded()
            self.view.layoutIfNeeded()
            
            self.dotsStackView.alpha = 1
            self.lineView.alpha = 0
            
        }) { (_) in
            self.isEditingTextField = !self.isEditingTextField
        }
    }
    
    
    func endEditing() {
        
        guard isEditingTextField else {return}
        
        textField.resignFirstResponder()
        
        if isMoreThanZeroDigits {
            
        }
        
        else if !isMoreThanZeroDigits {
            
            passwordTopConstraint.isActive = false
            passwordBottomConstraint.isActive = true
            
            passwordLeft2Constraint.isActive = false
            passwordLeftConstraint.isActive = true
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                
                self.passwordLabel.layoutIfNeeded()
                self.view.layoutIfNeeded()
                
                self.dotsStackView.alpha = 0
                self.lineView.alpha = 1
                
            }) { (_) in
                self.isEditingTextField = !self.isEditingTextField
            }
            
        }
    }
    

    // Create constraints
    func createPasswordLabelConstraints() {
        let distance = (tappableView.frame.width / 2) - (passwordLabel.frame.width / 2)
        
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        
        passwordHeightConstraint = NSLayoutConstraint(item: passwordLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 17)
        
        passwordLeftConstraint = NSLayoutConstraint(item: passwordLabel, attribute: .leading, relatedBy: .equal, toItem: passwordLabel.superview, attribute: .leading, multiplier: 1, constant: 0)
        
        passwordLeft2Constraint = NSLayoutConstraint(item: passwordLabel, attribute: .leading, relatedBy: .equal, toItem: passwordLabel.superview, attribute: .leading, multiplier: 1, constant: distance)
        
        passwordBottomConstraint = NSLayoutConstraint(item: passwordLabel, attribute: .bottom, relatedBy: .equal, toItem: tappableView, attribute: .bottom, multiplier: 1, constant: -26)
        
        passwordTopConstraint = NSLayoutConstraint(item: passwordLabel, attribute: .top, relatedBy: .equal, toItem: passwordLabel.superview, attribute: .top, multiplier: 1, constant: 0)
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
        
        // Check if there more than zero digits
        if textFieldCount > 0 {
            isMoreThanZeroDigits = true
        } else {
            isMoreThanZeroDigits = false
        }
        
        print("text: \(textField.text!)")
        print("count: \(textFieldCount)")
    }
    
    // IBAction methods
    @IBAction func loginButtonDidPressed(_ sender: Any) {
        print("button pressed")
        endEditing()
        
        UIView.animate(withDuration: 0.3, animations: {
            self.loginButton.frame.origin.x = (self.tappableView.frame.width / 2) - 25
            self.loginButton.frame.size.width = 50
            self.loginButton.layer.cornerRadius = 25
            self.loginButton.setTitle("", for: .normal)
        }) { (_) in
            
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)

            self.loginButton.addSubview(activityIndicator)
            
            activityIndicator.center = self.loginButton.convert(self.loginButton.center, from:self.loginButton.superview)
            activityIndicator.startAnimating()
            
            Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: { (_) in
                print("timer")
                
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SecondViewController")
                self.present(vc, animated: true, completion: nil)
            })
        }
        
        
    }
    
}

extension ViewController: UITextFieldDelegate {

    // Limit text field lenght to 4 digits
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }

        let newLength = text.count + string.count - range.length

        return newLength <= 4 // Bool
    }
}
