//
//  EssayModel.swift
//  write my essay
//
//  Created by Paul Crews on 12/25/22.
//

import Foundation

class Essays{
    var id = UUID().uuidString
    var title: String
    var essay: String
    var topic: String
    var grade_level: String
    var essay_measurement: String
    var essay_length: Int
    var spell_check: Bool
    var grammar_check: Bool
    var outline: Bool
    var prompt: String
    init(id: String = UUID().uuidString, title: String, essay: String, topic: String, grade_level: String, essay_measurement: String, essay_length: Int, spell_check: Bool, grammar_check: Bool, outline: Bool, prompt: String) {
        self.id = id
        self.title = title
        self.essay = essay
        self.topic = topic
        self.grade_level = grade_level
        self.essay_measurement = essay_measurement
        self.essay_length = essay_length
        self.spell_check = spell_check
        self.grammar_check = grammar_check
        self.outline = outline
        self.prompt = prompt
    }
}
