//
//  NewContextRuleViewController.swift
//  Vanilla
//
//  Created by Marc Santos on 2017-10-05.
//  Copyright © 2017 Alex. All rights reserved.
//

import UIKit
import FlybitsContextSDK

class NewContextRuleViewController: UIViewController {
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
    var selectedType: PredicateValueType = .integer
    var valueTextField: UITextField?
    var pluginTextField: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addRulePredicateToListView))
    }

    @objc func addRulePredicateToListView() {
        guard let predicateOperator = self.selectedPredicateCell?.predicate, let valueText = self.valueTextField?.text, !valueText.isEmpty, let pluginText = self.pluginTextField?.text, !pluginText.isEmpty, let ruleListVc = getRuleListViewController() else {
            let alert = UIAlertController(title: "Something went wrong", message: "The rule predicate could not be added", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }

        var rulePredicate: RulePredicate?
        switch self.selectedType {
        case .boolean:
            rulePredicate = predicateOperator.makeRulePredicate(plugin: pluginText, value: NSString(string: valueText).boolValue)
        case .integer:
            if let intValue = Int(valueText) {
                rulePredicate = predicateOperator.makeRulePredicate(plugin: pluginText, value: intValue)
            }
        case .string:
            rulePredicate = predicateOperator.makeRulePredicate(plugin: pluginText, value: valueText)
        }

        if let rulePredicate = rulePredicate {
            let predicateText = "\(pluginText) \(predicateOperator.string.lowercased()) \(valueText)"
            ruleListVc.rulePredicates.append((rulePredicate, predicateText))
            self.navigationController?.popViewController(animated: true)
        }
    }

    private func getRuleListViewController() -> NewContextRuleListViewController? {
        if let selfIndex = self.navigationController?.viewControllers.index(of: self), selfIndex > 0 {
            if let listVc = self.navigationController?.viewControllers[selfIndex-1] as? NewContextRuleListViewController {
                return listVc
            }
        }
        return nil
    }
}

extension NewContextRuleViewController {
    enum Section: Int {
        case plugin
        case type
        case predicate
        case value

        var title: String {
            switch self {
            case .plugin:
                return "Context Plugin Attribute"
            case .type:
                return "Type"
            case .predicate:
                return "Operator"
            case .value:
                return "Value"
            }
        }

        var numberOfRows: Int {
            return self == .type ? PredicateValueType.count : 1
        }

        static let count = 4
    }

    enum PredicateValueType: Int {
        case integer
        case string
        case boolean

        var numberOfOperators: Int {
            switch self {
            case .integer:
                return 6
            case .string:
                return 2
            case .boolean:
                return 2
            }
        }

        var title: String {
            switch self {
            case .integer:
                return "Integer"
            case .string:
                return "String"
            case .boolean:
                return "Boolean"
            }
        }

        static let count = 3
    }

    enum PredicateOperator: Int {
        case equalTo
        case notEqualTo
        case lessThan
        case lessThanOrEqualTo
        case greaterThan
        case greaterThanOrEqualTo

        var string: String {
            switch self {
            case .notEqualTo:
                return "Not equal to"
            case .lessThan:
                return "Less than"
            case .lessThanOrEqualTo:
                return "Less than or equal to"
            case .equalTo:
                return "Equal to"
            case .greaterThan:
                return "Greater than"
            case .greaterThanOrEqualTo:
                return "Greater than or equal to"
            }
        }

        func makeRulePredicate(plugin: String, value: String) -> RulePredicate? {
            switch self {
            case .notEqualTo:
                return RulePredicate.notEquals(plugin: plugin, value: value)
            case .equalTo:
                return RulePredicate.equals(plugin: plugin, value: value)
            default:
                return nil
            }
        }

        func makeRulePredicate(plugin: String, value: Bool) -> RulePredicate? {
            switch self {
            case .notEqualTo:
                return RulePredicate.notEquals(plugin: plugin, value: value)
            case .equalTo:
                return RulePredicate.equals(plugin: plugin, value: value)
            default:
                return nil
            }
        }

        func makeRulePredicate(plugin: String, value: Int) -> RulePredicate? {
            switch self {
            case .notEqualTo:
                return RulePredicate.notEquals(plugin: plugin, value: value)
            case .lessThan:
                return RulePredicate.lessThan(plugin: plugin, value: value)
            case .lessThanOrEqualTo:
                return RulePredicate.lessThanOrEqual(plugin: plugin, value: value)
            case .equalTo:
                return RulePredicate.equals(plugin: plugin, value: value)
            case .greaterThan:
                return RulePredicate.greaterThan(plugin: plugin, value: value)
            case .greaterThanOrEqualTo:
                return RulePredicate.greaterThanOrEqual(plugin: plugin, value: value)
            }
        }
    }
}

// MARK: - Table view

extension NewContextRuleViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section < Section.count, let numberOfRows = Section(rawValue: section)?.numberOfRows else { return 0 }
        if section == Section.predicate.rawValue {
            return self.selectedType.numberOfOperators
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
            if let typeCell = cell as? RulePredicateTypeCheckCell, let type = PredicateValueType(rawValue: indexPath.row) {
                typeCell.type = type
                typeCell.titleLabel.text = type.title
                if type == self.selectedType {
                    typeCell.isChecked = true
                    self.selectedTypeCell = typeCell
                } else {
                    typeCell.isChecked = false
                }
            }
        case Section.predicate.rawValue:
            if let predicateCell = cell as? RulePredicateCheckCell, let predicate = PredicateOperator(rawValue: indexPath.row) {
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
            guard self.selectedTypeCell != typeCell && self.selectedType != type else { return }
            // string and boolean share the same operators, so there is no need to reload
            let shouldReloadSection: Bool = !((self.selectedType == .boolean || self.selectedType == .string) && (type == .boolean || type == .string))
            self.selectedTypeCell = typeCell
            self.selectedType = type
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

class RulePredicateCheckCell: CheckCell {
    var predicate: NewContextRuleViewController.PredicateOperator?
    override class var reuseID: String {
        return "RulePredicateCheckCell"
    }
}

class RulePredicateTypeCheckCell: CheckCell {
    var type: NewContextRuleViewController.PredicateValueType?
    override class var reuseID: String {
        return "RulePredicateTypeCheckCell"
    }
}
