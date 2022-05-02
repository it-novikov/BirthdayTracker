//
//  ViewController.swift
//  BirthdayTracker
//
//  Created by Vadim Novikov on 01.05.2022.
//

import UIKit
import CoreData
import UserNotifications

class TableViewController: UIViewController {
    
    let cellIdentifier = "cell"
    var birthdays = [Birthday]()
    let dateFormatter = DateFormatter()
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = Birthday.fetchRequest() as NSFetchRequest<Birthday>
        // sort
        let lastNameDescriptor = NSSortDescriptor(key: "lastName", ascending: true)
        let firstNameDescriptor = NSSortDescriptor(key: "firstName", ascending: true)
        fetchRequest.sortDescriptors = [lastNameDescriptor, firstNameDescriptor]
        do {
            birthdays = try context.fetch(fetchRequest)
        } catch let error {
            let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(alert, animated: true)
        }
        tableView.reloadData()
    }
}

// MARK: - TableViewDelegate

extension TableViewController: UITableViewDelegate {

}

// MARK: - TableViewDataSource

extension TableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return birthdays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        var content = cell.defaultContentConfiguration()
        let birthday = birthdays[indexPath.row]
        content.text = (birthday.firstName ?? "") + " " + (birthday.lastName ?? "")
        content.secondaryText = dateFormatter.string(from: (birthday.birthdate ?? Date(timeIntervalSince1970: 0)))
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if birthdays.count > indexPath.row {
            let birthday = birthdays[indexPath.row]
            if let identifier = birthday.birthdayId {
                let center = UNUserNotificationCenter.current()
                center.removePendingNotificationRequests(withIdentifiers: [identifier])
            }
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            context.delete(birthday)
            birthdays.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            do {
                try context.save()
            } catch let error {
                let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                self.present(alert, animated: true)
            }
        }
    }
}
