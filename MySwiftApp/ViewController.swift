import UIKit

class ViewController: UIViewController {
    
    var viewModel: MainViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        bindViewModel()
    }
    
    private func setupView() {
        let mainView = MainView()
        view = mainView
    }
    
    private func bindViewModel() {
        viewModel = MainViewModel()
        
        // Example of binding data from ViewModel to View
        viewModel.dataChanged = { [weak self] in
            // Update the view with new data
            self?.updateView()
        }
        
        viewModel.loadData()
    }
    
    private func updateView() {
        // Update UI elements with data from the view model
    }
}