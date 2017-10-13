//
//  CreateContextRuleViewController.swift
//  Vanilla
//
//  Created by Marc Santos on 2017-10-05.
//  Copyright © 2017 Alex. All rights reserved.
//

import UIKit
import FlybitsContextSDK

class CreateContextRuleViewController: UIViewController {
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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create a rule", style: .plain, target: self, action: #selector(goToCreateRule))
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

extension CreateContextRuleViewController: UITableViewDelegate, UITableViewDataSource {
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
        guard let _ = tableView.cellForRow(at: indexPath) as? ContextRuleCell else { return }
    }
}
