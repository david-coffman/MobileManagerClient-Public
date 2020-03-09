//
//  DataModel.swift
//  MobileManagerClient
//
//  Created by David Coffman on 7/20/19.
//  Copyright © 2019 David Coffman. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

let importPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
let inboxPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("Inbox")
let dataPath = importPath.appendingPathComponent("active").appendingPathExtension("voterlist")
var applicationData = try? JSONDecoder().decode(VoterExport.self, from: Data.init(contentsOf: dataPath)) {
    didSet {
        saveApplicationData()
    }
}

func saveApplicationData() {
    try! JSONEncoder().encode(applicationData!).write(to: dataPath)
}

var inboxPathContents: [String] {
    let contents = try? FileManager().contentsOfDirectory(atPath: importPath.appendingPathComponent("Inbox").relativePath)
    return (contents ?? [])
}

class VoterExport: Codable {
    let exportIdentifier: Int
    var exportedVoters: [CodableVoter]
}

class VoterInteraction: Codable {
    let interactionType: String
    let interactionDate: Date
}

class VoterHistoryEntry: Codable {
    static var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter
    }()
    
    let electionName: String
    let electionDate: Date
    let votedParty: Int16
}

class CodableVoter: Codable, Identifiable {
    var id: ObjectIdentifier {
        return ObjectIdentifier("\(voterID)" as AnyObject)
    }
    
    let age: Int16
    let attributedData: [VoterInteraction]
    let birthStateCode: String?
    let congressionalDistrict: Int16
    let county: String?
    let countyCommissioner: String?
    let countyID: Int16
    let fireDistrict: String?
    let firstName: String?
    let genderCode: Int16
    let hasDispatched: Bool
    var hasEngaged: Bool
    let judicialDistrict: String?
    let lastName: String?
    let mailingAddress: String?
    let municipalDistrict: String?
    let municipality: String?
    let partyCode: Int16
    let phoneNumber: Int64
    let raceCode: Int16
    let registrationDate: Date?
    let rescueDistrict: String?
    let residentialAddress: String?
    let sanitationDistrict: String?
    let schoolDistrict: String?
    let sewerDistrict: String?
    let stateCode: Int16
    let stateHouseDistrict: Int16
    let stateSenateDistrict: Int16
    let superiorCourtDistrict: String?
    let township: String?
    let voterHistory: [VoterHistoryEntry]?
    let voterID: Int32
    let ward: String?
    let waterDistrict: String?
    let latitude: Double?
    let longitude: Double?
}
