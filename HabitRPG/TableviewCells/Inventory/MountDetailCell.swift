//
//  MountDetailCell.swift
//  Habitica
//
//  Created by Phillip Thelen on 16.04.18.
//  Copyright © 2018 HabitRPG Inc. All rights reserved.
//

import Foundation
import Habitica_Models

class MountDetailCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: NetworkImageView!
    
    func configure(mountItem: MountStableItem) {
        backgroundColor = ThemeService.shared.theme.contentBackgroundColor
        imageView.tintColor = ThemeService.shared.theme.dimmedColor
        if let key = mountItem.mount?.key {
            if mountItem.owned {
                imageView.setImagewith(name: "Mount_Icon_\(key)")
                accessibilityLabel = mountItem.mount?.text
            } else {
                ImageManager.getImage(name: "Mount_Icon_\(key)") {[weak self] (image, _) in
                    self?.imageView.image = image?.withRenderingMode(.alwaysTemplate)
                }
                accessibilityLabel = L10n.Accessibility.unknownMount
            }
        }
        
        shouldGroupAccessibilityChildren = true
        isAccessibilityElement = true
    }
}
