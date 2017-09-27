//
//  ContentViewController.swift
//  Vanilla
//
//  Created by Marc Santos on 2017-09-25.
//  Copyright © 2017 Alex. All rights reserved.
//

import UIKit
import FlybitsKernelSDK

class ContentViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var contents = [Content]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var templateIDs: [String] {
        return Set(contents.flatMap{$0.templateId}).map{$0}
    }
    var sectionTemplates: [Int: String] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchRelevantContent()
    }

    func fetchRelevantContent() {
        let templateIDsAndClassModelsDictionary: [String: ContentData.Type] = [
            Template.contact.id(): ContactModel.self,
            Template.menuItem.id(): MenuItemModel.self,
            Template.restaurant.id(): RestaurantModel.self
        ]

        _ = Content.getAllRelevant(with: templateIDsAndClassModelsDictionary, completion: { pagedContent, error in
            guard let pagedContent = pagedContent, error == nil else {
                return
            }
            self.contents = pagedContent.elements
        })
    }
}

// MARK: - Table view

extension ContentViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return templateIDs.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard section < templateIDs.count else { return nil }

        let templateID = templateIDs[section]
        sectionTemplates[section] = templateID
        if let defaultTemplate = Template(fromId: templateID) {
            return defaultTemplate.title()
        }

        return "Template \(templateID)"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let templateID = sectionTemplates[section] else { return 0 }
        return contents.flatMap({$0.templateId}).filter({$0 == templateID}).count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let templateID = sectionTemplates[indexPath.section]
        let sectionContents = self.contents.filter({$0.templateId == templateID})
        let cell = tableView.dequeueReusableCell(withIdentifier: ContentCell.reuseID, for: indexPath) as! ContentCell
        if indexPath.row < sectionContents.count {
            let content = sectionContents[indexPath.row]
            cell.contentData = content.pagedContentData?.elements.first
            cell.titleLabel.text = content.name?.value ?? "Unnamed content"
            cell.subtitleLabel.text = content.contentDescription?.value ?? "No description"
            if let contentIconUrl = content.iconUrl, let url = URL(string: contentIconUrl), let imageData = try? Data(contentsOf: url) {
                cell.contentImageView.image = UIImage(data: imageData)
            }
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ContentCell, let contentData = cell.contentData,
              let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ContentData") as? ContentDataViewController else {
            return
        }

        vc.contentData = contentData
        vc.title = cell.titleLabel.text
        self.show(vc, sender: self)
    }
}

// MARK: - Content table view cell

class ContentCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var contentImageView: UIImageView!
    var contentData: ContentData?
    static let reuseID = "ContentCell"
}

