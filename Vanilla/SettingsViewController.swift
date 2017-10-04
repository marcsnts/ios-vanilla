//
//  SettingsViewController.swift
//  Vanilla
//
//  Created by Marc Santos on 2017-09-25.
//  Copyright © Flybits Inc. All rights reserved.
//

import UIKit
import FlybitsContextSDK

class SettingsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var projectID: String?
    let defaultCellReuseID = "DefaultCell"
    var lastCellChecked: CheckCell?
    var environment = FlybitsManager.environment
    lazy var autoRegister: Bool = UserDefaults.standard.getAutoRegister()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Search user defaults if environment exists and use that
        if let environmentRawValue = UserDefaults.standard.getEnvironment(), let environment = FlybitsManager.Environment(rawValue: environmentRawValue) {
            self.environment = environment
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let newProjectID = projectID {
            updateProjectIDTo(newProjectID)
        }
        updateEnvironmentTo(environment)
        updateAutoRegisterTo(autoRegister)
        UserDefaults.standard.synchronize()
    }

    func updateProjectIDTo(_ newID: String) {
        UserDefaults.standard.set(newID, forKey: AppDelegate.UserDefaultsKey.projectID.rawValue)
        (UIApplication.shared.delegate as! AppDelegate).projectID = newID
    }

    func updateEnvironmentTo(_ newEnvironment: FlybitsManager.Environment) {
        guard let newEnvironment = FlybitsManager.Environment(rawValue: newEnvironment.rawValue) else { return }
        FlybitsManager.environment = newEnvironment
        UserDefaults.standard.set(newEnvironment.rawValue, forKey: AppDelegate.UserDefaultsKey.environment.rawValue)
    }

    func updateAutoRegisterTo(_ newAutoRegister: Bool) {
        UserDefaults.standard.set(newAutoRegister, forKey: AppDelegate.UserDefaultsKey.autoRegisterContextPlugins.rawValue)
    }

    // MARK: - Text field selector

    @objc func projectIDFieldDidChange(_ textField: UITextField) {
        projectID = textField.text
    }
}

// MARK: - Enumerations

extension SettingsViewController {
    enum Section: Int {
        case projectID
        case environment
        case autoRegister

        var title: String {
            switch self {
            case .projectID:
                return "Project id"
            case .environment:
                return "Environment"
            case .autoRegister:
                return "Auto register"
            }
        }
        var numberOfRows: Int {
            switch self {
            case .projectID:
                return 1
            case .environment:
                return FlybitsManager.Environment.count
            case .autoRegister:
                return 1
            }
        }

        static let count = 3
    }
}

// MARK: - Table view

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Section(rawValue: section)?.numberOfRows ?? 0
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Section(rawValue: section)?.title
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = indexPath.section == Section.projectID.rawValue ? TextFieldCell.reuseID :
                             (indexPath.section == Section.environment.rawValue ? CheckCell.reuseID : ToggleCell.reuseID)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        switch indexPath.section {
        case Section.projectID.rawValue:
            if let textCell = cell as? TextFieldCell {
                textCell.textField.text = (UIApplication.shared.delegate as! AppDelegate).getFlybitsProjectID()
                textCell.textField.addTarget(self, action: #selector(projectIDFieldDidChange(_:)), for: .editingChanged)
            }
        case Section.environment.rawValue:
            if let checkCell = cell as? CheckCell, let environment = FlybitsManager.Environment(rawValue: indexPath.row) {
                checkCell.checkmarkImageView.tintColor = UINavigationBar.appearance().tintColor
                checkCell.titleLabel.text = environment.toString()
                if self.environment == environment {
                    checkCell.isChecked = true
                    lastCellChecked = checkCell
                } else {
                    checkCell.isChecked = false
                }
            }
        case Section.autoRegister.rawValue:
            if let toggleCell = cell as? ToggleCell {
                toggleCell.titleLabel.text = "Enable auto register plugins"
                toggleCell.toggle.isOn = self.autoRegister
                toggleCell.action = { self.autoRegister = $0 }
            }
        default:
            break
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == Section.environment.hashValue else { return }

        lastCellChecked?.isChecked = false
        let cell = tableView.cellForRow(at: indexPath) as! CheckCell
        cell.isChecked = !cell.isChecked
        if let environment = FlybitsManager.Environment(rawValue: indexPath.row) {
            self.environment = environment
        }
        lastCellChecked = cell
    }
}

extension FlybitsManager.Environment {
    func toString() -> String {
        switch self {
        case .Development:
            return "Development"
        case .Production:
            return "Production"
        case .Production_Europe:
            return "Production Europe"
        case .Staging:
            return "Staging"
        }
    }

    static let count = 4
}

// MARK: - Settings table view cells

class TextFieldCell: UITableViewCell {
    static let reuseID = "TextFieldCell"
    @IBOutlet weak var textField: UITextField!
}

class CheckCell: UITableViewCell {
    static let reuseID = "CheckCell"
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkmarkImageView: UIImageView!
    var isChecked: Bool = false {
        didSet {
            checkmarkImageView.isHidden = !isChecked
        }
    }
}
