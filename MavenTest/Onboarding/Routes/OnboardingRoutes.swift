//
//  OnboardingRoutes.swift
//  MavenTest
//
//  Created by Mauricio Cousillas on 6/13/19.
//  Copyright © 2019 Rootstrap Inc. All rights reserved.
//

import Foundation
import UIKit

enum OnboardingRoutes: Route {
  case firstScreen

  var screen: UIViewController {
    switch self {
    case .firstScreen:
      return buildFirstViewController()
    }
  }


  private func buildFirstViewController() -> UIViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let viewController = storyboard.instantiateViewController(withIdentifier: "FirstViewController")
    guard let first = viewController as? FirstViewController else {
        return UIViewController()
    }
//    guard let first = R.storyboard.main.firstViewController() else {
//      return UIViewController()
//    }
    first.viewModel = FirstViewModel()
    return first
  }
}
