//
//  RegisterViewController.swift
//  tilQuiz
//
//  Created by Mador Til on 29/08/2018.
//  Copyright © 2018 Mador Til. All rights reserved.
//

import UIKit
import IBAnimatable
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var verifyPasswordTextField: UITextField!
    
    @IBOutlet weak var RegisteringActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func emailRegister(_ sender: UIButton) {
        var readyToCreateUser = true
        if !nicknameTextField.text!.isValidNickname() {
            nicknameTextField.shake()
            readyToCreateUser = false
        }
        if !emailTextField.text!.isValidEmail() {
            emailTextField.shake()
            readyToCreateUser = false
        }
        if !passwordTextField.text!.isValidPassword() {
            passwordTextField.shake()
            readyToCreateUser = false
        }
        if passwordTextField.text! != verifyPasswordTextField.text! {
            verifyPasswordTextField.shake()
            readyToCreateUser = false
        }
        if readyToCreateUser {
            RegisteringActivityIndicator.startAnimating()
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { [weak self] (authResult, error) in
                if let error = error {
                    self?.RegisteringActivityIndicator.stopAnimating()
                    self?.displayAlertMessage(messageToDisplay: error.localizedDescription)
                    return
                }
                if let user = authResult?.user {
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = self?.nicknameTextField.text!
                    changeRequest.commitChanges { error in
                        self?.RegisteringActivityIndicator.stopAnimating()
                        if let error = error {
                            print(error.localizedDescription)
                            do {
                                try Auth.auth().signOut()
                            } catch {
                                self?.displayAlertMessage(messageToDisplay: error.localizedDescription)
                            }
                            return
                        }
                        print("Successfully signed up")
                        self?.dismiss(animated: true)
                    }
                }
            }
        }
    }
}
