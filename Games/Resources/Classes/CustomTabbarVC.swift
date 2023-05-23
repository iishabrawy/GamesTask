//
//  CustomTabbarVC.swift
//  Games
//
//  Created by Ismael Mahmoud AlShabrawy on 19/05/2023.
//

import UIKit

/// A custom subclass of `UITabBarController` that provides additional customization options.
class CustomTabbarVC: UITabBarController {

    /// An array of view controllers to be displayed in the tab bar.
    var arrViewController: [UIViewController] = []

    /// The color of the selected tab bar item title.
    var selectedTitleColor: UIColor = DesignSystem.AppColors.blackColor.color

    /// The color of the normal (unselected) tab bar item title.
    var normalTitleColor: UIColor = .gray

    /// The indicator view that highlights the selected tab bar item.
    private let indicator: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.frame.size = CGSize(width: Int(UIScreen.main.bounds.width) / 5, height: 2)
        view.layer.cornerRadius = 1
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }

    /// Adds a tab bar item to the tab bar with the specified properties.
    func addtabbrItem(
        atIndex: Int, viewContrller: UIViewController, andTitle: String,
        andImgName: String, andSeletedImg: String, isHideTitle: Bool = false,
        imageInsets _: UIEdgeInsets, titlePos _: UIOffset) {

            arrViewController.insert(viewContrller, at: atIndex)
            viewControllers = arrViewController
            tabBar.tintColor = DesignSystem.AppColors.accentColor.color

            let tabbrCus = tabBar
            let tabbarItemCus = tabbrCus.items?[atIndex]

            if isHideTitle {
                // tabbarItemCus?.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 50)
            } else {
                tabbarItemCus?.title = andTitle
                // tabbarItemCus?.titlePositionAdjustment = titlePos
            }

            tabbarItemCus?.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)

            let imgNotSelected = UIImage(imageLiteralResourceName: andImgName)
                .withRenderingMode(.alwaysTemplate)

            var imgSelected: UIImage
            if #available(iOS 13.0, *) {
                imgSelected = UIImage(imageLiteralResourceName: andSeletedImg)
                    .withRenderingMode(.alwaysTemplate)
                    .withTintColor(DesignSystem.AppColors.blueColor.color)
            } else {
                // Fallback on earlier versions
                if let cgImage = UIImage(named: andSeletedImg)?.cgImage {
                    let coloredImage = UIImage(cgImage: cgImage, scale: UIScreen.main.scale, orientation: .up)
                    let tintedImage = coloredImage.withRenderingMode(.alwaysTemplate)
                    UIGraphicsBeginImageContextWithOptions(coloredImage.size, false, tintedImage.scale)
                    DesignSystem.AppColors.blueColor.color.set()
                    tintedImage.draw(in: CGRect(origin: .zero, size: tintedImage.size))
                    imgSelected = UIGraphicsGetImageFromCurrentImageContext() ?? coloredImage
                    UIGraphicsEndImageContext()
                } else {
                    imgSelected = UIImage()
                }
            }

            tabbarItemCus?.image = imgNotSelected
            tabbarItemCus?.selectedImage = imgSelected

            UITabBarItem.appearance().setTitleTextAttributes(
                [NSAttributedString.Key.foregroundColor: selectedTitleColor],
                for: .selected
            )
            tabBar.backgroundColor = DesignSystem.AppColors.whiteColor.color
        }

    /// Generates a navigation controller with the specified root view controller.
    func generateNavigation(viewController: UIViewController) -> UINavigationController {
        let navigation = UINavigationController(rootViewController: viewController)
        let imageInd = UIImage(named: "back")
        navigation.navigationBar.backIndicatorImage = imageInd
        navigation.navigationBar.backIndicatorTransitionMaskImage = imageInd
        navigation.navigationBar.tintColor = UIColor.black
        return navigation
    }

    /// Animates the indicator view to highlight the selected tab bar item.
    private func animate(index: Int) {
        let buttons = tabBar.subviews
            .filter { String(describing: $0).contains("Button") }

        guard index < buttons.count else {
            return
        }

        let selectedButton = buttons[index]
        UIView.animate(
            withDuration: 0.25,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                let point = CGPoint(
                    x: selectedButton.center.x,
                    y: -1.5
                )
                self.indicator.center = point
            },
            completion: nil
        )
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        animate(index: selectedIndex)
    }
}

extension CustomTabbarVC: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard
            let items = tabBar.items,
            let index = items.firstIndex(of: item)
        else {
            return
        }
        animate(index: index)
    }
}

