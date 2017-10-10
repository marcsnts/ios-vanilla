//
//  NewContextRuleListViewController.swift
//  Vanilla
//
//  Created by Marc Santos on 2017-10-05.
//  Copyright © 2017 Alex. All rights reserved.
//

import UIKit
import FlybitsContextSDK

class NewContextRuleListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let defaultCellReuseID = "DefaultCell"
    var nameTextField: UITextField?
    var ruleCells = [RulePredicateCell]()
    var predicateType: PredicateChainOperator = .and
    var rulePredicates = [(predicate: RulePredicate, text: String)]() {
        didSet {
            let rulePredicatesIndex = IndexSet(integersIn: Section.rulePredicates.rawValue...Section.rulePredicates.rawValue)
            tableView.reloadSections(rulePredicatesIndex, with: .automatic)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(createRule))
    }

    @objc func createRule() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        guard self.rulePredicates.count > 0 else { return }
        guard let ruleName = self.nameTextField?.text, !self.nameTextField!.text!.isEmpty else {
            alert.title = "Unable to save rule"
            alert.message = "Rule is missing a name"
            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }

        let rulePredicates = self.rulePredicates.map({$0.predicate})
        var query = RulePredicateQuery(rulePredicate: rulePredicates[0])
        var skippedFirst = false
        for predicate in rulePredicates {
            if !skippedFirst {
                skippedFirst = true
                continue
            }
            query = self.predicateType == .and ? query.and(rulePredicate: predicate) : query.or(rulePredicate: predicate)
        }

        let rule = Rule(name: ruleName, predicateQuery: query)
        _ = RuleRequest.create(rule: rule, completion: { rule, error in
            guard let rule = rule, error != nil else {
                print(error!.localizedDescription)
                alert.title = "Error"
                alert.message = error?.localizedDescription
                self.present(alert, animated: true, completion: nil)
                return
            }
            print("Rule successfully created!")
            alert.title = "Rule created"
            alert.message = "Rule \(rule.name) has been successfully created"
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.navigationController?.popViewController(animated: true)
            }))
        }).execute()
    }
}

extension NewContextRuleListViewController {
    enum Section: Int {
        case name
        case rulePredicates
        case addRule

        var title: String? {
            switch self {
            case .name:
                return "Name"
            case .rulePredicates:
                return "Rule Predicates"
            case .addRule:
                return nil
            }
        }
        static let count = 3
    }
}

extension NewContextRuleListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = indexPath.section == Section.addRule.rawValue ? defaultCellReuseID :
                         (indexPath.section == Section.rulePredicates.rawValue ? RulePredicateCell.reuseID : TextFieldCell.reuseID)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)

        // Add rule
        if indexPath.section == Section.addRule.rawValue {
            cell.textLabel?.text = "Add rule predicate"
            cell.textLabel?.textColor = UINavigationBar.appearance().tintColor
        }

        // Predicate rules
        if let predicateCell = cell as? RulePredicateCell, indexPath.row < self.rulePredicates.count {
            predicateCell.predicateOperator = .and
            predicateCell.rulePredicateTextLabel.text = rulePredicates[indexPath.row].text
            predicateCell.toggleAction = { isOn in
                for cell in self.ruleCells {
                    cell.toggle.setOn(isOn, animated: true)
                    cell.predicateOperator = isOn ? .and : .or
                }
            }
            self.ruleCells.append(predicateCell)
        }

        if let textFieldCell = cell as? TextFieldCell {
            self.nameTextField = textFieldCell.textField
        }

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == Section.rulePredicates.rawValue ? self.rulePredicates.count : 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Section(rawValue: section)?.title
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // last section
        if indexPath.section == Section.addRule.rawValue {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewContextRule")
            self.show(vc, sender: self)
        }
    }

}

class RulePredicateCell: UITableViewCell {
    @IBOutlet weak var toggle: UISwitch!
    @IBOutlet weak var rulePredicateTextLabel: UILabel!
    @IBOutlet weak var andOrLabel: UILabel!
    var toggleAction: ((Bool) -> Void)?
    @IBAction func toggleDidChange(_ sender: Any) {
        predicateOperator = toggle.isOn ? .and : .or
        if let toggleAction = self.toggleAction {
            toggleAction(toggle.isOn)
        }
    }
    var predicateOperator: PredicateChainOperator = .and {
        didSet {
            andOrLabel.text = toggle.isOn ? "AND" : "OR"
        }
    }
    static let reuseID = "RulePredicateCell"
}

enum PredicateChainOperator {
    case and
    case or
}
