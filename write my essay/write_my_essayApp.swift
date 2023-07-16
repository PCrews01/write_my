//
//  write_my_essayApp.swift
//  write my essay
//
//  Created by Paul Crews on 12/23/22.
//

import SwiftUI

@main
struct write_my_essayApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                title:"",
                essay:"",
                topic: "",
                grade: "",
                essay_length: 0,
                essay_measurement: "",
                spell_check: false,
                grammar_check: false,
                essay_outline: false,
                prompt: "")
        }
    }
}
