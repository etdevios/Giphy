import UIKit

// Протокол для общения между Presenter и View слоями
protocol GiphyViewControllerProtocol: AnyObject {
    
    // Отображение гифки
    func showGiphy(_ image: UIImage?)
    
    // Начать показывать индикатор загрузки гифки
    func showLoader()
    
    // Закончить показывать индикатор загрузки гифки
    func hideHoaler()
    
    // Отображение уведомлений
    func presentAlert(_ alert: AlertModel)
    
    // Метод для активирования кнопок
    func activatedButton()
}
