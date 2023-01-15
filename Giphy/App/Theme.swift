import UIKit

enum Theme {
    
    static let boldLargeFont = UIFont(name: "YSDisplay-Bold", size: 23)
    static let boldSmallFont = UIFont(name: "YSDisplay-Bold", size: 18)
    static var mediumFont: UIFont {
        switchingScreen() ?
        UIFont(name: "YSDisplay-Medium", size: 16) ?? UIFont.systemFont(ofSize: 16) :
        UIFont(name: "YSDisplay-Medium", size: 20) ?? UIFont.systemFont(ofSize: 20)
    }
    static var backgroundColor: UIColor {
        switchingScreen() ? .ypBackground : .ypBlue
    }
    static var topOffset: CGFloat {
        switchingScreen() ? 20 : 10
    }
    static let leftOffset: CGFloat = 20
    static let spacing: CGFloat = 20
    
    static let titleStackHeight: CGFloat = 24
    
    static let imageCornerRadius: CGFloat = 20
    static let imageAnswerBorderWidth: CGFloat = 8
    static var imageHeightAspect: CGFloat {
        switchingScreen() ? 5/7 : 67/120
    }
    
    static let buttonCornerRadius: CGFloat = 15
    static var buttonHeight: CGFloat {
        switchingScreen() ? 47 : 60
    }
    static var spacingForButton: CGFloat {
        switchingScreen() ? 8 : 19
    }
    
    private static func switchingScreen() -> Bool {
        let screenWidth = UIScreen.main.bounds.width
        return screenWidth == 320
    }
}
