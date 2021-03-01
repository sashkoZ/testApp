//
//  ListViewController.swift
//  LANARS
//
//  Created by sashko on 27.02.2021.
//

import RealmSwift
import UIKit

class ListViewController: UIViewController, UISearchResultsUpdating {
    @IBOutlet var navigationBar: UINavigationBar!
    @IBOutlet var addBarButton: UIBarButtonItem!
    @IBOutlet var editBarButton: UIBarButtonItem!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchView: UIView!
    @IBOutlet var searchViewHeight: NSLayoutConstraint!
    @IBOutlet var tableViewTopDistanceHeight: NSLayoutConstraint!

    var workersArray = ["Manager", "Employee", "Accountant"]
    var isEdditing = false

    let realm = try! Realm()
    lazy var managers: Results<Manager> = { self.realm.objects(Manager.self).sorted(byKeyPath: "name", ascending: true) }()
    lazy var employees: Results<Employee> = { self.realm.objects(Employee.self).sorted(byKeyPath: "name", ascending: true) }()
    lazy var accountants: Results<Accountant> = { self.realm.objects(Accountant.self).sorted(byKeyPath: "name", ascending: true) }()

    var searchResults = try! Realm().objects(Manager.self)
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

        searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.tintColor = .white
        searchController.searchBar.delegate = self
        searchView.addSubview(searchController.searchBar)
    }

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    @IBAction func addEmployee(_ sender: Any) {
    }

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
    
    //
    // MARK: - Search
    //

    func filterResultsWithSearchString(searchString: String) {
        let predicate = NSPredicate(format: "name BEGINSWITH [c]%@", searchString)
        if searchString != "" {
        let realm = try! Realm()
        searchResults = realm.objects(Manager.self).filter(predicate)
        }
    }

    func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text!
        filterResultsWithSearchString(searchString: searchString)

        self.tableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nav = segue.destination as! UINavigationController
        let svc = nav.topViewController as! AddEmployeeViewController
        
            var selectedManager: Manager!
            let indexPath = tableView.indexPathForSelectedRow
              
            if searchController.isActive {
              let searchResultsController =
                searchController.searchResultsController as! UITableViewController
              let indexPathSearch = searchResultsController.tableView.indexPathForSelectedRow
                
              selectedManager = searchResults[indexPathSearch!.row]
            } else {
             // selectedManager = managers[indexPath!.row]
            }
              
            svc.manag = selectedManager
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return managers.count
        } else if section == 1 {
            return employees.count
        } else {
            return accountants.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let managerCell = self.tableView.dequeueReusableCell(withIdentifier: "managerCell") as! ManagerTableViewCell
            let manager = searchController.isActive ? searchResults[indexPath.row] : managers[indexPath.row]
            managerCell.nameLabel.text = managers[indexPath.row].name
            managerCell.salaryLabel.text = String(managers[indexPath.row].salary) + "$"
            managerCell.receptionTimeLabel.text = managers[indexPath.row].ReceptionHours
            managerCell.object = managers[indexPath.row]
            managerCell.delegate = self
            isEdditing ? (managerCell.deleteButton.isHidden = false) : (managerCell.deleteButton.isHidden = true)
            return managerCell
        case 1:
            let employeeCell = self.tableView.dequeueReusableCell(withIdentifier: "employeeCell") as! EmployeeTableViewCell
            employeeCell.nameLabel.text = employees[indexPath.row].name
            employeeCell.salaryLabel.text = String(employees[indexPath.row].salary) + "$"
            employeeCell.workplaceNumberLabel.text = String(employees[indexPath.row].WorkplaceNumber)
            employeeCell.lunchTimeLabel.text = employees[indexPath.row].LunchTime
            employeeCell.object = employees[indexPath.row]
            employeeCell.delegate = self
            isEdditing ? (employeeCell.deleteButton.isHidden = false) : (employeeCell.deleteButton.isHidden = true)
            return employeeCell
        case 2:
            let accountantCell = self.tableView.dequeueReusableCell(withIdentifier: "accountantCell") as! AccountantTableViewCell
            accountantCell.nameLabel.text = accountants[indexPath.row].name
            accountantCell.salaryLabel.text = String(accountants[indexPath.row].salary) + "$"
            accountantCell.workplaceNumberLabel.text = String(accountants[indexPath.row].WorkplaceNumber)
            accountantCell.lunchTimeLabel.text = accountants[indexPath.row].LunchTime
            accountantCell.accountantTypeLabel.text = accountants[indexPath.row].AccountType
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
