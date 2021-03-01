//
//  ManagerTableViewCell.swift
//  LANARS
//
//  Created by sashko on 28.02.2021.
//

import UIKit
import RealmSwift

protocol ManagerDelegate {
    func deleteManager(item: Object)
}

class ManagerTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var salaryLabel: UILabel!
    @IBOutlet weak var receptionTimeLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    var object = Object()
    var delegate: ManagerDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func deleteManager(_ sender: Any) {
        delegate?.deleteManager(item: object)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "managerCell")!
        return cell
    }
    
}
