//
//  CollectionsAppApp.swift
//  CollectionsApp
//
//  Created by Dominguez, Harley on 4/8/26.
//

//THIS IS THE MOST RECENT WORKING VERSION
//4/20/26 did not implement final claude fixes

import SwiftUI
import SwiftData

@main
struct CollectionsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .tint(Color.brandPurple)
        }
        .modelContainer(for: [ItemGroup.self, Item.self])
    }
}
