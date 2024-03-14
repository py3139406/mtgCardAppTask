//
//  Cards.swift
//  CodingInterviewSampleProject2022
//
//  Created by pavan yadav on 08/03/24.
//

import Foundation

struct Card: Codable {
    let id: String
    let nameEnglish: String
    let nameJapanese: String
    let abilityEnglish: String
    let abilityJapanese: String
    let types: [String]
    let imageUrls: [String]
}
