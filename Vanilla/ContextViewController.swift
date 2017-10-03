//
//  ContextViewController.swift
//  Vanilla
//
//  Created by Marc Santos on 2017-10-02.
//  Copyright © 2017 Flybits Inc. All rights reserved.
//

import UIKit
import FlybitsContextSDK

class ContextViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let defaultCellReuseID = "DefaultCell"
}

// MARK: - Enumerations

extension ContextViewController {
    enum Section: Int {
        case sendCustomContext
        case reservedContextPlugins
    }

    enum CustomContext: Int {
        case walletBalance
        case walletCreditCard

        var title: String {
            switch self {
            case .walletBalance:
                return "Change the amount of money in the wallet"
            case .walletCreditCard:
                return "Change the credit card of the wallet"
            }
        }

        static let all: [CustomContext] = [.walletBalance, .walletCreditCard]
    }
}

// MARK: - Table view

extension ContextViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Send custom context" : "Reserved context plugins"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == Section.reservedContextPlugins.rawValue ? ReservedContextPlugin.all.count : CustomContext.all.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < (indexPath.section == Section.reservedContextPlugins.rawValue ? ReservedContextPlugin.all.count : CustomContext.all.count) else {
            return UITableViewCell()
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: indexPath.section == Section.sendCustomContext.rawValue ? self.defaultCellReuseID :
            ToggleCell.reuseID, for: indexPath)

        switch indexPath.section {
        case Section.sendCustomContext.rawValue:
            if let customContext = CustomContext(rawValue: indexPath.row) {
                cell.textLabel?.text = customContext.title
            }
        case Section.reservedContextPlugins.rawValue:
            if let toggleCell = cell as? ToggleCell {
                let contextPlugin = ReservedContextPlugin.all[indexPath.row]
                toggleCell.titleLabel.text = contextPlugin.title
                toggleCell.action = { pluginIsOn in
                    if pluginIsOn {
                        ContextManager.shared.register(contextPlugin, refreshTime: 15, timeUnit: .seconds)
                    } else {
                        ContextManager.shared.remove(contextPlugin)
                    }
                }
            }
        default:
            break
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == Section.sendCustomContext.rawValue else { return }
        guard let context = CustomContext(rawValue: indexPath.row) else { return }
        presentActionAlertFor(context)
    }

    private func presentActionAlertFor(_ context: CustomContext) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let sendContextData: (WalletContextPlugin) -> Void = { wallet in
            _ = ContextDataRequest.sendData([wallet.toDictionary()], completion: { error in
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                print("Successfully uploaded context data")
            }).execute()
        }
        switch context {
        case .walletBalance:
            alert.title = "Change wallet balance"
            alert.message = "Enter the new balance"
            alert.addTextField(configurationHandler: {$0.keyboardType = .numberPad})
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
                if let newBalanceString = alert.textFields?.first?.text, let newBalance = Double(newBalanceString) {
                    sendContextData(WalletContextPlugin(hasCreditCard: nil, money: newBalance))
                }
            }))
        case .walletCreditCard:
            alert.title = "Change wallet has credit card"
            alert.message = "Select the new status"
            alert.addAction(UIAlertAction(title: "True", style: .default, handler: { _ in
                sendContextData(WalletContextPlugin(hasCreditCard: true, money: nil))
            }))
            alert.addAction(UIAlertAction(title: "False", style: .default, handler: { _ in
                sendContextData(WalletContextPlugin(hasCreditCard: false, money: nil))
            }))
        }

        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - Reserved context plugin support for sections

extension ReservedContextPlugin {
    static let all: [ReservedContextPlugin] = [.activity, .audio, .availability, .battery, .carrier, .coreLocation,
                                               .eddystone, .iBeacon, .language, .network, .oAuth, .pedometerSteps]
    var title: String {
        switch self {
        case .activity:
            return "Activity"
        case .audio:
            return "Audio"
        case .availability:
            return "Availability"
        case .battery:
            return "Battery"
        case .carrier:
            return "Carrier"
        case .coreLocation:
            return "Core location"
        case .eddystone:
            return "Eddystone"
        case .iBeacon:
            return "iBeacon"
        case .language:
            return "Language"
        case .network:
            return "Network"
        case .oAuth:
            return "oAuth"
        case .pedometerSteps:
            return "Pedometer"
        }
    }
}
