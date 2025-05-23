//
//
// URL+Extension.swift
// MoviesSwiftUI
//
// Created by Tomasz Ogrodowski on 21/03/2025
// Copyright © 2025 Tomasz Ogrodowski. All rights reserved.
//
        

import Foundation

extension URL {

    init?(imagePath: String?) {
        guard let imagePath else { return nil }
        let imageBase = "https://image.tmdb.org/t/p/w500"
        self.init(string: "\(imageBase)\(imagePath)")
    }

}
