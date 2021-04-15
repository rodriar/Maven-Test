//
//  ViewController.swift
//  MavenTest
//
//  Created by Rootstrap on 15/2/16.
//  Copyright © 2016 Rootstrap Inc. All rights reserved.
//

import UIKit
import SnapKit

class FirstViewController: UIViewController,
                           ActivityIndicatorPresenter {

  // MARK: - Outlets

  @IBOutlet weak var genderFilterButton: UIButton!
  @IBOutlet weak var colorFilterButton: UIButton!
  @IBOutlet weak var filmFilterButton: UIButton!
  @IBOutlet weak var tableView: UITableView!
  let activityIndicator = UIActivityIndicatorView()

  var viewModel: FirstViewModel!
  var backgroundView = UIView()
  var genderPicker = UIPickerView()
  var colorPicker = UIPickerView()
  var filmPicker = UIPickerView()

  // MARK: - Lifecycle



  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.getAllFilms()
    viewModel.getMoreCharacters()
    viewModel.delegate = self
    setupTableView()
    showActivityIndicator(true)
    setupPicker()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: true)
  }

  func setupTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.sectionHeaderHeight = UITableView.automaticDimension
    tableView.estimatedSectionHeaderHeight = 44
    tableView.register(UINib(nibName: CharacterCell.nibName, bundle: nil),
                       forCellReuseIdentifier: CharacterCell.cellIdentifier)
  }

  func setupPicker() {
    self.view.addSubview(backgroundView)
    backgroundView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.4)
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapRecognized))
    tapGesture.numberOfTapsRequired = 1
    tapGesture.isEnabled = true
    tapGesture.cancelsTouchesInView = false
    backgroundView.addGestureRecognizer(tapGesture)
    backgroundView.isHidden = true
    backgroundView.snp.makeConstraints { [weak self] (make) -> Void in
      guard let self = self else { return }
      make.left.bottom.right.top.equalTo(self.view.safeAreaLayoutGuide)
    }
    [genderPicker, colorPicker, filmPicker].forEach { (picker) in
      picker.delegate = self
      picker.dataSource = self
      backgroundView.addSubview(picker)
      picker.isHidden = true
      picker.backgroundColor = .white
      picker.tintColor = .black
      picker.snp.makeConstraints { [weak self] (make) -> Void in
        guard let self = self else { return }
        make.left.bottom.right.equalTo(self.view.safeAreaLayoutGuide)
        make.size.equalTo(CGSize(width: self.view.frame.width, height: 180))
      }
    }
    filmFilterButton.tintColor = .gray
    colorFilterButton.tintColor = .gray
    genderFilterButton.tintColor = .gray
  }

  // MARK: - Actions
  @IBAction func touchFilm(_ sender: Any) {
    if viewModel.filmFilter != nil {
      filmFilterButton.tintColor = .gray
      viewModel.filmFilter = nil
      viewModel.filterCharacters()
    } else {
      filmFilterButton.tintColor = .blue
      filmPicker.isHidden = !filmPicker.isHidden
      colorPicker.isHidden = true
      genderPicker.isHidden = true
      backgroundView.isHidden = !backgroundView.isHidden
    }

  }

  @IBAction func touchColor(_ sender: Any) {
    if viewModel.hairColorFilter != nil {
      colorFilterButton.tintColor = .gray
      viewModel.hairColorFilter = nil
      viewModel.filterCharacters()
    } else {
      colorFilterButton.tintColor = .blue
      colorPicker.isHidden = !colorPicker.isHidden
      filmPicker.isHidden = true
      genderPicker.isHidden = true
      backgroundView.isHidden = !backgroundView.isHidden
    }
  }

  @IBAction func touchGender(_ sender: UIButton) {
    if viewModel.genderFilter != nil {
      genderFilterButton.tintColor = .gray
      viewModel.genderFilter = nil
      viewModel.filterCharacters()
    } else {
      genderFilterButton.tintColor = .blue
      genderPicker.isHidden = !genderPicker.isHidden
      colorPicker.isHidden = true
      filmPicker.isHidden = true
      backgroundView.isHidden = !backgroundView.isHidden
    }

  }

  @objc func tapRecognized() {
    backgroundView.isHidden = true
    genderPicker.isHidden = true
    colorPicker.isHidden = true
    filmPicker.isHidden = true
  }

}
// MARK: - UITableViewDelegate, UITableViewDataSource
extension FirstViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel.filteredCharacters.count
  }

  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterCell.cellIdentifier,
                                                   for: indexPath) as? CharacterCell else {
      return UITableViewCell()
    }

    cell.configure(withCharacter: viewModel.filteredCharacters[indexPath.row])
    if viewModel.filteredCharacters.count - 1 == indexPath.row {
      viewModel.getMoreCharacters()
    }
    return cell
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section:Int) -> String? {
    "Characters"
  }

}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension FirstViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    1
  }

  func pickerView(_ pickerView: UIPickerView,
                  numberOfRowsInComponent component: Int) -> Int {
    var amount = 0
    if pickerView == genderPicker {
      amount = viewModel.genders.count
    }
    if pickerView == colorPicker {
      amount = viewModel.hairColors.count
    }
    if pickerView == filmPicker {
      amount = viewModel.films.count
    }
    return amount
  }

  func pickerView(_ pickerView: UIPickerView,
                  didSelectRow row: Int,
                  inComponent component: Int) {
    if pickerView == genderPicker {
      viewModel.genderFilter = viewModel.genders[row]
    }
    if pickerView == colorPicker {
      viewModel.hairColorFilter = viewModel.hairColors[row]
    }
    if pickerView == filmPicker {
      viewModel.filmFilter = viewModel.films[row]
    }
    viewModel.filterCharacters()
  }

  func pickerView(_ pickerView: UIPickerView,
                  titleForRow row: Int,
                  forComponent component: Int) -> String? {

    var contentString = ""
    if pickerView == genderPicker {
      contentString = viewModel.genders[row]
    }
    if pickerView == colorPicker {
      contentString = viewModel.hairColors[row]
    }
    if pickerView == filmPicker {
      contentString = viewModel.films[row].title
    }
    return contentString
  }
}

extension FirstViewController: FirstViewModelDelegate {
  func updateTableView() {
    tableView.reloadData()
  }

  func didUpdateState(to state: FirstViewModelState) {
    switch state {
    case .network(let networkStatus):
      showActivityIndicator(false)
      networkStatusChanged(to: networkStatus)
    case .loading:
      showActivityIndicator(true)
    case .loadedCharacters:
      showActivityIndicator(false)
    }
  }

  func updatePickers() {
    filmPicker.reloadAllComponents()
    colorPicker.reloadAllComponents()
  }
}
