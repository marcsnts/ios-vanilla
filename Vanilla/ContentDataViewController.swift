//
//  ContentDataViewController.swift
//  Vanilla
//
//  Created by Marc Santos on 2017-09-27.
//  Copyright © 2017 Alex. All rights reserved.
//

import UIKit
import FlybitsKernelSDK

class ContentDataViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let labelCellReuseID = "DefaultCell"
    var contentData: ContentData? {
        didSet {
            if tableView != nil {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    var contentDataModel: ContentDataModel? {
        switch contentData {
        case is ContactModel:
            return ContentDataModel.contact
        case is MenuItemModel:
            return ContentDataModel.menuItem
        case is RestaurantModel:
            return ContentDataModel.restaurant
        default:
            return nil
        }
    }
}

// MARK: - Enumerations

extension ContentDataViewController {
    enum ContentDataModel {
        case contact
        case menuItem
        case restaurant

        func sectionTitles() -> [String] {
            switch self {
            case .contact:
                return ["Profile picture", "First name", "Last name", "Date of birth", "Company", "Email", "Phone number"]
            case .menuItem:
                return ["Name", "Price", "Calories", "Ingredients", "Image"]
            case .restaurant:
                return ["Name", "Date of opening", "Number of employees", "Country", "Province", "City", "Address", "Postal code"]
            }
        }
    }
}

// MARK: - Table view

extension ContentDataViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return contentDataModel?.sectionTitles().count ?? 0
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return contentDataModel?.sectionTitles()[section]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let contentType = self.contentDataModel, indexPath.section < contentType.sectionTitles().count,
              let contentData = self.contentData else {
                return UITableViewCell()
        }

        return cellFor(modelType: contentType, data: contentData, section: indexPath.section)
    }

    private func cellFor(modelType: ContentDataModel, data: ContentData, section: Int) -> UITableViewCell {
        let imageCellFrom: (URL) -> UITableViewCell? = { imageUrl in
            guard let data = try? Data(contentsOf: imageUrl) else { return nil }

            let cell = self.tableView.dequeueReusableCell(withIdentifier: ImageCell.reuseID) as! ImageCell
            cell.imgView.image = UIImage(data: data)
            return cell
        }

        var labelText: String?
        switch modelType {
        case .contact:
            if let contactModel = data as? ContactModel {
                switch section {
                case 0:
                    if let profilePictureUrl = contactModel.profilePicture, let imageCell = imageCellFrom(profilePictureUrl) {
                        return imageCell
                    }
                case 1:
                    labelText = contactModel.firstName
                case 2:
                    labelText = contactModel.lastName
                case 3:
                    labelText = contactModel.dob?.toString()
                case 4:
                    labelText = contactModel.company
                case 5:
                    labelText = contactModel.email
                case 6:
                    labelText = "\(contactModel.phoneNumber)"
                default:
                    break
                }
            }
        case .menuItem:
            if let menuItemModel = data as? MenuItemModel {
                switch section {
                case 0:
                    labelText = menuItemModel.name.value
                case 1:
                    labelText = "\(menuItemModel.price)"
                case 2:
                    labelText = "\(menuItemModel.calories)"
                case 3:
                    labelText = menuItemModel.ingredients?.joined(separator: ", ")
                case 4:
                    if let imageUrl = menuItemModel.image, let imageCell = imageCellFrom(imageUrl) {
                        return imageCell
                    }
                default:
                    break
                }
            }
        case .restaurant:
            if let restaurauntModel = data as? RestaurantModel {
                switch section {
                case 0:
                    labelText = restaurauntModel.name
                case 1:
                    labelText = restaurauntModel.openingDate.toString()
                case 2:
                    labelText = "\(restaurauntModel.numEmployees)"
                case 3:
                    labelText = restaurauntModel.location.country
                case 4:
                    labelText = restaurauntModel.location.province
                case 5:
                    labelText = restaurauntModel.location.city
                case 6:
                    labelText = restaurauntModel.location.address
                case 7:
                    labelText = restaurauntModel.location.postalCode
                default:
                    break
                }
            }
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: labelCellReuseID)!
        cell.textLabel?.text = labelText

        return cell
    }
}

// MARK: - Content data table view cell

class ImageCell: UITableViewCell {
    static let reuseID = "ImageCell"
    @IBOutlet weak var imgView: UIImageView!
}
