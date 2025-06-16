import Foundation

struct Model {
    var id: UUID
    var name: String
    var description: String
    
    init(id: UUID = UUID(), name: String, description: String) {
        self.id = id
        self.name = name
        self.description = description
    }
}