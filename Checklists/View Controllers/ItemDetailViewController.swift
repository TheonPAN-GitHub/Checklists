//
//  AddItemTableViewController.swift
//  Checklists
//
//  Created by Theon.PAN on 2021/9/13.
//

import UIKit
import UserNotifications

protocol ItemDetailViewControllerDelegate: AnyObject{
    func ItemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
    func ItemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item:ChecklistItem)
    func ItemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item:ChecklistItem)
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate{
    weak var delegate: ItemDetailViewControllerDelegate?
    
    var itemToEdit: ChecklistItem?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        
        if let itemToEdit = itemToEdit {
            title = "Edit Item"
            textField.text = itemToEdit.text
            shouldRemindSwitch.isOn = itemToEdit.shouldRemind
            datePicker.date = itemToEdit.dueDate
            doneBarButton.isEnabled = true
        }else{
            datePicker.date = Date.init(timeInterval: 60 * 60 * 24, since: Date())
        }
    }

    // MARK: - Outlets
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    // MARK: - Actions
    @IBAction func cancel(){
        delegate?.ItemDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done(){
        if let item = itemToEdit {
            item.text = textField.text!
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = datePicker.date
            item.scheduleNotification()
            delegate?.ItemDetailViewController(self, didFinishEditing: item)
        }else{
            let item = ChecklistItem()
            item.text = textField.text!
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = datePicker.date
            item.scheduleNotification()
            delegate?.ItemDetailViewController(self, didFinishAdding: item)
        }
    }
    
    @IBAction func shouldRemindToggled(_ switchControl: UISwitch){
        textField.resignFirstResponder()
        
        if switchControl.isOn {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound]){_, _ in
                
            }
        }
    }

    // MARK: - Table View Delegates
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    // MARK: - Text Field Delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        
        doneBarButton.isEnabled = !newText.isEmpty
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        return true
    }

    

}
