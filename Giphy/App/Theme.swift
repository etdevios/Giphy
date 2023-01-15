import UIKit

enum Theme {
    
    static let boldLargeFont = UIFont(name: "YS Display-Bold", size: 23)
    static let boldSmallFont = UIFont(name: "YS Display-Bold", size: 18)
    static let mediumLargeFont = UIFont(name: "YS Display-Medium", size: 20)
    static let mediumSmallFont = UIFont(name: "YS Display-Medium", size: 16)
    
    static let buttonCornerRadius: CGFloat = 15
    static let buttonHeight: CGFloat = 60
    static let titleStackHeight: CGFloat = 24
    
    static let imageCornerRadius: CGFloat = 20
    static let imageAnswerBorderWidth: CGFloat = 8
    static var imageHeightAspect: CGFloat {
        if switchingScreen() {
            return 5/7
        }
        return 5/8
    }
    
    static let spacing: CGFloat = 20
    static let leftOffset: CGFloat = 20
    static let topOffset: CGFloat = 10
    static var backgroundColor: UIColor {
        if switchingScreen() {
            return .ypBackground
        }
        return .ypBlue
    }
    static let leftOffsetButtonStack: CGFloat = 14
    
    private static func switchingScreen() -> Bool {
        let screenWidth = UIScreen.main.bounds.width
        if screenWidth == 320 {
            return true
        }
        return false
    }
}
