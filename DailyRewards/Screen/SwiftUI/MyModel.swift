//
//  MyModel.swift
//  DailyRewards
//
//  Created by Joao Gabriel Pereira on 18/02/20.
//  Copyright © 2020 Joao Gabriel Medeiros Perei. All rights reserved.
//

import Foundation

class MyModel: ObservableObject {
    @Published var didUpdate: Bool = false
    @Published var isPresented: Bool = false
    
    @Published var firstname: String = "" {
        didSet { updateDismissability() }
    }
    
    @Published var lastname: String = "" {
        didSet { updateDismissability() }
    }
    
    @Published var preventDismissal: Bool = false
    
    func updateDismissability() {
        self.preventDismissal = lastname != "" || firstname != ""
    }
    
    func save() {
        print("save data")
        self.resetForm()
    }
    
    func resetForm() {
        self.firstname = ""
        self.lastname = ""
    }
}
