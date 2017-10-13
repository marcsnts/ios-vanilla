//
//  LogInViewController.swift
//  Vanilla
//
//  Created by Flybits Inc on 7/11/17.
//  Copyright © Flybits Inc. All rights reserved.
//

import UIKit
import FlybitsKernelSDK
import FlybitsContextSDK
import FlybitsPushSDK

protocol UserLogInDelegate: class {
    func connect(with flybitsIDP: FlybitsIDP, completion: @escaping (Bool, Error?) -> ())
}

class LogInViewController: UIViewController, UITextFieldDelegate, UserLogInDelegate {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!

    enum SegueId: String {
        case register = "RegisterSegue",
        settings = "SettingsSegue"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(LogInViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        _ = FlybitsManager.isConnected(completion: { isConnected, user, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard isConnected, let user = user else {
                return
            }
            print("Welcome back, \(user.firstname!)")
            print("User is connected. Will show relevant content.")
            self.showContent()
        })
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func submit(sender: Any?) {
        guard let email = emailTextField.text, email.characters.count > 0,
            let password = passwordTextField.text, password.characters.count > 0 else {
            return
        }
        
        let identityProvider = FlybitsIDP(email: email, password: password)
        connect(with: identityProvider) { success, error in
            guard success == true, error == nil else {
                let alertController = UIAlertController(title: "Failed logging in", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            print("Logged in")
            
            UserDefaults.standard.set(email, forKey: "email")
            UserDefaults.standard.set(password, forKey: "password")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! == "RegisterSegue" {
            (segue.destination as! RegisterViewController).logInDelegate = self
        }
    }
    
    // MARK: - UserLogInDelegate
    
    func connect(with flybitsIDP: FlybitsIDP, completion: @escaping (Bool, Error?) -> ()) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let projectID = appDelegate.projectID!
        let autoRegister = UserDefaults.standard.getAutoRegister()
        let scopes = autoRegister ? appDelegate.autoRegisterScopes : appDelegate.scopes
        let flybitsManager = FlybitsManager(projectID: projectID, idProvider: flybitsIDP, scopes: scopes)
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: flybitsManager), forKey: UserDefaults.Key.flybitsManager.rawValue)

        _ = flybitsManager.connect { user, error in
            guard let user = user, error == nil else {
                print("Failed to connect")
                completion(false, NSError(domain: "com.flybits.app.ios-vanilla", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to connect"]))
                return
            }
            print("Welcome, \(user.firstname!)")
            self.showContent()
            completion(true, nil)
        }
    }
    
    func showContent() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBar")
        DispatchQueue.main.async {
            self.present(vc, animated: true, completion: nil)
        }
    }
}
