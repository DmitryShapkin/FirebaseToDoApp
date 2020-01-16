//
//  AppUser.swift
//  ToDoFIRE
//
//  Created by Dmitry Shapkin on 16/01/2020.
//  Copyright © 2020 ShapkinDev. All rights reserved.
//

import Foundation
import Firebase

struct AppUser {
    let uid: String
    let email: String
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email!
    }
}
