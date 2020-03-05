//
//  Response.swift
//  DailyRewards
//
//  Created by Joao Gabriel Pereira on 28/02/20.
//  Copyright © 2020 Joao Gabriel Medeiros Perei. All rights reserved.
//

import Foundation

struct HTTPResponse<T: Codable>: Codable {
    let data: T
    let response: BaseResponse
}

struct BaseResponse: Codable {
    let code: Int
    let status: String
}
