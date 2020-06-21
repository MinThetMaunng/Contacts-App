//
//  ViewController.swift
//  Contacts
//
//  Created by Min Thet Maung on 20/06/2020.
//  Copyright © 2020 Myanmy. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    
    private let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persitentContainer.viewContext
    
    private let imagePicker =  UIImagePickerController()
    
    private var alertController: UIAlertController?
    
    var contacts = [Contact]()
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refresh()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDelegate()
        setupNavBar()
        setupViews()
    }
    
    private func refresh() {
        let request = Contact.fetchRequest() as NSFetchRequest<Contact>
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Contact.name), ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))]
        do {
            contacts = try context.fetch(request)
        } catch let error as NSError {
            fatalError("Error while fetching contacts: \(error.userInfo)")
        }
    }
    
    private func setupDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80 + 32
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        tableView.register(ContactCell.self, forCellReuseIdentifier: ContactCell.reuseIdentifier)
    }
    
    private func setupNavBar() {
        title = "Contacts"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(openNewTaskAlert))
    }
    
    @objc private func openNewTaskAlert() {
        alertController = UIAlertController(title: "New Contact", message: "", preferredStyle: .alert)
        
        ["Full Name", "Phone Number"].forEach { txt in alertController?.addTextField { (textField) in
            textField.placeholder = txt
        }}

        let chooseImageAction = UIAlertAction(title: "Choose photo", style: .default) { (action) in
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        
        [cancelAction, chooseImageAction].forEach { alertController?.addAction($0) }
        present(alertController!, animated: true, completion: nil)
    }
    

    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }

    
}

// MARK: - Table View Delegate Methods
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactCell.reuseIdentifier, for: indexPath) as! ContactCell
        cell.contact = contacts[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(self.contacts[indexPath.row])
            self.contacts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            appDelegate.saveContext()
            self.tableView.reloadData()
        }
    }
    
}


// MARK: - Image Picker Delegate Methods
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let chosenImage = info[.editedImage] as? UIImage {
            let fullNameTextField = self.alertController?.textFields?.first!
            let phoneNumberTextField = self.alertController?.textFields?.last!
            if let fullName = fullNameTextField?.text, let phoneNumber = phoneNumberTextField?.text {
                let contact = Contact(entity: Contact.entity(), insertInto: context)
                contact.name = fullName
                contact.phone = phoneNumber
                contact.photo = chosenImage.jpegData(compressionQuality: 1)
                self.contacts.append(contact)
                appDelegate.saveContext()
            }
            self.tableView.reloadData()
            self.dismiss(animated: true, completion: { print("DISMISS") })
        } else {
            print("hello")
        }
    }
}
