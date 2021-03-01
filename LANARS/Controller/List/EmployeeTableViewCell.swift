//
//  EmployeeTableViewCell.swift
//  LANARS
//
//  Created by sashko on 28.02.2021.
//

import UIKit
import RealmSwift

protocol EmployeeDelegate {
    func deleteEmployee(item: Object)
}

class EmployeeTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var salaryLabel: UILabel!
    @IBOutlet weak var workplaceNumberLabel: UILabel!
    @IBOutlet weak var lunchTimeLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    var delegate: EmployeeDelegate?
    var object = Object()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    @IBAction func deleteEmployee(_ sender: Any) {
        delegate?.deleteEmployee(item: self.object)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "employeeCell")!
        return cell
    }
    
}
