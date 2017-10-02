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
    var environment = FlybitsManager.Environment(rawValue: (UserDefaults.standard.value(forKey: AppDelegate.UserDefaultsKey.environment.rawValue) as? Int) ?? 0) ?? .Production

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let newProjectID = projectID {
            updateProjectIDTo(newProjectID)
        }
        updateEnvironmentTo(environment)
    }

    func updateProjectIDTo(_ newID: String) {
        UserDefaults.standard.set(newID, forKey: AppDelegate.UserDefaultsKey.projectID.rawValue)
        (UIApplication.shared.delegate as! AppDelegate).projectID = newID
    }

    func updateEnvironmentTo(_ newEnvironment: FlybitsManager.Environment) {
        guard let newEnvironment = FlybitsManager.Environment(rawValue: newEnvironment.rawValue) else { return }
        FlybitsManager.environment = newEnvironment
        UserDefaults.standard.set(newEnvironment.rawValue, forKey: AppDelegate.UserDefaultsKey.environment.rawValue)
        UserDefaults.standard.synchronize()
    }

    // MARK: - Text field selector

    @objc func projectIDFieldDidChange(_ textField: UITextField) {
        projectID = textField.text
    }
}

// MARK: - Enumerations

extension SettingsViewController {
    enum Section {
        case projectID
        case environment

        var title: String {
            return self == .projectID ? "Project id" : "Environment"
        }
        static let count = 2
    }
}

// MARK: - Table view

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == Section.projectID.hashValue ? 1 : 4
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == Section.projectID.hashValue ? Section.projectID.title : Section.environment.title
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: indexPath.section == Section.projectID.hashValue ? TextFieldCell.reuseID : CheckCell.reuseID,
                                                 for: indexPath)
        switch indexPath.section {
        case Section.projectID.hashValue:
            if let textCell = cell as? TextFieldCell {
                textCell.textField.text = (UIApplication.shared.delegate as! AppDelegate).getFlybitsProjectID()
                textCell.textField.addTarget(self, action: #selector(projectIDFieldDidChange(_:)), for: .editingChanged)
            }
        case Section.environment.hashValue:
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
