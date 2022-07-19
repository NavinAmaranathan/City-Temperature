//
//  ViewController.swift
//  Definitiv
//
//  Created by Navi on 23/02/22.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var headerLabel: UILabel!
    @IBOutlet private weak var getDetailsButton: UIButton!
    @IBOutlet private weak var enterCity: UILabel!
    @IBOutlet private weak var minTemp: UILabel!
    @IBOutlet private weak var minTempValue: UILabel!
    @IBOutlet private weak var maxTemp: UILabel!
    @IBOutlet private weak var maxTempValue: UILabel!
    
    // MARK: - Properties
    private let viewModel: ViewModelData = ViewModel()
    
    // MARK: - View Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
    }
    
    // MARK: - Action methods
    @IBAction func getDetailsPressed(_ sender: Any) {
        fetchDetails()
    }
    
    // MARK: - Private methods
    private func fetchDetails() {
        guard let city = textField.text else { return }
        viewModel.fetchTemperatures(cityName: city)  {[weak self] result in
            switch result {
            case .success(let output):
                guard let data = output else { return }
                self?.updateUI(with: data)
            case .failure:
                self?.displayError()
            }
        }
    }
    
    private func updateUI(with data: Temperatures) {
        guard let minValue = data?["minValue"],
              let maxValue = data?["maxValue"]
        else { return }

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.minTempValue.text = minValue
            self.maxTempValue.text = maxValue
        }
    }
    
    private func displayError() {
        DispatchQueue.main.async { [weak self] in
            let alertVC = UIAlertController(title: "Sorry", message: "Unable to fetch details, please check city name!!", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self?.present(alertVC, animated: true)
        }
    }
}
