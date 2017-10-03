//
//  LogInViewController.swift
//  Vanilla
//
//  Created by Alex on 7/11/17.
//  Copyright © Flybits Inc. All rights reserved.
//

import UIKit
import FlybitsKernelSDK
import FlybitsContextSDK
import FlybitsPushSDK

protocol UserLogInDelegate: class {
    func connect(with flybitsIDP: FlybitsIDP, completion: @escaping (Bool, Error?) -> ())
    func logout(sender: Any?)
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
        let autoRegister = (UserDefaults.standard.value(forKey: AppDelegate.UserDefaultsKey.autoRegister.rawValue) as? Bool) ?? false
        let scopes = autoRegister ? appDelegate.autoRegisterScopes : appDelegate.scopes
        let flybitsManager = FlybitsManager(projectID: projectID, idProvider: flybitsIDP, scopes: scopes)
        (UIApplication.shared.delegate as! AppDelegate).flybitsManager = flybitsManager

        // Returns a cancellable request like all of our other requests. We disregard as we probably don't care to cancel here.
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
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Content")
        vc.navigationItem.hidesBackButton = true
        vc.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self,
                                                              action: #selector(LogInViewController.logout(sender:)))
        vc.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Context", style: .plain, target: self, action: #selector(showContext))
        DispatchQueue.main.async {
            self.show(vc, sender: self)
        }
    }

    @objc func showContext() {
        self.show(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Context"), sender: self)
    }

    @objc func logout(sender: Any?) {
        _ = navigationController?.popViewController(animated: true)
        var flybitsManager = (UIApplication.shared.delegate as! AppDelegate).flybitsManager
        if flybitsManager == nil {
            
            // When we launch the app and the static method FlybitsManager.isConnected(completion:)
            // is called and the user wishes to logout, we are forced to re-instantiate flybitsManager
            // from scratch. As a result, and until we make this easier very soon, it is required
            // that the user's credentials be stored in the Keychain so that this data is safe.
            //
            // In the meantime, as this is merely a demo/proof of concept, we store the user's
            // credentials in UserDefaults.
            
            let projectID = (UIApplication.shared.delegate as! AppDelegate).projectID!
            let scopes: [FlybitsScope] = [KernelScope(), ContextScope(timeToUploadContext: 1, timeUnit: Utilities.TimeUnit.minutes), PushScope()]
            let identityProvider = FlybitsIDP(email: UserDefaults.standard.string(forKey: "email")!, password: UserDefaults.standard.string(forKey: "password")!)
            flybitsManager = FlybitsManager(projectID: projectID, idProvider: identityProvider, scopes: scopes)
        }
        _ = flybitsManager?.disconnect { jwt, error in
            guard let _ = jwt, error == nil else {
                print("Error logging out: \(error!.localizedDescription)")
                return
            }
            print("Logged out")
        }
    }
}
