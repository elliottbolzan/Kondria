//
//  Referral.swift
//  Fermi
//
//  Created by Elliott Bolzan on 12/2/18.
//  Copyright © 2018 Davis Booth. All rights reserved.
//

import Foundation

struct Referral: Codable {
    let id: Int
    let sender: Int
    let recipient: Int
    let company: String
    let status: Status
    let timestamp: String
}
