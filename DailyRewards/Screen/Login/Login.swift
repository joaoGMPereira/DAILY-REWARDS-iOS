//
//  Login.swift
//  DailyRewards
//
//  Created by Joao Gabriel Medeiros Perei on 23/11/19.
//  Copyright (c) 2019 Globile. All rights reserved.
//

import Foundation

public struct Login: Codable {
    var value: String
    
    public init(value: String) {
        self.value = value
    }
    
    var valueComplex: String? {
        return self.value
    }
    
}
