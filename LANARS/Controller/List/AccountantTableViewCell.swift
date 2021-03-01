//
//  AccountantTableViewCell.swift
//  LANARS
//
//  Created by sashko on 28.02.2021.
//

import UIKit
import RealmSwift

protocol AccountantDelegate {
    func deleteAccountant(item: Object)
}
class AccountantTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var salaryLabel: UILabel!
    @IBOutlet weak var workplaceNumberLabel: UILabel!
    @IBOutlet weak var lunchTimeLabel: UILabel!
    @IBOutlet weak var accountantTypeLabel: UILabel!
    @IBOutlet weak var deleteAccountant: UIButton!
    
    var object = Object()
    var delegate: AccountantDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func deleteAccountant(_ sender: Any) {
        delegate?.deleteAccountant(item: object)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "accountantCell")!
        return cell
    }
    
}
