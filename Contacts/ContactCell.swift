//
//  ContactCell.swift
//  Contacts
//
//  Created by Min Thet Maung on 20/06/2020.
//  Copyright © 2020 Myanmy. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {
    
    var contact: Contact? {
        didSet {
            if let fullName = contact?.name {
                nameLabel.text = fullName
            }
            if let phone = contact?.phone {
                phoneLabel.text = phone
            }
            if let imageData = contact?.photo {
                photo.image = UIImage(data: imageData)
            }
        }
    }
    
    private let photo: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.layer.cornerRadius = 40
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = ""
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.textColor = .darkGray
        lbl.backgroundColor = .clear
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        return lbl
    }()
    
    private let phoneLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = ""
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.textColor = .darkGray
        lbl.backgroundColor = .clear
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        return lbl
    }()
    
    static let reuseIdentifier = String(describing: ContactCell.self)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    private func setupViews() {
        backgroundColor = .white
        
        [photo, nameLabel, phoneLabel].forEach { addSubview($0) }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0(80)]-16-[v1]-16-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : photo, "v1": nameLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0(80)]-16-[v1]-16-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : photo, "v1": phoneLabel]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-16-[v0(80)]-16-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : photo]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-16-[v0(45)][v1(30)]-21-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : nameLabel, "v1": phoneLabel]))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
