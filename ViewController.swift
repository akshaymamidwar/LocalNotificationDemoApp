//
//  ViewController.swift
//  NotificationDemo
//
//  Created by Akshay Mamidwar on 28/10/23.
//

import UIKit

class ViewController: UIViewController {

    // MARK: UI Elements

    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Notification Title"
        textField.textColor = .black
        textField.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        textField.layer.borderColor = UIColor.red.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5.0
        return textField
    }()

    private lazy var bodyTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Notification Body"
        textField.textColor = .black
        textField.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        textField.layer.borderColor = UIColor.red.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5.0
        return textField
    }()

    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.tintColor = UIColor(red: 148/255, green: 49/255, blue: 38/255, alpha: 1.0)
        return datePicker
    }()

    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 8
        button.setTitle("Add Notification", for: .normal)
        button.backgroundColor = UIColor(red: 51/255, green: 51/255, blue: 102/255, alpha: 1.0)
        return button
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // MARK: Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewHierarchy()
        addButton.addTarget(self, action: #selector(self.addNotificationButtonTapped), for: .touchUpInside)

        // Setup constraints
        let constraints = [
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        view.backgroundColor = UIColor(red: 242/255, green: 230/255, blue: 215/255, alpha: 1.0)
    }

    // MARK: Private Helper Methods

    private func setupViewHierarchy() {
        stackView.addArrangedSubview(titleTextField)
        stackView.addArrangedSubview(bodyTextField)
        stackView.addArrangedSubview(datePicker)
        stackView.addArrangedSubview(addButton)
        view.addSubview(stackView)
    }

    @objc
    private func addNotificationButtonTapped(sender : UIButton) {
        let alertController = UIAlertController(title: "Success", message: "Notification created successfully", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
        scheduleLocalNotification(
            titleText: titleTextField.text ?? "Default Title",
            bodyText: bodyTextField.text ?? "Default Body",
            date: datePicker.date)
        titleTextField.text = nil
        bodyTextField.text = nil
        datePicker.date = Date()
    }

    private func scheduleLocalNotification(titleText: String, bodyText: String, date: Date) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            // Checking the notification setting whether it's authorized or not to send a request.
            if settings.authorizationStatus == UNAuthorizationStatus.authorized {
                // 1. Create contents
                let content = UNMutableNotificationContent()
                content.title = titleText
                content.body = bodyText
                content.sound = UNNotificationSound.default

                // 2. Create trigger [calendar, timeinterval, location, pushnotification]
                let dateInfo = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: false)

                // 3. Make a request
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                let notificationCenter = UNUserNotificationCenter.current()
                notificationCenter.add(request) { (error) in
                    if error != nil {
                        print("Error:\(String(describing: error))")
                    }
                }
           }
           else {
              print("User Denied")
           }
       }
    }
}
