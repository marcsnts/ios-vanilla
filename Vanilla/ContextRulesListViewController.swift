//
//  CreateContextRuleViewController.swift
//  Vanilla
//
//  Created by Marc Santos on 2017-10-05.
//  Copyright © 2017 Flybits Inc. All rights reserved.
//

import UIKit
import FlybitsContextSDK

class ContextRulesListViewController: UIViewController {
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
    var pushTemplateDelegate: CreatePushTemplateDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        if pushTemplateDelegate == nil {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create a rule", style: .plain, target: self, action: #selector(goToCreateRule))
        }
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

    @objc func goToCreateRule() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewContextRuleList")
        self.show(vc, sender: self)
    }
}

// MARK: - Table view

extension ContextRulesListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rules.count
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
        guard let ruleCell = tableView.cellForRow(at: indexPath) as? ContextRuleCell else { return }

        if let pushTemplateDelegate = self.pushTemplateDelegate, let rule = ruleCell.rule {
            pushTemplateDelegate.passRule(rule)
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
