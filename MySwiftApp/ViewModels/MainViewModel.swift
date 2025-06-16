import Foundation
import Combine

class MainViewModel: ObservableObject {
    @Published var data: [String] = []
    private var cancellables = Set<AnyCancellable>()

    init() {
        fetchData()
    }

    func fetchData() {
        // Simulate a network call or data fetching
        let sampleData = ["Item 1", "Item 2", "Item 3"]
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.data = sampleData
        }
    }
}