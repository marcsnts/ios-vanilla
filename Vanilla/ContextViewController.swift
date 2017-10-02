//
//  ContextViewController.swift
//  Vanilla
//
//  Created by Marc Santos on 2017-10-02.
//  Copyright © 2017 Alex. All rights reserved.
//

import UIKit
import FlybitsContextSDK

class ContextViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension ReservedContextPlugin {
    static let all: [ReservedContextPlugin] = [.activity, .audio, .availability, .battery, .carrier, .coreLocation,
                                               .eddystone, .iBeacon, .language, .network, .oAuth, .pedometerSteps]
    func title() -> String {
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

extension ContextViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        return section == 0 ? "Send custom context" : "Reserved Context Plugins"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ReservedContextPlugin.all.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < ReservedContextPlugin.all.count else { return UITableViewCell() }

        let cell = tableView.dequeueReusableCell(withIdentifier: ToggleCell.reuseID, for: indexPath) as! ToggleCell
        let contextPlugin = ReservedContextPlugin.all[indexPath.row]
        cell.titleLabel.text = contextPlugin.title()
        cell.action = { pluginIsOn in
            if pluginIsOn {
                ContextManager.shared.register(contextPlugin, refreshTime: 15, timeUnit: .seconds)
            } else {
                ContextManager.shared.remove(contextPlugin)
            }
        }
        
        return cell
    }
}

class SendContextTextFieldCell: UITableViewCell {
    static let reuseID = "SendContextCell"
    
}

class ToggleCell: UITableViewCell {
    static let reuseID = "ToggleCell"
    var action: ((Bool) -> Void)?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var toggle: UISwitch!
    @IBAction func toggleDidChange(_ sender: Any) {
        guard let action = self.action else { return }
        action(toggle.isOn)
    }
}
