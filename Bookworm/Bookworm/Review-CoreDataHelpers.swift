//
//  Review-CoreDataHelpers.swift
//  Bookworm
//
//  Created by Jake Quinter on 1/9/23.
//

import Foundation

extension Review {
    var reviewTitle: String {
        get { title ?? "" }
        set {
            guard managedObjectContext != nil else { return }
            title = newValue
        }
    }
    
    var reviewAuthor: String {
        get { author ?? "" }
        set {
            guard managedObjectContext != nil else { return }
            author = newValue
        }
    }
    
    var reviewText: String {
        get { text ?? "" }
        set {
            guard managedObjectContext != nil else { return }
            text = newValue
        }
    }
}
