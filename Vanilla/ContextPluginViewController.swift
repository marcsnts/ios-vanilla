//
//  ContextPluginViewController.swift
//  Vanilla
//
//  Created by Marc Santos on 2017-10-03.
//  Copyright © 2017 Flybits Inc. All rights reserved.
//

import UIKit
import FlybitsContextSDK

class ContextPluginViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var plugin: ContextPlugin?
    var wallet = WalletContextPlugin(balance: 50.00, containsPhotoId: true, owner: "Marc Santos")

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Send context", style: .plain, target: self, action: #selector(sendContext))
    }

    // MARK: - Selectors

    @objc func sendContext() {
        _ = ContextDataRequest.sendData([self.wallet.toDictionary()], completion: { error in
            let alert: UIAlertController = {
                let alert = UIAlertController(title: "Success", message: "Context data has been sucessfully sent", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                alert.addAction(UIAlertAction(title: "Go to plugins", style: .default, handler: { _ in
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }))
                return alert
            }()
            guard error == nil else {
                print(error!.localizedDescription)
                alert.title = "Something went wrong"
                alert.message = "Context data could not be sent"
                return
            }
            defer {
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }).execute()
    }

    @objc func updateBalance(_ textField: UITextField) {
        self.wallet.balance = Double(textField.text ?? "0")
    }

    @objc func updateOwner(_ textField: UITextField) {
        self.wallet.owner = textField.text
    }
}

// MARK: - Enumerations

extension ContextPluginViewController {
    enum Section: Int {
        case owner
        case balance
        case photoId

        var title: String {
            switch self {
            case .owner:
                return "Owner"
            case .balance:
                return "Balance"
            case .photoId:
                return "Photo ID"
            }
        }

        static let all: [Section] = [.owner, .balance, .photoId]
    }
}

// MARK: - Table view

extension ContextPluginViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.all.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section < Section.all.count ? Section.all[section].title : nil
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = indexPath.section == Section.owner.rawValue || indexPath.section == Section.balance.rawValue
                         ? TextFieldCell.reuseID : ToggleCell.reuseID
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)

        switch indexPath.section {
        case Section.owner.rawValue:
            if let ownerCell = cell as? TextFieldCell {
                ownerCell.textField.keyboardType = .alphabet
                ownerCell.textField.text = self.wallet.owner
                ownerCell.textField.addTarget(self, action: #selector(updateOwner(_:)), for: .allEditingEvents)
            }
        case Section.balance.rawValue:
            if let balanceCell = cell as? TextFieldCell {
                balanceCell.textField.keyboardType = .decimalPad
                balanceCell.textField.text = "\(self.wallet.balance ?? 0)"
                balanceCell.textField.addTarget(self, action: #selector(updateBalance(_:)), for: .allEditingEvents)
            }
        case Section.photoId.rawValue:
            if let photoIdCell = cell as? ToggleCell {
                photoIdCell.titleLabel.text = "Wallet contains photo id"
                photoIdCell.toggle.isOn = self.wallet.containsPhotoId ?? false
                photoIdCell.action = {self.wallet.containsPhotoId = $0}
            }
        default:
            break
        }

        return cell
    }
}
