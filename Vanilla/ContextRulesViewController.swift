//
//  ContextRulesViewController.swift
//  Vanilla
//
//  Created by Marc Santos on 2017-10-05.
//  Copyright © 2017 Alex. All rights reserved.
//

import UIKit
import FlybitsContextSDK

class ContextRulesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var rules = [Rule]() {
        didSet {
            if tableView != nil {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchContextRules()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchContextRules()
    }

    func fetchContextRules() {
        _ = RuleRequest.query(RulesQuery(limit: 100, offset: 0), completion: { rules, pager, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            self.rules = rules
        }).execute()
    }
}

extension ContextRulesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rules.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Context Rules"
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ContextRuleCell.height
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < self.rules.count else { return UITableViewCell() }

        let cell = tableView.dequeueReusableCell(withIdentifier: ContextRuleCell.reuseID, for: indexPath) as! ContextRuleCell
        cell.rule = self.rules[indexPath.row]

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return
    }
}

class ContextRuleCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var scopeLabel: UILabel!
    @IBOutlet weak var lastEvaluatedLabel: UILabel!
    var rule: Rule? {
        didSet {
            if let rule = self.rule {
                nameLabel.text = rule.name
                scopeLabel.text = "\(rule.scope.string) scope"
                lastEvaluatedLabel.text = "Last evaluated as \(rule.lastResult ?? false)"
            }
        }
    }
    static let reuseID = "ContextRuleCell"
    static let height: CGFloat = 70
}
