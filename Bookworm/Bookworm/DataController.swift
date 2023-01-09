//
//  DataController.swift
//  Bookworm
//
//  Created by Jake Quinter on 1/9/23.
//

import CoreData

class DataController: ObservableObject {
    @Published var selectedReview: Review?
    let container = NSPersistentContainer(name: "Bookworm")
    var saveTask: Task<Void, Error>?
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
    
    func save() {
        guard container.viewContext.hasChanges else { return }
        try? container.viewContext.save()
    }
    
    func enqueueSave(_ change:  Any) {
        saveTask?.cancel()
        
        saveTask = Task { @MainActor in
            try await Task.sleep(for: .seconds(5))
            save()
        }
    }
}
