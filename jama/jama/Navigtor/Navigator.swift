//
//  Navigator.swift
//  jama
//
//  Created by Mark Brightman on 09/03/2018.
//  Copyright © 2018 Mark Brightman. All rights reserved.
//

import Foundation

protocol Navigator {
    associatedtype Destination
    
    func navigate(to destination: Destination)
}
