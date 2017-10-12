//
//  CreatePushTemplateViewController.swift
//  Vanilla
//
//  Created by Marc Santos on 2017-10-12.
//  Copyright © 2017 Alex. All rights reserved.
//

import UIKit
import FlybitsPushSDK
import FlybitsContextSDK

class CreatePushTemplateViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let buttonCellReuseId = "ButtonCell"
    var selectedRule: Rule?

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @objc func goToSelectRule() {

    }
}

// MARK: - Enumerations

extension CreatePushTemplateViewController {
    enum Section: Int {
        case name
        case message
        case title
        case trigger

        var title: String {
            switch self {
            case .name: return "Template Name"
            case .message: return "Message"
            case .title: return "Title"
            case .trigger: return "Trigger"
            }
        }

        static var count = 4
    }
}

// MARK: - Table view

extension CreatePushTemplateViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Section(rawValue: section)?.title
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = indexPath.section == Section.trigger.rawValue ? buttonCellReuseId : TextFieldCell.reuseID
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)

        if let textFieldCell = cell as? TextFieldCell {
            switch indexPath.section {
            case Section.name.rawValue: textFieldCell.textField.placeholder = "Template name"
            case Section.title.rawValue: textFieldCell.textField.placeholder = "Title"
            case Section.message.rawValue: textFieldCell.textField.placeholder = "Message"
            default: break
            }
        } else {
            // Select a rule cell
            cell.textLabel?.text = "Select a rule"
            cell.textLabel?.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(goToSelectRule)))
        }

        return cell
    }
}
