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
        
//        passwordBottomConstraint = NSLayoutConstraint(item: passwordLabel, attribute: .bottom, relatedBy: .equal, toItem: lineView, attribute: .top, multiplier: 1, constant: -10)
        
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
    
    
}

extension ViewController: UITextFieldDelegate {

    // Limit text field lenght to 4 digits
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        guard let text = textField.text else { return true }
//
//        let newLength = text.count + string.count - range.length
//
//        return newLength <= 4 // Bool
//    }
}
