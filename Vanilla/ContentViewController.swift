//
//  ContentViewController.swift
//  Vanilla
//
//  Created by Marc Santos on 2017-09-25.
//  Copyright © Flybits Inc. All rights reserved.
//

import UIKit
import FlybitsKernelSDK
import FlybitsContextSDK
import FlybitsPushSDK
import UserNotifications

class ContentViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    lazy var refreshControl = UIRefreshControl()

    var contents = [Content]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var templateIDs: [String] {
        var ids = [String]()
        for id in contents.flatMap({$0.templateId}) {
            if !ids.contains(id) {
                ids.append(id)
            }
        }
        return ids
    }
    var sectionTemplates: [Int: String] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(logout))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Context", style: .plain, target: self, action: #selector(showContext))
        registerRemoteNotifications()
        setupPullToRefresh()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchRelevantContent()
    }

    func setupPullToRefresh() {
        refreshControl.attributedTitle = NSAttributedString(string: "Retrieving relevant content...")
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(fetchRelevantContent), for: .valueChanged)
    }

    func registerRemoteNotifications() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        } else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))
        }
        UIApplication.shared.registerForRemoteNotifications()
    }

    @objc func fetchRelevantContent() {
        let templateIDsAndClassModelsDictionary: [String: ContentData.Type] = [
            Template.contact.templateId: ContactContentData.self,
            Template.menuItem.templateId: MenuItemContentData.self,
            Template.restaurant.templateId: RestaurauntContentData.self
        ]

        _ = Content.getAllRelevant(with: templateIDsAndClassModelsDictionary, completion: { pagedContent, error in
            defer {
                DispatchQueue.main.async {
                    if self.refreshControl.isRefreshing {
                        self.refreshControl.endRefreshing()
                    }
                }
            }
            guard let pagedContent = pagedContent, error == nil else {
                return
            }

            let contents: [Content] = {
                var contents = [Content]()
                contents.append(contentsOf: pagedContent.elements.filter({$0.templateId == Template.contact.templateId}))
                contents.append(contentsOf: pagedContent.elements.filter({$0.templateId == Template.menuItem.templateId}))
                contents.append(contentsOf: pagedContent.elements.filter({$0.templateId == Template.restaurant.templateId}))
                let customContents = pagedContent.elements.filter({
                    return !($0.templateId == Template.contact.templateId || $0.templateId == Template.menuItem.templateId
                             || $0.templateId == Template.restaurant.templateId)
                })
                contents.append(contentsOf: customContents)

                return contents
            }()
            self.contents = contents
        })
    }

    @objc func showContext() {
        self.show(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Context"), sender: self)
    }
    
    @objc func logout() {
        AppDelegate.logout {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
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
            return defaultTemplate.title
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
                let alert: UIAlertController = {
                    let alert = UIAlertController(title: "Unknown Content Data", message: "Cannot show the content data for this content instance",
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    return alert
                }()
                self.present(alert, animated: true, completion: nil)
                return
        }

        vc.contentData = contentData
        vc.title = cell.titleLabel.text
        self.show(vc, sender: self)
    }
}
