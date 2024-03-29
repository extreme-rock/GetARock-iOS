//
//  ImageLiteral.swift
//  GetARock
//
//  Created by Mijoo Kim on 2023/01/18.
//

import UIKit

enum ImageLiteral {

    // MARK: - SF Symbols
    static var xmarkSymbol: UIImage { .load(systemName: "xmark") }
    static var arrowUpRightSymbol: UIImage { .load(systemName: "arrow.up.right") }
    static var crownSymbol: UIImage { .load(systemName: "crown") }
    static var checkmarkCircleSymbol: UIImage { .load(systemName: "checkmark.circle") }
    static var checkmarkCircleFillSymbol: UIImage { .load(systemName: "checkmark.circle.fill") }
    static var circleSymbol: UIImage {.load(systemName: "circle") }
    static var xmarkCircleSymbol: UIImage { .load(systemName: "x.circle") }
    static var plusSymbol: UIImage { .load(systemName: "plus") }
    static var chevronRightSymbol: UIImage { .load(systemName: "chevron.right")}
    static var personThreeFillSymbol: UIImage { .load(systemName: "person.3.fill") }
    static var chevronLeftSymbol: UIImage { .load(systemName: "chevron.backward") }
    static var ellipsisSymbol: UIImage { .load(systemName: "ellipsis") }
    static var magnifyingGlassSymbol: UIImage { .load(systemName: "magnifyingglass") }
    static var bellSymbol: UIImage { .load(systemName: "bell.fill") }
    static var checkMarkCircleFillSymbol: UIImage { .load(systemName: "checkmark.circle.fill") }
    static var chatBubbleSymbol: UIImage { .load(systemName: "bubble.left.and.bubble.right.fill") }
    static var clockArrowCirclePathSymbol: UIImage { .load(systemName: "clock.arrow.circlepath") }
    static var scopeSymbol: UIImage { .load(systemName: "scope") }
    static var chevronDownSymbol: UIImage { .load(systemName: "chevron.down")}
    static var chevronUpSymbol: UIImage { .load(systemName: "chevron.up")}
    static var exclamationMarkCircleSymbol: UIImage { .load(systemName: "exclamationmark.circle") }
    static var quarternoteSymbol: UIImage { .load(systemName: "music.quarternote.3") }
    static var infoCircleSymbol: UIImage { .load(systemName: "info.circle") }
    
    // MARK: - icon
    
    static var bandIcon: UIImage { .load(named: "bandIcon") }
    static var eventIcon: UIImage { .load(named: "eventIcon") }
    static var youtubeIcon: UIImage { .load(named: "youtubeIcon") }
    static var instagramIcon: UIImage { .load(named: "instagramIcon") }
    static var soundCloudIcon: UIImage { .load(named: "soundCloudIcon") }
    static var leaderIcon: UIImage { .load(named: "leaderIcon")}
    static var memberIcon: UIImage { .load(named: "memberIcon")}
    static var unRegisteredMemberIcon: UIImage { .load(named: "unRegisteredMemberIcon")}
    static var customPinIcon: UIImage { .load(named: "customPinIcon") }
    static var eventNotificationIcon: UIImage { .load(named: "eventNotificationIcon") }
    static var bandNotificationIcon: UIImage { .load(named: "bandNotificationIcon") }
    static var bubbleWithThunderIcon: UIImage { .load(named: "bubbleWithThunderIcon") }
    static var invitingIcon: UIImage { .load(named: "invitingIcon") }
    
    
    // MARK: - background
    
    static var landingBackground: UIImage { .load(named: "landingBackground.png") }
    
}

extension UIImage {
    static func load(named imageName: String) -> UIImage {
        guard let image = UIImage(named: imageName, in: nil, compatibleWith: nil) else {
            return UIImage()
        }
        image.accessibilityIdentifier = imageName
        return image
    }
    
    static func load(systemName: String) -> UIImage {
        guard let image = UIImage(systemName: systemName, compatibleWith: nil) else {
            return UIImage()
        }
        image.accessibilityIdentifier = systemName
        return image
    }
    
    func resize(to size: CGSize) -> UIImage {
        let image = UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
        return image
    }
}
