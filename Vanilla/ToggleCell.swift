//
//  ToggleCell.swift
//  Vanilla
//
//  Created by Marc Santos on 2017-10-02.
//  Copyright © 2017 Flybits Inc. All rights reserved.
//

import UIKit

class ToggleCell: UITableViewCell {
    static let reuseID = "ToggleCell"
    var action: ((Bool) -> Void)?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var toggle: UISwitch!
    @IBAction func toggleDidChange(_ sender: Any) {
        guard let action = self.action else { return }
        action(toggle.isOn)
    }
}
