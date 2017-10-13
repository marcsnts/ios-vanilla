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
    let autoRegisterEnabled = UserDefaults.standard.getAutoRegister()
}

// MARK: - Enumerations

extension ContextViewController {
    enum Section: Int {
        case customContextPlugins
        case reservedContextPlugins

        var title: String {
            switch self {
            case .customContextPlugins:
                return "Custom context plugins"
            case .reservedContextPlugins:
                return "Reserved context plugins"
            }
        }

        static let count = 2
    }

    enum CustomContext: Int {
        case wallet

        var title: String {
            switch self{
            case .wallet:
                return "Wallet"
            }
        }
        static let all: [CustomContext] = [wallet]
    }
}

// MARK: - Table view

extension ContextViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section < Section.count ? Section(rawValue: section)?.title : nil
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == Section.reservedContextPlugins.rawValue ? ReservedContextPlugin.all.count : CustomContext.all.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < (indexPath.section == Section.reservedContextPlugins.rawValue ? ReservedContextPlugin.all.count : CustomContext.all.count) else {
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: indexPath.section == Section.customContextPlugins.rawValue ? self.defaultCellReuseID :
            ToggleCell.reuseID, for: indexPath)

        switch indexPath.section {
        case Section.customContextPlugins.rawValue:
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
                toggleCell.toggle.isOn = false
            }
        default:
            break
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == Section.customContextPlugins.rawValue else { return }
        let contextVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ContextPlugin") as! ContextPluginViewController
        contextVc.title = "Wallet"
        self.show(contextVc, sender: self)
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
