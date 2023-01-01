import Foundation
import UIKit
import Photos

// Presetner (бизнес слой для получения следующей гифки)
final class GiphyPresenter: GiphyPresenterProtocol {
    private var giphyFactory: GiphyFactoryProtocol
    
    // Слой View для общения и отображения случайной гифки
    weak var viewController: GiphyViewControllerProtocol?
    
    // MARK: - GiphyPresenterProtocol
    
    init(giphyFactory: GiphyFactoryProtocol = GiphyFactory()) {
        self.giphyFactory = giphyFactory
        self.giphyFactory.delegate = self
    }
    
    // Загрузка следующей гифки
    func fetchNextGiphy() {
        
        // Необходимо показать лоадер
        // Например -- viewController.showLoader()
        viewController?.showLoader()
        
        // Обратиться к фабрике и начать грузить новую гифку
        // Например -- giphyFactory.requestNextGiphy()
        giphyFactory.requestNextGiphy()
        
        
    }
    
    // Сохранение гифки
    func saveGif(_ image: UIImage?) {
        guard let data = image?.pngData() else {
            return
        }
        
        PHPhotoLibrary.shared().performChanges({
            let request = PHAssetCreationRequest.forAsset()
            request.addResource(with: .photo, data: data, options: nil)
        })
    }
}

// MARK: - GiphyFactoryDelegate

extension GiphyPresenter: GiphyFactoryDelegate {
    // Успешная загрузка гифки
    func didRecieveNextGiphy(_ giphy: GiphyModel) {
        // Преобразуем набор картинок в гифку
        let image = UIImage.gif(url: giphy.url)
        
        // !Обратите внимание в каком потоке это вызывается и нужно ли вызывать дополнительно!
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            // Останавливаем индикатор загрузки -- viewController.hideHoaler()
            self.viewController?.hideHoaler()
            
            // Показать гифку -- viewController.showGiphy(image)
            self.viewController?.showGiphy(image)
            
        }
        
    }
    
    // При загрузке гифки произошла ошибка
    func didReciveError(_ error: GiphyError) {
        // !Обратите внимание в каком потоке это вызывается и нужно ли вызывать дополнительно!
        DispatchQueue.main.async { [weak self] in
            // Останавливаем индикатор загрузки -- viewController.hideHoaler()
            self?.viewController?.hideHoaler()
            // Показать ошибку -- viewController.showError()
            
            let model = AlertModel(
                title: "Что-то пошло не так(",
                message: "Невозможно загрузить данные",
                buttonText: "Попробовать еще раз"
            ) { [weak self] _ in
                guard let self = self else { return }
                print(error)
                self.fetchNextGiphy()
            }
            
            self?.viewController?.presentAlert(model)
        }
    }
}
