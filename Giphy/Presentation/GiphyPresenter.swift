import Foundation
import UIKit
import Photos

// Presenter (бизнес слой для получения следующей гифки)
final class GiphyPresenter: GiphyPresenterProtocol {
    private var giphyFactory: GiphyFactoryProtocol
    
    // Слой View для общения и отображения случайной гифки
    // Так как у нас случай цикла сильных ссылок (сущность viewController владеет сущностью GiphyPresenter,
    // а сущность GiphyPresenter владеет сущностью viewController) то в одном из случаев нужно использовать
    // «слабый» захват («weak capturing»).
    // Принимаем во внимание, что viewController представляет GiphyPresenter,
    // поэтому GiphyPresenter содержит "слабую" ссылку назад к viewController,
    // для избежания утечки памяти.
    weak var viewController: GiphyViewControllerProtocol?
    
    // MARK: - GiphyPresenterProtocol
    
    init(giphyFactory: GiphyFactoryProtocol = GiphyFactory()) {
        self.giphyFactory = giphyFactory
        self.giphyFactory.delegate = self
    }
    
    // Загрузка следующей гифки
    func fetchNextGiphy() {
        // Необходимо показать лоадер
        viewController?.showLoader()
        
        // Обратиться к фабрике и начать грузить новую гифку
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            // Останавливаем индикатор загрузки
            self.viewController?.hideHoaler()
            
            // Показать гифку
            self.viewController?.showGiphy(image)
        }
    }
    
    // При загрузке гифки произошла ошибка
    func didReciveError(_ error: GiphyError) {
        DispatchQueue.main.async { [weak self] in
            // Останавливаем индикатор загрузки
            self?.viewController?.hideHoaler()
            
            // Показать ошибку
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
