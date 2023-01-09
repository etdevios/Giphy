import UIKit

struct AlertPresenter {
    
    private(set) weak var alertPresent: UIViewController?
    
    func showAlert(with model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(
            title: model.buttonText,
            style: .default,
            handler: model.completion
        )
        
        alert.addAction(action)
        alertPresent?.present(alert, animated: true)
    }
}
