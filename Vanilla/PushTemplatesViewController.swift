//
//  PushTemplatesViewController.swift
//  Vanilla
//
//  Created by Marc Santos on 2017-10-12.
//  Copyright © 2017 Alex. All rights reserved.
//

import UIKit
import FlybitsPushSDK

class PushTemplatesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var pushTemplates = [PushTemplate]() {
        didSet {
            guard self.tableView != nil else { return }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    let defaultCellId = "DefaultCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationButtons()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationButtons()
        fetchPushTemplates()
    }

    func setupNavigationButtons() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New", style: .plain, target: self, action: #selector(goToCreatePushTemplate))
    }

    func fetchPushTemplates() {
        _ = PushTemplateRequest.query(PushQuery(limit: 100, offset: 0)) { templates, pager, error in
            print(templates)
            self.pushTemplates = templates
        }.execute()
    }

    @objc func goToCreatePushTemplate() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreatePushTemplate")
        DispatchQueue.main.async {
            self.show(vc, sender: self)
        }
    }

}

// MARK: - Table view

extension PushTemplatesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pushTemplates.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < self.pushTemplates.count else { return UITableViewCell() }

        let cell = tableView.dequeueReusableCell(withIdentifier: self.defaultCellId, for: indexPath)
        let pushTemplate = self.pushTemplates[indexPath.row]
        cell.textLabel?.text = pushTemplate.name
        cell.detailTextLabel?.text = "Title: \(pushTemplate.title)\nMessage: \(pushTemplate.message)"

        return cell
    }
}
