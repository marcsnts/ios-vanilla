//
//  CreatePushTemplateViewController.swift
//  Vanilla
//
//  Created by Marc Santos on 2017-10-12.
//  Copyright © 2017 Flybits Inc. All rights reserved.
//

import UIKit
import FlybitsPushSDK
import FlybitsContextSDK

protocol CreatePushTemplateDelegate {
    func passRule(_ rule: Rule)
}

class CreatePushTemplateViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let buttonCellReuseId = "ButtonCell"
    var nameTextField: UITextField?
    var titleTextField: UITextField?
    var messageTextField: UITextField?
    var selectedRule: Rule?
    var selectedRuleResultCell: RuleResultCheckCell? {
        willSet { selectedRuleResultCell?.isChecked = false }
        didSet { selectedRuleResultCell?.isChecked = true }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "New Push Template"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(createPushTemplate))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    @objc func createPushTemplate() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let presentFailedAlert: (String, String) -> Void = { title, message in
            alert.title = title
            alert.message = message
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        guard let name = nameTextField?.text, !name.isEmpty, let title = titleTextField?.text, !title.isEmpty,
              let message = messageTextField?.text, !message.isEmpty else {
            presentFailedAlert("Missing fields", "Please fill in all missing fields")
            return
        }
        guard let ruleId = selectedRule?.identifier else {
            presentFailedAlert("Rule not selected", "Please select a rule")
            return
        }
        guard let ruleResult = self.selectedRuleResultCell?.ruleResult else {
            presentFailedAlert("Result for rule not selected", "Please select a rule")
            return
        }

        let pushTemplate = PushTemplate(name: name, title: title, message: message).addRule(ruleID: ruleId, result: ruleResult)

        _ = PushTemplateRequest.create(pushTemplate: pushTemplate, completion: { template, error in
            guard let template = template, error == nil else {
                print(error!.localizedDescription)
                presentFailedAlert("Failed", error!.localizedDescription)
                return
            }

            print("Push Template successfully created!")
            alert.title = "Success"
            alert.message = "\(template.name) push template has been successfully created!"
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }).execute()
    }

    @objc func goToSelectRule() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let ruleListVc = storyboard.instantiateViewController(withIdentifier: "ContextRulesList") as? ContextRulesListViewController else { return }

        ruleListVc.pushTemplateDelegate = self
        self.show(ruleListVc, sender: self)
    }
}

// MARK: - Enumerations

extension CreatePushTemplateViewController {
    enum Section: Int {
        case name
        case title
        case message
        case rule
        case trigger

        var title: String {
            switch self {
            case .name: return "Template Name"
            case .message: return "Message"
            case .title: return "Title"
            case .rule: return "Rule"
            case .trigger: return "Trigger"
            }
        }

        static let count = 5
    }
}

// MARK: - Push Template Delegate

extension CreatePushTemplateViewController: CreatePushTemplateDelegate {
    func passRule(_ rule: Rule) {
        self.selectedRule = rule
    }
}

// MARK: - Table view

extension CreatePushTemplateViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.selectedRule == nil ? Section.count - 1 : Section.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == Section.trigger.rawValue {
            return RuleResult.numberOfPossibleResults
        }
        return section == Section.rule.rawValue && self.selectedRule != nil ? 2 : 1
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Section(rawValue: section)?.title
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = identifierForCell(atIndexPath: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)

        // Name, title, message cells
        if let textFieldCell = cell as? TextFieldCell {
            switch indexPath.section {
            case Section.name.rawValue:
                textFieldCell.textField.placeholder = "Push template name"
                self.nameTextField = textFieldCell.textField
            case Section.title.rawValue:
                textFieldCell.textField.placeholder = "Push title"
                self.titleTextField = textFieldCell.textField
            case Section.message.rawValue:
                textFieldCell.textField.placeholder = "Push message"
                self.messageTextField = textFieldCell.textField
            default: break
            }
        } else if let ruleCell = cell as? ContextRuleCell, let rule = self.selectedRule {
            // Rule
            ruleCell.rule = rule
        } else if let ruleResultCell = cell as? RuleResultCheckCell {
            // Rule result
            let result = RuleResult(rawValue: indexPath.row + 1) // Rule results being from 1, not 0..
            ruleResultCell.ruleResult = result
            ruleResultCell.titleLabel.text = result?.string
            // Default result is true
            if result == .true {
                self.selectedRuleResultCell = ruleResultCell
            } else {
                ruleResultCell.isChecked = false
            }
        } else {
            // Select a rule cell
            cell.textLabel?.text = self.selectedRule == nil ? "Select a rule" : "Change rule"
            cell.textLabel?.textColor = UINavigationBar.appearance().tintColor
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goToSelectRule))
            cell.textLabel?.addGestureRecognizer(tapGesture)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let _ = tableView.cellForRow(at: indexPath) as? ContextRuleCell {
            return ContextRuleCell.height
        }

        // Default cell height
        return 44
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let ruleResultCell = tableView.cellForRow(at: indexPath) as? RuleResultCheckCell else { return }
        self.selectedRuleResultCell = ruleResultCell
    }

    private func identifierForCell(atIndexPath indexPath: IndexPath) -> String {
        var identifier = TextFieldCell.reuseID
        if indexPath.section == Section.rule.rawValue {
            identifier = self.selectedRule != nil && indexPath.row == 0 ? ContextRuleCell.reuseID : buttonCellReuseId
        } else if indexPath.section == Section.trigger.rawValue {
            identifier = RuleResultCheckCell.reuseID
        }

        return identifier
    }
}
