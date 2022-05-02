//
//  AddBirthdayViewController.swift
//  BirthdayTracker
//
//  Created by Vadim Novikov on 01.05.2022.
//

import UIKit
import CoreData
import UserNotifications

class AddBirthdayViewController: UIViewController {
    
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var birthdatePicker: UIDatePicker!
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        if firstNameTextField.text == "" || firstNameTextField.text == nil || lastNameTextField.text == "" || lastNameTextField.text == nil {
            let alert = UIAlertController(title: "Error", message: "First name or Last name lines are empty", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(alert, animated: true)
        } else {
            let birthdate = birthdatePicker.date
            let firstName = firstNameTextField.text
            let lastName = lastNameTextField.text
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let newBirthday = Birthday(context: context)
            newBirthday.firstName = firstNameTextField.text
            newBirthday.lastName = lastNameTextField.text
            newBirthday.birthdate = birthdate
            newBirthday.birthdayId = UUID().uuidString
            do {
                try context.save()
                let message = "У \(firstName ?? "вашего") \(lastName ?? "друга") сегодня день рождения. Не забудь поздравить!"
                let content = UNMutableNotificationContent()
                content.body = message
                content.sound = UNNotificationSound.default
                var dateComponents = Calendar.current.dateComponents([.month, .day], from: birthdate)
                dateComponents.hour = 8
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                if let identifier = newBirthday.birthdayId {
                    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                    let center = UNUserNotificationCenter.current()
                    center.add(request, withCompletionHandler: nil)
                }
            } catch let error {
                let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                self.present(alert, animated: true)
            }
            dismiss(animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        birthdatePicker.maximumDate = Date()
    }
    
}
