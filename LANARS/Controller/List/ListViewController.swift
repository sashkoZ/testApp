//
//  ListViewController.swift
//  LANARS
//
//  Created by sashko on 27.02.2021.
//

import RealmSwift
import UIKit

class ListViewController: UIViewController {
    @IBOutlet var navigationBar: UINavigationBar!
    @IBOutlet var addBarButton: UIBarButtonItem!
    @IBOutlet var editBarButton: UIBarButtonItem!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchView: UIView!
    @IBOutlet var searchViewHeight: NSLayoutConstraint!
    @IBOutlet var tableViewTopDistanceHeight: NSLayoutConstraint!

    var workersArray = ["Manager", "Employee", "Accountant"]
    var isEdditing = false
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }

    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }

    let realm = try! Realm()
    lazy var managers: Results<Manager> = { self.realm.objects(Manager.self).sorted(byKeyPath: "name", ascending: true) }()
    lazy var employees: Results<Employee> = { self.realm.objects(Employee.self).sorted(byKeyPath: "name", ascending: true) }()
    lazy var accountants: Results<Accountant> = { self.realm.objects(Accountant.self).sorted(byKeyPath: "name", ascending: true) }()
    var sortedManagers = try! Realm().objects(Manager.self)
    var sortedEmployee = try! Realm().objects(Employee.self)
    var sortedAccountant = try! Realm().objects(Accountant.self)
    var searchController: UISearchController!

    let NibManagerCell = UINib(nibName: "ManagerTableViewCell", bundle: nil)
    let NibEmployeeCell = UINib(nibName: "EmployeeTableViewCell", bundle: nil)
    let NibAccountantCell = UINib(nibName: "AccountantTableViewCell", bundle: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NibManagerCell, forCellReuseIdentifier: "managerCell")
        tableView.register(NibEmployeeCell, forCellReuseIdentifier: "employeeCell")
        tableView.register(NibAccountantCell, forCellReuseIdentifier: "accountantCell")

        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.tintColor = .white
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
        searchView.addSubview(searchController.searchBar)
        searchController.searchBar.sizeToFit()
    }

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        isEdditing = false
        searchViewHeight.constant = 0
        tableViewTopDistanceHeight.constant = 0
    }

    @IBAction func addEmployee(_ sender: Any) {
    }

    //

    // MARK: - Search

    //

    func filterResultsWithSearchString(searchString: String) {
        let predicate = NSPredicate(format: "name BEGINSWITH [c]%@", searchString)
        let realm = try! Realm()

        sortedManagers = realm.objects(Manager.self).filter(predicate)
        sortedEmployee = realm.objects(Employee.self).filter(predicate)
        sortedAccountant = realm.objects(Accountant.self).filter(predicate)
        tableView.reloadData()
    }

    //

    // MARK: - Entities E/D

    //
    @IBAction func editEmployees(_ sender: Any) {
        if isEdditing {
            isEdditing = false
            searchViewHeight.constant = 0
            tableViewTopDistanceHeight.constant = 0
        } else {
            isEdditing = true
            searchViewHeight.constant = 60
            tableViewTopDistanceHeight.constant = 60
        }
        tableView.reloadData()
    }

    func deleteUser(item: Object) {
        try! realm.write {
            realm.delete(item)
            self.tableView.reloadData()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editSegue" {
            let nav = segue.destination as! UINavigationController
            let svc = nav.topViewController as! AddEmployeeViewController
            var selectedManager: Manager!
            var selectedEmployee: Employee?
            var selectedAccountant: Accountant?
            let indexPath = tableView.indexPathForSelectedRow

            if searchController.isActive {
                //let searchResultsController = searchController.searchResultsController as! ListViewController
                //let indexPathSearch = searchResultsController.tableView.indexPathForSelectedRow
                switch indexPath?.section {
                case 0:
                    selectedManager = sortedManagers[indexPath!.row]
                case 1:
                    selectedEmployee = sortedEmployee[indexPath!.row]
                case 2:
                    selectedAccountant = sortedAccountant[indexPath!.row]
                case .none:
                    return
                case .some:
                    return
                }
            } else {
                switch indexPath?.section {
                case 0:
                    selectedManager = managers[indexPath!.row]
                case 1:
                    selectedEmployee = employees[indexPath!.row]
                case 2:
                    selectedAccountant = accountants[indexPath!.row]
                case .none:
                    return
                case .some:
                    return
                }
            }

            svc.manag = selectedManager
            svc.account = selectedAccountant
            svc.empl = selectedEmployee
        }
    }
}
//

// MARK: - TableView setup

//

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if isFiltering {
                return sortedManagers.count
            } else {
                return managers.count
            }
        } else if section == 1 {
            if isFiltering {
                return sortedEmployee.count
            } else {
                return employees.count
            }
        } else {
            if isFiltering {
                return sortedAccountant.count
            } else {
                return accountants.count
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let managerCell = self.tableView.dequeueReusableCell(withIdentifier: "managerCell") as! ManagerTableViewCell
            var manager: Manager?
            if isFiltering {
                manager = sortedManagers[indexPath.row]
            } else {
                manager = managers[indexPath.row]
            }
            managerCell.nameLabel.text = manager?.name
            managerCell.salaryLabel.text = String(manager?.salary ?? 0.0) + "$"
            managerCell.receptionTimeLabel.text = manager?.ReceptionHours
            managerCell.object = managers[indexPath.row]
            managerCell.delegate = self
            isEdditing ? (managerCell.deleteButton.isHidden = false) : (managerCell.deleteButton.isHidden = true)
            return managerCell
        case 1:
            let employeeCell = self.tableView.dequeueReusableCell(withIdentifier: "employeeCell") as! EmployeeTableViewCell
            var employee: Employee?
            if isFiltering {
                employee = sortedEmployee[indexPath.row]
            } else {
                employee = employees[indexPath.row]
            }
            employeeCell.nameLabel.text = employee?.name
            employeeCell.salaryLabel.text = String(employee?.salary ?? 0.0) + "$"
            employeeCell.workplaceNumberLabel.text = String(employee?.WorkplaceNumber ?? 0)
            employeeCell.lunchTimeLabel.text = employee?.LunchTime
            employeeCell.object = employees[indexPath.row]
            employeeCell.delegate = self
            isEdditing ? (employeeCell.deleteButton.isHidden = false) : (employeeCell.deleteButton.isHidden = true)
            return employeeCell
        case 2:
            var accountant: Accountant?
            if isFiltering {
                accountant = sortedAccountant[indexPath.row]
            } else {
                accountant? = accountants[indexPath.row]
            }
            let accountantCell = self.tableView.dequeueReusableCell(withIdentifier: "accountantCell") as! AccountantTableViewCell
            accountantCell.nameLabel.text = accountant?.name
            accountantCell.salaryLabel.text = String(accountant?.salary ?? 0.0) + "$"
            accountantCell.workplaceNumberLabel.text = String(accountant?.WorkplaceNumber ?? 0)
            accountantCell.lunchTimeLabel.text = accountant?.LunchTime
            accountantCell.accountantTypeLabel.text = accountant?.AccountType
            accountantCell.object = accountants[indexPath.row]
            accountantCell.delegate = self
            isEdditing ? (accountantCell.deleteAccountant.isHidden = false) : (accountantCell.deleteAccountant.isHidden = true)
            return accountantCell
        default:
            let cell = UITableViewCell()
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 130
        case 1:
            return 160
        case 2:
            return 200
        default:
            return 50
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 33
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UITableViewHeaderFooterView()
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: tableView.frame.width, height: 33))
        header.addSubview(label)
        label.text = ""
        switch section {
        case 0:
            label.text = "Managers:"
            label.font = UIFont.boldSystemFont(ofSize: 18.0)
            return header
        case 1:
            label.text = "Employees:"
            label.font = UIFont.boldSystemFont(ofSize: 18.0)
            return header
        case 2:
            label.text = "Accountants:"
            label.font = UIFont.boldSystemFont(ofSize: 18.0)
            return header
        default:
            return header
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "editSegue", sender: self)
    }
}

extension ListViewController: EmployeeDelegate, ManagerDelegate, AccountantDelegate {
    func deleteManager(item: Object) {
        deleteUser(item: item)
    }

    func deleteAccountant(item: Object) {
        deleteUser(item: item)
    }

    func deleteEmployee(item: Object) {
        deleteUser(item: item)
    }
}

extension ListViewController: UISearchBarDelegate {
}

extension ListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text!
        filterResultsWithSearchString(searchString: searchString)

        // tableView.reloadData()
    }
}
