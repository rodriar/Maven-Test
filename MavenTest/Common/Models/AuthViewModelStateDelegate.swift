//
//  AuthViewModelStateDelegate.swift
//  MavenTest
//
//  Created by German on 5/20/20.
//  Copyright © 2020 Rootstrap Inc. All rights reserved.
//

import Foundation
import UIKit

protocol NetworkStatusDelegate: class {
  func networkStatusChanged(to networkStatus: NetworkState)
}


extension NetworkStatusDelegate where Self: UIViewController {
  func networkStatusChanged(to networkStatus: NetworkState) {
    if let viewController = self as? ActivityIndicatorPresenter {
      viewController.showActivityIndicator(networkStatus == .loading)
    }
    switch networkStatus {
    case .error(let errorDescription):
      showMessage(title: "Error", message: errorDescription)
    default:
      break
    }
  }
}
