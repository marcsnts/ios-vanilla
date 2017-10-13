//
//  CreateRulePredicateViewController
//  Vanilla
//
//  Created by Marc Santos on 2017-10-05.
//  Copyright © 2017 Alex. All rights reserved.
//

import UIKit
import FlybitsContextSDK

class CreateRulePredicateViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var selectedPredicateCell: RulePredicateCheckCell? {
        willSet {
            selectedPredicateCell?.isChecked = false
        }
        didSet {
            selectedPredicateCell?.isChecked = true
        }
    }
    var selectedTypeCell: RulePredicateTypeCheckCell? {
        willSet {
            selectedTypeCell?.isChecked = false
        }
        didSet {
            selectedTypeCell?.isChecked = true
        }
    }
    var valueTextField: UITextField?
    var pluginTextField: UITextField?
    var predicateFactory = RulePredicateFactory(type: .integer, selectedOperator: .equalTo)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addRulePredicateToListView))
    }

    @objc func addRulePredicateToListView() {
        let alert = UIAlertController(title: "Failed", message: "One or more fields are missing", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        guard let predicateOperator = self.selectedPredicateCell?.predicate, let valueText = self.valueTextField?.text, !valueText.isEmpty, let pluginText = self.pluginTextField?.text, !pluginText.isEmpty, let ruleListVc = getRuleListViewController() else {
            self.present(alert, animated: true, completion: nil)
            return
        }

        var rulePredicate: RulePredicate?
        switch self.predicateFactory.type {
        case .boolean:
            rulePredicate = self.predicateFactory.makeRulePredicate(pluginId: pluginText, value: NSString(string: valueText.lowercased()).boolValue)
        case .integer:
            if let intValue = Int(valueText) {
                rulePredicate = self.predicateFactory.makeRulePredicate(pluginId: pluginText, value: intValue)
            }
        case .string:
            rulePredicate = self.predicateFactory.makeRulePredicate(pluginId: pluginText, value: valueText)
        }

        if let rulePredicate = rulePredicate {
            let predicateText = "\(pluginText) \(predicateOperator.string.lowercased()) \(valueText)"
            ruleListVc.rulePredicates.append((rulePredicate, predicateText))
            self.navigationController?.popViewController(animated: true)
        } else {
            alert.message = "The value entered does not match the type specified. Try again."
            self.present(alert, animated: true, completion: nil)
        }
    }

    /*
     Method that retrieves the corresponding NewContextRuleListViewController within the navigation stack
     */
    private func getRuleListViewController() -> CreateContextRuleViewController? {
        if let selfIndex = self.navigationController?.viewControllers.index(of: self), selfIndex > 0 {
            if let listVc = self.navigationController?.viewControllers[selfIndex-1] as? CreateContextRuleViewController {
                return listVc
            }
        }
        return nil
    }
}

extension CreateRulePredicateViewController {
    enum Section: Int {
        case plugin
        case type
        case predicate
        case value

        var title: String {
            switch self {
            case .plugin: return "Context Plugin Attribute"
            case .type: return "Type"
            case .predicate: return "Operator"
            case .value: return "Value"
            }
        }

        var numberOfRows: Int {
            return self == .type ? RulePredicateValueType.count : 1
        }

        static let count = 4
    }
}

// MARK: - Table view

extension CreateRulePredicateViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section < Section.count, let numberOfRows = Section(rawValue: section)?.numberOfRows else { return 0 }
        if section == Section.predicate.rawValue {
            return self.predicateFactory.type.numberOfOperators
        }
        
        return numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = indexPath.section == Section.predicate.rawValue ? RulePredicateCheckCell.reuseID :
                         (indexPath.section == Section.type.rawValue ? RulePredicateTypeCheckCell.reuseID : TextFieldCell.reuseID)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)

        switch indexPath.section {
        case Section.plugin.rawValue:
            if let pluginCell = cell as? TextFieldCell {
                pluginCell.textField.placeholder = "eg: ctx.sdk.battery.percentage"
                self.pluginTextField = pluginCell.textField
            }
        case Section.type.rawValue:
            if let typeCell = cell as? RulePredicateTypeCheckCell, let type = RulePredicateValueType(rawValue: indexPath.row) {
                typeCell.type = type
                typeCell.titleLabel.text = type.title
                if type == self.predicateFactory.type {
                    typeCell.isChecked = true
                    self.selectedTypeCell = typeCell
                } else {
                    typeCell.isChecked = false
                }
            }
        case Section.predicate.rawValue:
            if let predicateCell = cell as? RulePredicateCheckCell, let predicate = RulePredicateOperator(rawValue: indexPath.row) {
                predicateCell.predicate = predicate
                predicateCell.titleLabel.text = predicate.string
                if predicate == .equalTo {
                    //default predicate is equal to
                    predicateCell.isChecked = true
                    self.selectedPredicateCell = predicateCell 
                } else {
                    predicateCell.isChecked = false
                }
            }
        case Section.value.rawValue:
            if let valueCell = cell as? TextFieldCell {
                valueCell.textField.placeholder = "Enter a value"
                self.valueTextField = valueCell.textField
            }
        default:
            break
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == Section.predicate.rawValue || indexPath.section == Section.type.rawValue else { return }

        if let predicateCell = tableView.cellForRow(at: indexPath) as? RulePredicateCheckCell {
            self.selectedPredicateCell = predicateCell
        } else if let typeCell = tableView.cellForRow(at: indexPath) as? RulePredicateTypeCheckCell, let type = typeCell.type {
            // selected same type
            guard self.selectedTypeCell != typeCell && self.predicateFactory.type != type else { return }
            // string and boolean share the same operators, so there is no need to reload
            let shouldReloadSection: Bool = !((self.predicateFactory.type == .boolean ||
                                            self.predicateFactory.type == .string) && (type == .boolean || type == .string))
            self.selectedTypeCell = typeCell
            self.predicateFactory.type = type
            if shouldReloadSection {
                let sectionIndex = IndexSet(integersIn: Section.predicate.rawValue...Section.predicate.rawValue)
                tableView.reloadSections(sectionIndex, with: .automatic)
            }
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Section(rawValue: section)?.title
    }
}
