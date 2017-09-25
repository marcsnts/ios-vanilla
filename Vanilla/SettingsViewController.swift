//
//  SettingsViewController.swift
//  Vanilla
//
//  Created by Marc Santos on 2017-09-25.
//  Copyright © 2017 Alex. All rights reserved.
//

import UIKit
import FlybitsSDK

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    enum Section {
        case projectID, environment

        var title: String {
            return self == .projectID ? "Project id" : "Environment"
        }
        static let count = 2
    }

    enum Environment: String {
        // Order (hash value) corresponds to Flybits environment raw values
        case production = "Production",
        productionEurope = "Production Europe",
        staging = "Staging",
        development = "Development"

        static let count = 4
        static let all = [Environment.production, Environment.productionEurope, Environment.development, Environment.staging]
    }

    @IBOutlet weak var tableView: UITableView!
    var projectID: String?
    let defaultCellReuseID = "DefaultCell"
    var lastCellChecked: CheckCell?
    var environment: Environment = .production

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let newProjectID = projectID {
            updateProjectIDTo(newProjectID)
        }
        updateEnvironmentTo(environment)
    }

    func updateProjectIDTo(_ newID: String) {
        guard let url = Bundle.main.url(forResource: "FlybitsProjectID", withExtension: "plist") else {
            return
        }

        if let plistDictionary = NSMutableDictionary(contentsOf: url) {
            plistDictionary["ProjectID"] = newID
            plistDictionary.write(to: url, atomically: true)
        }
    }

    func updateEnvironmentTo(_ newEnvironment: Environment) {
        guard let newEnvironment = FlybitsManager.Environment(rawValue: newEnvironment.hashValue) else { return }
        FlybitsManager.environment = newEnvironment
    }

    // MARK: - Text field selector
    func projectIDFieldDidChange(_ textField: UITextField) {
        projectID = textField.text
    }

    // MARK: - Table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == Section.projectID.hashValue ? 1 : Environment.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == Section.projectID.hashValue ? Section.projectID.title : Section.environment.title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: indexPath.section == Section.projectID.hashValue ? TextFieldCell.reuseID : CheckCell.reuseID,
                                                 for: indexPath)
        cell.selectionStyle = .none
        switch indexPath.section {
        case Section.projectID.hashValue:
            (cell as! TextFieldCell).textField.text = (UIApplication.shared.delegate as! AppDelegate).getFlybitsProjectID()
            (cell as! TextFieldCell).textField.addTarget(self, action: #selector(projectIDFieldDidChange(_:)), for: .editingChanged)
        case Section.environment.hashValue:
            (cell as! CheckCell).checkmarkImageView.tintColor = UINavigationBar.appearance().tintColor
            let environment = Environment.all[indexPath.row]
            (cell as! CheckCell).titleLabel.text = environment.rawValue
            if FlybitsManager.environment.rawValue == environment.hashValue {
                (cell as! CheckCell).isChecked = true
                lastCellChecked = cell as? CheckCell
            } else {
                (cell as! CheckCell).isChecked = false
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
        if let environmentString = cell.titleLabel.text, let environment = Environment(rawValue: environmentString) {
            self.environment = environment
        }
        lastCellChecked = cell
    }
}

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