//
//  AddEmployeeViewController.swift
//  LANARS
//
//  Created by sashko on 27.02.2021.
//

import RealmSwift
import UIKit

class AddEmployeeViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    let pickerView = UIPickerView()
    let accountantPickerView = UIPickerView()

    @IBOutlet var navigationBar: UINavigationBar!
    @IBOutlet var employeeTypeTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var salaryTextField: UITextField!
    @IBOutlet var salaryLabel: UILabel!
    @IBOutlet var recepcionLabel: UILabel!
    @IBOutlet var recepcionHoursTextField: UITextField!
    @IBOutlet var workplaceNumberLabel: UILabel!
    @IBOutlet var workplaceNumberTextField: UITextField!
    @IBOutlet var lunchTimeLabel: UILabel!
    @IBOutlet var lunchTimeTextLabel: UITextField!
    @IBOutlet var accountantTypeLabel: UILabel!
    @IBOutlet var accountantTypeTextField: UITextField!

    var workerType = ["Manager", "Employee", "Accountant"]
    var accountantType = ["Payroll", "Material"]
    

    let realm = try! Realm()
    lazy var manager: Results<Manager> = { self.realm.objects(Manager.self) }()
    lazy var employee: Results<Employee> = { self.realm.objects(Employee.self) }()
    lazy var accountant: Results<Accountant> = { self.realm.objects(Accountant.self) }()
    var manag: Manager!
    var empl: Employee!
    var account: Accountant!

    override func viewDidLoad() {
        super.viewDidLoad()
        addPickerView()
        employeeTypeTextField.delegate = self
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(back))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(save))
    }

    @objc func save() {
        let alert = UIAlertController(title: "Success!", message: "New worker successfully added.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
            }))
        try! realm.write {
            switch employeeTypeTextField.text {
            case "Manager":
                let newManager = Manager()
                newManager.name = nameTextField.text ?? "Name "
                newManager.salary = Double(salaryTextField.text ?? "") ?? 0.0
                newManager.ReceptionHours = recepcionHoursTextField.text ?? "0-0"
                realm.add(newManager)
                self.present(alert, animated: true)
                print(manager)
            case "Employee":
                let newEmployee = Employee()
                newEmployee.name = nameTextField.text ?? "Name"
                newEmployee.salary = Double(salaryTextField.text ?? "") ?? 0.0
                newEmployee.LunchTime = lunchTimeTextLabel.text ?? "0-0"
                newEmployee.WorkplaceNumber = Int(workplaceNumberTextField.text ?? " ") ?? 0
                realm.add(newEmployee)
                self.present(alert, animated: true)
                print(employee)
            case "Accountant":
                let newAccountant = Accountant()
                newAccountant.name = nameTextField.text ?? "Name"
                newAccountant.salary = Double(salaryTextField.text ?? " ") ?? 0.0
                newAccountant.AccountType = accountantTypeTextField.text ?? "none"
                newAccountant.LunchTime = lunchTimeTextLabel.text ?? "0-0"
                newAccountant.WorkplaceNumber = Int(workplaceNumberTextField.text ?? " ") ?? 0
                realm.add(newAccountant)
                self.present(alert, animated: true)
                print(accountant)
            case "":
                let alert = UIAlertController(title: nil, message: "Please, fulfill the fields.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            case .some:
                return
            case .none:
                return
            }
        }
    }
    
    func fillTextFields() {
        nameTextField.text = manag.name
    }
    func updateManager() {
      let realm = try! Realm()
        
      try! realm.write {
        manag.name = nameTextField.text!
      }
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if manag != nil {
          updateManager()
        }
        return true
    }

    @objc func back() {
        dismiss(animated: true, completion: nil)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.pickerView {
            return workerType.count
        } else {
            return accountantType.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.pickerView {
            return workerType[row]
        } else {
            return accountantType[row]
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.pickerView {
            employeeTypeTextField.text = workerType[row]
        } else {
            accountantTypeTextField.text = accountantType[row]
        }
    }

    @objc func donePicker() {
        let row = pickerView.selectedRow(inComponent: 0)
        pickerView.selectRow(row, inComponent: 0, animated: false)
        employeeTypeTextField.text = workerType[row]
        employeeTypeTextField.resignFirstResponder()
    }

    @objc func doneAccountantPicker() {
        let row = accountantPickerView.selectedRow(inComponent: 0)
        accountantPickerView.selectRow(row, inComponent: 0, animated: false)
        accountantTypeTextField.text = accountantType[row]
        accountantTypeTextField.resignFirstResponder()
    }

    func addPickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
        accountantPickerView.delegate = self
        accountantPickerView.dataSource = self
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(donePicker))
        let doneAccountantButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneAccountantPicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        let accountantToolBar = UIToolbar()
        accountantToolBar.sizeToFit()
        accountantToolBar.setItems([spaceButton, doneAccountantButton], animated: false)
        accountantToolBar.isUserInteractionEnabled = true
        employeeTypeTextField.inputView = pickerView
        employeeTypeTextField.inputAccessoryView = toolBar
        accountantTypeTextField.inputView = accountantPickerView
        accountantTypeTextField.inputAccessoryView = accountantToolBar
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == employeeTypeTextField {
            switch employeeTypeTextField.text {
            case "Manager":
                nameTextField.isHidden = false
                nameLabel.isHidden = false
                salaryTextField.isHidden = false
                salaryLabel.isHidden = false
                recepcionLabel.isHidden = false
                recepcionHoursTextField.isHidden = false
                workplaceNumberLabel.isHidden = true
                workplaceNumberTextField.isHidden = true
                lunchTimeLabel.isHidden = true
                lunchTimeTextLabel.isHidden = true
                accountantTypeLabel.isHidden = true
                accountantTypeTextField.isHidden = true
            case "Employee":
                nameTextField.isHidden = false
                nameLabel.isHidden = false
                salaryTextField.isHidden = false
                salaryLabel.isHidden = false
                recepcionLabel.isHidden = true
                recepcionHoursTextField.isHidden = true
                workplaceNumberLabel.isHidden = false
                workplaceNumberTextField.isHidden = false
                lunchTimeLabel.isHidden = false
                lunchTimeTextLabel.isHidden = false
                accountantTypeLabel.isHidden = true
                accountantTypeTextField.isHidden = true
            case "Accountant":
                nameTextField.isHidden = false
                nameLabel.isHidden = false
                salaryTextField.isHidden = false
                salaryLabel.isHidden = false
                recepcionLabel.isHidden = true
                recepcionHoursTextField.isHidden = true
                workplaceNumberLabel.isHidden = false
                workplaceNumberTextField.isHidden = false
                lunchTimeLabel.isHidden = false
                lunchTimeTextLabel.isHidden = false
                accountantTypeLabel.isHidden = false
                accountantTypeTextField.isHidden = false
            case .none:
                return
            case .some:
                return
            }
        }
    }
}