//
//
// MovieCastApiModel.swift
// MoviesSwiftUI
//
// Created by Tomasz Ogrodowski on 20/03/2025
// Copyright © 2025 Tomasz Ogrodowski. All rights reserved.
//
        

import Foundation

struct MovieCastApiResponseModel: Codable {
    let id: Int
    let cast: [MovieCastApiModel]
}

struct MovieCastApiModel: Codable, Identifiable {
    let adult: Bool?
    let id: Int
    let name: String
    let profilePath: String?
    let character: String?
    let knownForDepartment: String?
}
