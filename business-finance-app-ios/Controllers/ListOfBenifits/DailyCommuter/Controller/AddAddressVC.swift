//
//  AddAddressVC.swift
//  BFA
//
//  Created by Mohammed Aslam Shaik on 2022/9/3.
//  Copyright © 2022 Viable Labs. All rights reserved.
//

import UIKit
import GooglePlaces

class AddAddressVC: AutocompleteBaseViewController {
    private let padding: CGFloat = 20
    private lazy var searchField: UITextField = {
      let searchField = UITextField(frame: .zero)
      searchField.translatesAutoresizingMaskIntoConstraints = false
      searchField.borderStyle = .none
      searchField.backgroundColor = .white
      searchField.placeholder = NSLocalizedString(
        "Demo.Content.Autocomplete.EnterTextPrompt",
        comment: "Prompt to enter text for autocomplete demo")
      searchField.autocorrectionType = .no
      searchField.keyboardType = .default
      searchField.returnKeyType = .done
      searchField.clearButtonMode = .whileEditing
      searchField.contentVerticalAlignment = .center

      searchField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
      return searchField
    }()

    private lazy var resultsController: UITableViewController = UITableViewController(style: .plain)

    private lazy var tableDataSource: GMSAutocompleteTableDataSource = {
      let tableDataSource = GMSAutocompleteTableDataSource()
      tableDataSource.tableCellBackgroundColor = .white
      return tableDataSource
    }()

    override func viewDidLoad() {
      super.viewDidLoad()

      view.backgroundColor = .white
      navigationController?.navigationBar.isTranslucent = false
      searchField.delegate = self
      tableDataSource.delegate = self
      resultsController.tableView.delegate = tableDataSource
      resultsController.tableView.dataSource = tableDataSource

      view.addSubview(searchField)
      NSLayoutConstraint.activate([
        searchField.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
        searchField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
        searchField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
      ])

      // Add the results controller
      guard let resultView = resultsController.view else { return }
      resultView.translatesAutoresizingMaskIntoConstraints = false
      resultView.alpha = 0
      view.addSubview(resultView)
      NSLayoutConstraint.activate([
        resultView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: padding),
        resultView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        resultView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        resultView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      ])
    }

    @objc func textFieldChanged(sender: UIControl) {
      guard let textField = sender as? UITextField else { return }
      tableDataSource.sourceTextHasChanged(textField.text)
    }

    func dismissResultView() {
      resultsController.willMove(toParent: nil)
      UIView.animate(
        withDuration: 0.5,
        animations: {
          self.resultsController.view.alpha = 0
        }
      ) { (_) in
        self.resultsController.view.removeFromSuperview()
        self.resultsController.removeFromParent()
      }
    }
  }

  extension AddAddressVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
      addChild(resultsController)
      resultsController.tableView.reloadData()
      UIView.animate(
        withDuration: 0.5,
        animations: {
          self.resultsController.view.alpha = 1
        }
      ) { (_) in
        self.resultsController.didMove(toParent: self)
      }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      textField.resignFirstResponder()
      return false
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
      dismissResultView()
      textField.resignFirstResponder()
      textField.text = ""
      tableDataSource.clearResults()
      return false
    }
  }

  extension AddAddressVC: GMSAutocompleteTableDataSourceDelegate {
    func tableDataSource(
      _ tableDataSource: GMSAutocompleteTableDataSource, didAutocompleteWith place: GMSPlace
    ) {
      dismissResultView()
      searchField.resignFirstResponder()
      searchField.isHidden = true
      autocompleteDidSelectPlace(place)
    }

    func tableDataSource(
      _ tableDataSource: GMSAutocompleteTableDataSource, didFailAutocompleteWithError error: Error
    ) {
      dismissResultView()
      searchField.resignFirstResponder()
      searchField.isHidden = true
      autocompleteDidFail(error)
    }

    func didRequestAutocompletePredictions(for tableDataSource: GMSAutocompleteTableDataSource) {
      UIApplication.shared.isNetworkActivityIndicatorVisible = true
      resultsController.tableView.reloadData()

    }
    func didUpdateAutocompletePredictions(for tableDataSource: GMSAutocompleteTableDataSource) {
      UIApplication.shared.isNetworkActivityIndicatorVisible = false
      resultsController.tableView.reloadData()
    }
  }
