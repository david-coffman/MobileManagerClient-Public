//
//  MainTableViewController.swift
//  MobileManagerClient-UIKit
//
//  Created by David Coffman on 7/23/19.
//  Copyright © 2019 David Coffman. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    var lastSelectedIndexPath: IndexPath? = nil
    @IBOutlet var filterToggle: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Canvas"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        guard applicationData != nil else {noDataError(); return 0}
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard applicationData != nil else {return 0}
        switch section {
        case 0:
            return 1
        case 1:
            switch filterToggle.isOn {
            case true:
                return applicationData!.exportedVoters.count
            case false:
                return applicationData!.exportedVoters.filter({$0.hasEngaged == false}).count
            }
            
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Map View"
        case 1:
            return "Voter List"
        default:
            return nil
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return tableView.dequeueReusableCell(withIdentifier: "viewOnMap", for: indexPath)
        case 1:
            return voterCell(at: indexPath)
        default:
            return tableView.dequeueReusableCell(withIdentifier: "ERROR", for: indexPath)
        }
    }
    
    
    func voterCell(at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "voter") as! VoterTableViewCell
        
        var voter: CodableVoter! = nil
        
        if filterToggle.isOn {
            voter = applicationData!.exportedVoters[indexPath.row]
        }
        else {
            voter = applicationData!.exportedVoters.filter({$0.hasEngaged == false})[indexPath.row]
        }
        
        cell.nameLabel.text = "\(voter.lastName!), \(voter.firstName!) (\(voter.age))"
        
        switch voter.partyCode {
        case 1:
            cell.partyLabelImage.image = UIImage(systemName: "r.circle.fill")
            cell.partyLabelImage.tintColor = .systemRed
        case 2:
            cell.partyLabelImage.image = UIImage(systemName: "d.circle.fill")
            cell.partyLabelImage.tintColor = .systemBlue
        case 3:
            cell.partyLabelImage.image = UIImage(systemName: "l.circle.fill")
            cell.partyLabelImage.tintColor = .systemYellow
        case 4:
            cell.partyLabelImage.image = UIImage(systemName: "g.circle.fill")
            cell.partyLabelImage.tintColor = .systemGreen
        case 5:
            cell.partyLabelImage.image = UIImage(systemName: "c.circle.fill")
            cell.partyLabelImage.tintColor = .systemOrange
        default:
            cell.partyLabelImage.image = UIImage(systemName: "u.circle.fill")
            cell.partyLabelImage.tintColor = .systemPurple
        }
        
        cell.raceLabelImage.tintColor = .black
        switch voter.raceCode {
        case 0:
            cell.raceLabelImage.image = UIImage(systemName: "b.circle.fill")
        case 1:
            cell.raceLabelImage.image = UIImage(systemName: "i.circle.fill")
        case 2:
            cell.raceLabelImage.image = UIImage(systemName: "o.circle.fill")
        case 3:
            cell.raceLabelImage.image = UIImage(systemName: "w.circle.fill")
        case 4:
            cell.raceLabelImage.image = UIImage(systemName: "a.circle.fill")
        case 5:
            cell.raceLabelImage.image = UIImage(systemName: "m.circle.fill")
        default:
            cell.raceLabelImage.image = UIImage(systemName: "u.circle.fill")
        }
        
        switch voter.genderCode {
        case 1:
            cell.genderLabelImage.image = UIImage(systemName: "m.circle.fill")
            cell.genderLabelImage.tintColor = .systemBlue
        case 2:
            cell.genderLabelImage.image = UIImage(systemName: "f.circle.fill")
            cell.genderLabelImage.tintColor = .systemPink
        default:
            cell.genderLabelImage.image = UIImage(systemName: "questionmark.circle.fill")
            cell.genderLabelImage.tintColor = .systemOrange
        }
        
        switch voter.hasEngaged {
        case true:
            cell.engagementLabelImage.image = UIImage(systemName: "checkmark.circle.fill")
            cell.engagementLabelImage.tintColor = .green
        case false:
            cell.engagementLabelImage.image = UIImage(systemName: "x.circle.fill")
            cell.engagementLabelImage.tintColor = .red
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            performSegue(withIdentifier: "viewAllOnMap", sender: self)
        }
        if indexPath.section == 1 {
            lastSelectedIndexPath = indexPath
            performSegue(withIdentifier: "didSelectVoterFromTable", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? VoterDetailTableViewController {
            if filterToggle.isOn {
                destination.selectedVoter = applicationData!.exportedVoters[lastSelectedIndexPath!.row]
            }
            else {
                destination.selectedVoter = applicationData!.exportedVoters.filter({$0.hasEngaged == false})[ lastSelectedIndexPath!.row]
            }
        }
        if let destination = segue.destination as? MapViewController {
            if filterToggle.isOn {
                destination.selectedVoters = applicationData!.exportedVoters
                destination.isFiltering = !filterToggle.isOn
            }
        }
    }
    
    func noDataError() {
        let alert = UIAlertController(title: "No Data", message: "You must import an export from the MM Dispatch app in order to use MM Client. See the tutorial for more information.", preferredStyle: .alert)
        let goToImport = UIAlertAction(title: "View Importable Lists", style: .default) { action in
            self.performSegue(withIdentifier: "import", sender: self)
        }
        let viewTutorial = UIAlertAction(title: "View Tutorial", style: .default) { action in
            self.initializeTutorial()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(goToImport)
        alert.addAction(viewTutorial)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    func initializeTutorial() {
        
    }

    @IBAction func didToggleFilter(_ sender: Any) {
        tableView.reloadData()
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
