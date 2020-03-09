//
//  ImportExportTableViewController.swift
//  MobileManagerClient-UIKit
//
//  Created by David Coffman on 7/27/19.
//  Copyright © 2019 David Coffman. All rights reserved.
//

import UIKit
import CoreData

class ImportExportTableViewController: UITableViewController {

    let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    lazy var fetchedResultsController: NSFetchedResultsController<CanvasArchive> = {
        let fetchRequest: NSFetchRequest<CanvasArchive> = CanvasArchive.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "exportIdentifier", ascending: true)]
            let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            try! fetchedResultsController.performFetch()
            return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return applicationData != nil ? 3 : 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Import..."
        case 1:
            return "Export..."
        case 2:
            return "Active Voter List..."
        default:
            return nil
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        switch section {
        case 0:
            return inboxPathContents.count
        case 1:
            return fetchedResultsController.fetchedObjects?.count ?? 0
        case 2:
            return 1
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basic", for: indexPath)
        switch indexPath.section {
        case 0:
            cell.textLabel!.text = inboxPathContents[indexPath.row]
            cell.accessoryType = .disclosureIndicator
        case 1:
            cell.textLabel!.text = "Export with ID: \(fetchedResultsController.fetchedObjects![indexPath.row].exportIdentifier)"
            cell.accessoryType = .disclosureIndicator
        case 2:
            cell.textLabel!.text = "Export Active Voter List"
            cell.accessoryType = .disclosureIndicator
        default:
            return tableView.dequeueReusableCell(withIdentifier: "ERROR")!
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 2 {
            return false
        }
        else {
            return true
        }
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            switch indexPath.section {
            case 0:
                try! FileManager().removeItem(at: inboxPath.appendingPathComponent(inboxPathContents[indexPath.row]))
            case 1:
                viewContext.delete(fetchedResultsController.fetchedObjects![indexPath.row])
                try! viewContext.save()
                try! fetchedResultsController.performFetch()
            default:
                return
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            if let applicationData = applicationData {
                let oldDataArchive = try! JSONEncoder().encode(applicationData)
                let canvasArchive = CanvasArchive(context: viewContext)
                canvasArchive.data = oldDataArchive
                canvasArchive.exportIdentifier = Int16(applicationData.exportIdentifier)
                try! viewContext.save()
            }
            applicationData = try! JSONDecoder().decode(VoterExport.self, from: Data(contentsOf: inboxPath.appendingPathComponent(inboxPathContents[indexPath.row])))
            try! fetchedResultsController.performFetch()
            print(applicationData!.exportedVoters)
        case 1:
            let data = fetchedResultsController.fetchedObjects![indexPath.row].data!
            try! data.write(to: importPath.appendingPathComponent("export.voterlist"))
            let activityController = UIActivityViewController(activityItems: [importPath.appendingPathComponent("export.voterlist")], applicationActivities: nil)
            activityController.popoverPresentationController?.sourceView = self.tableView
            present(activityController, animated: true, completion: {
            })
        case 2:
            try! (try! JSONEncoder().encode(applicationData!)).write(to: importPath.appendingPathComponent("export.voterlist"))
            let activityController = UIActivityViewController(activityItems: [importPath.appendingPathComponent("export.voterlist")], applicationActivities: nil)
            activityController.popoverPresentationController?.sourceView = self.tableView
            present(activityController, animated: true, completion: {
            })
        default:
            return
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
