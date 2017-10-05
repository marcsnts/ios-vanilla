//
//  NewContextRuleViewController.swift
//  Vanilla
//
//  Created by Marc Santos on 2017-10-05.
//  Copyright © 2017 Alex. All rights reserved.
//

import UIKit

class NewContextRuleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

// MARK: - Table view

extension NewContextRuleViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }

}
