//
//  VoterDetailTableViewController.swift
//  MobileManagerClient-UIKit
//
//  Created by David Coffman on 7/23/19.
//  Copyright © 2019 David Coffman. All rights reserved.
//

import UIKit

class VoterDetailTableViewController: UITableViewController {
    
    static let sectionNames = ["Biographical", "Contact"]
    static let sectionLengths = [5,3]
    var selectedVoter: CodableVoter! = nil
    lazy var sortedVoterHistory = (selectedVoter.voterHistory ?? []).sorted(by: {$0.electionDate > $1.electionDate})

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "\(selectedVoter.firstName!) \(selectedVoter.lastName!)"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Biographical"
        case 1:
            return "Contact"
        case 2:
            return "Voter History"
        case 3:
            return "Engagement"
        default:
            return nil
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 5
        case 1:
            return 3
        case 2:
            return sortedVoterHistory.count > 0 ? sortedVoterHistory.count : 1
        case 3:
            if selectedVoter.hasEngaged {
                return 1
            }
            else {
                return 2
            }
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return voterBiographicalCell(at: indexPath)
        case 1:
            return voterConactCell(at: indexPath)
        case 2:
            return voterHistoryCell(at: indexPath)
        case 3:
            if indexPath.row == 0 {
                if selectedVoter.hasEngaged {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "withImage", for: indexPath) as! WithImageTableViewCell
                    cell.sideImage.image = UIImage(systemName: "checkmark.circle.fill")
                    cell.sideImage.tintColor = .systemGreen
                    cell.label.text = "This voter has been engaged."
                    return cell
                }
                else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "withImage", for: indexPath) as! WithImageTableViewCell
                    cell.sideImage.image = UIImage(systemName: "x.circle.fill")
                    cell.sideImage.tintColor = .systemRed
                    cell.label.text = "This voter hasn't been engaged."
                    return cell
                }
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "basicBlue", for: indexPath)
                return cell
            }
        default:
            return tableView.dequeueReusableCell(withIdentifier: "ERROR", for: indexPath)
        }
    }
    
    func voterBiographicalCell(at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "withImage", for: indexPath) as! WithImageTableViewCell
        cell.accessoryType = .none
        switch indexPath.row {
        case 0:
            switch selectedVoter.partyCode {
            case 1:
                cell.label.text = "Republican"
                cell.sideImage.image = UIImage(systemName: "r.circle.fill")
                cell.sideImage.tintColor = .systemRed
            case 2:
                cell.label.text = "Democrat"
                cell.sideImage.image = UIImage(systemName: "d.circle.fill")
                cell.sideImage.tintColor = .systemBlue
            case 3:
                cell.label.text = "Libertarian"
                cell.sideImage.image = UIImage(systemName: "l.circle.fill")
                cell.sideImage.tintColor = .systemYellow
            case 4:
                cell.label.text = "Green"
                cell.sideImage.image = UIImage(systemName: "g.circle.fill")
                cell.sideImage.tintColor = .systemGreen
            case 5:
                cell.label.text = "Constitution"
                cell.sideImage.image = UIImage(systemName: "c.circle.fill")
                cell.sideImage.tintColor = .systemOrange
            default:
                cell.label.text = "Unaffiliated"
                cell.sideImage.image = UIImage(systemName: "u.circle.fill")
                cell.sideImage.tintColor = .purple
            }
        case 1:
            switch selectedVoter.genderCode {
            case 1:
                cell.label.text = "Male"
                cell.sideImage.image = UIImage(systemName: "m.circle.fill")
                cell.sideImage.tintColor = .systemBlue
            case 2:
                cell.label.text = "Female"
                cell.sideImage.image = UIImage(systemName: "f.circle.fill")
                cell.sideImage.tintColor = .systemPink
            default:
                cell.label.text = "Unknown"
                cell.sideImage.image = UIImage(systemName: "questionmark.circle.fill")
                cell.sideImage.tintColor = .systemOrange
            }
        case 2:
            if selectedVoter.age > 50 {
                cell.sideImage.image = UIImage(systemName: "plus.circle.fill")
            }
            else {
                cell.sideImage.image = UIImage(systemName: "\(selectedVoter.age).circle.fill")
            }
            cell.sideImage.tintColor = .black
            cell.label.text = "\(selectedVoter.age) years old"
        case 3:
            switch selectedVoter.raceCode {
            case 0:
                cell.label.text = "Black"
                cell.sideImage.image = UIImage(systemName: "b.circle.fill")
                cell.sideImage.tintColor = .black
            case 1:
                cell.label.text = "American Indian"
                cell.sideImage.image = UIImage(systemName: "i.circle.fill")
                cell.sideImage.tintColor = .black
            case 2:
                cell.label.text = "Other"
                cell.sideImage.image = UIImage(systemName: "o.circle.fill")
                cell.sideImage.tintColor = .black
            case 3:
                cell.label.text = "White"
                cell.sideImage.image = UIImage(systemName: "w.circle.fill")
                cell.sideImage.tintColor = .black
            case 4:
                cell.label.text = "Asian"
                cell.sideImage.image = UIImage(systemName: "a.circle.fill")
                cell.sideImage.tintColor = .black
            case 5:
                cell.label.text = "Multiple Races"
                cell.sideImage.image = UIImage(systemName: "m.circle.fill")
                cell.sideImage.tintColor = .black
            default:
                cell.label.text = "Undesignated"
                cell.sideImage.image = UIImage(systemName: "questionmark.circle.fill")
                cell.sideImage.tintColor = .black
            }
        case 4:
            cell.label.text = "\(Int(Date().timeIntervalSince(selectedVoter.registrationDate!)/31536000)) years"
            cell.sideImage.image = UIImage(systemName: "\(Int(Date().timeIntervalSince(selectedVoter.registrationDate!)/31536000)).circle.fill")
            cell.sideImage.tintColor = .black
        default:
            return tableView.dequeueReusableCell(withIdentifier: "ERROR")!
        }
        return cell
    }
    
    func voterConactCell(at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basic", for: indexPath)
        switch indexPath.row {
        case 0:
            cell.textLabel!.numberOfLines = 0
            cell.textLabel!.text = "Residential Address:\n\(selectedVoter.residentialAddress!)"
            if let lat = selectedVoter.latitude, let longitude = selectedVoter.longitude {
                cell.accessoryType = .disclosureIndicator
            }
            else {
                cell.accessoryType = .none
            }
        case 1:
            cell.textLabel!.numberOfLines = 0
            cell.textLabel!.text = "Mailing Address:\n\(selectedVoter.mailingAddress!)"
            cell.accessoryType = .none
        case 2:
            cell.textLabel!.numberOfLines = 1
            cell.textLabel!.text = "Phone Number: \(selectedVoter.phoneNumber != 0 ? "\(selectedVoter.phoneNumber)" : "N/A")"
            if selectedVoter.phoneNumber != 0 {
                cell.accessoryType = .disclosureIndicator
            }
            else {
                cell.accessoryType = .none
            }
        default:
            return tableView.dequeueReusableCell(withIdentifier: "ERROR")!
        }
        return cell
    }
    
    func voterHistoryCell(at indexPath: IndexPath) -> UITableViewCell {
        if sortedVoterHistory.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "basic", for: indexPath)
            cell.textLabel!.text = "History unavailable."
            cell.accessoryType = .none
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "withImage", for: indexPath) as! WithImageTableViewCell
        let thisElection = sortedVoterHistory[indexPath.row]
        if thisElection.electionName.contains("PRIMARY") {
            switch thisElection.votedParty {
                case 1:
                    cell.sideImage.image = UIImage(systemName: "r.circle.fill")
                    cell.sideImage.tintColor = .systemRed
                case 2:
                    cell.sideImage.image = UIImage(systemName: "d.circle.fill")
                    cell.sideImage.tintColor = .systemBlue
                case 3:
                    cell.sideImage.image = UIImage(systemName: "l.circle.fill")
                    cell.sideImage.tintColor = .systemYellow
                case 4:
                    cell.sideImage.image = UIImage(systemName: "g.circle.fill")
                    cell.sideImage.tintColor = .systemGreen
                case 5:
                    cell.sideImage.image = UIImage(systemName: "c.circle.fill")
                    cell.sideImage.tintColor = .systemOrange
                default:
                    cell.sideImage.image = UIImage(systemName: "u.circle.fill")
                    cell.sideImage.tintColor = .purple
            }
        }
        else {
            cell.sideImage.image = UIImage(systemName: "minus.circle.fill")
            cell.sideImage.tintColor = .black
        }
        cell.label.text = thisElection.electionName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath == [1,0] {
            if let lat = selectedVoter.latitude, let longitude = selectedVoter.longitude {
                performSegue(withIdentifier: "showVoterAddress", sender: self)
                // segue to map view
                
            }
        }
        if indexPath == [1,2] {
            if selectedVoter.phoneNumber != 0 {
                UIApplication.shared.open(URL(string: "tel://\(self.selectedVoter.phoneNumber)")!, options: [:])
            }
        }
        if indexPath == [3,1] {
            selectedVoter.hasEngaged = true
            saveApplicationData()
            tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MapViewController {
            destination.selectedVoters = [selectedVoter]
            destination.isFiltering = false
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
