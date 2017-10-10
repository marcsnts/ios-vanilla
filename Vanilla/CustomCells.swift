//
//  CustomCells.swift
//  Vanilla
//
//  Created by Marc Santos on 2017-10-10.
//  Copyright © 2017 Flybits Inc. All rights reserved.
//

import UIKit
import FlybitsContextSDK
import FlybitsKernelSDK

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

class ContextRuleCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var scopeLabel: UILabel!
    @IBOutlet weak var lastEvaluatedLabel: UILabel!
    var rule: Rule? {
        didSet {
            if let rule = self.rule {
                nameLabel.text = rule.name
                scopeLabel.text = "Scope: \(rule.scope.string)"
                lastEvaluatedLabel.text = "Last evaluated: \(rule.lastResult ?? false)"
            }
        }
    }
    static let reuseID = "ContextRuleCell"
    static let height: CGFloat = 85
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

class ContentCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var contentImageView: UIImageView!
    var contentData: ContentData?
    static let reuseID = "ContentCell"
}

class ImageCell: UITableViewCell {
    static let reuseID = "ImageCell"
    @IBOutlet weak var imgView: UIImageView!
}

class TextFieldCell: UITableViewCell {
    static let reuseID = "TextFieldCell"
    @IBOutlet weak var textField: UITextField!
}

class CheckCell: UITableViewCell {
    class var reuseID: String {
        return "CheckCell"
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkmarkImageView: UIImageView!
    var isChecked: Bool = false {
        didSet {
            checkmarkImageView.isHidden = !isChecked
        }
    }
}

