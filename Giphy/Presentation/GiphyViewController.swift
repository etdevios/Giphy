import UIKit

// Экран на котором показываются гифки
final class GiphyViewController: UIViewController {
    
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    
    private var alertPresenter: AlertPresenter?
    
    // Переменная Int -- Счетчик залайканых или задизлайканных гифок
    // Например showdGifCounter -- счетчика показанных гифок
    private var showGifCounter = 0
    
    // Переменная Int -- Количество понравившихся гифок
    // Например likedGifCounter -- счетчик любимых гифок
    private var likedGifCounter = 0
    
    // @IBOutlet UILabel для счетчика гифок, например 1/10
    // Например -- @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    
    // @IBOutlet UIImageView для Гифки
    // Например -- @IBOutlet weak var giphyImageView: UIImageView!
    @IBOutlet private weak var giphyImageView: UIImageView!
    
    // @IBOutlet UIActivityIndicatorView загрузки гифки, так как она может загрухаться долго
    @IBOutlet private weak var giphyActivityIndicatorView: UIActivityIndicatorView!
    
    // Нажатие на кнопку лайка
    @IBAction func onYesButtonTapped(_ sender: UIButton) {
        // Проверка на то просмотрели или нет 10 гифок
        
        // Если все 10 гифок просомтрели необходимо показать UIAlertController о завершении
        // При нажатии на кнопку в UIAlertController необходимо сбросить счетчики и начать сначала
        sender.isEnabled = false
        highlightImageBorder(isCorrectAnswer: true)
        // Иначе, если еще не просмотрели 10 гифок, то увеличиваем счетчик и обновляем UIlabel с счетчиком
        likedGifCounter += 1
        checkLookedTenGifts()
        
        // Сохраняем понравившуюся гифку
        // presenter.saveGif(<Созданный UIImageView для @IBOutlet>.image)
        // Например -- presenter.saveGif(giphyImageView.image)
        presenter.saveGif(giphyImageView.image)
        
        // Загружаем следующую гифку
        // presenter.fetchNextGiphy()
        presenter.fetchNextGiphy()
    }
    
    // Нажатие на кнопку дизлайка
    @IBAction func onNoButtonTapped(_ sender: UIButton) {
        // Проверка на то просмотрели или нет 10 гифок
        
        // Если все 10 гифок просомтрели необходимо показать UIAlertController о завершении
        // При нажатии на кнопку в UIAlertController необходимо сбросить счетчики и начать
        sender.isEnabled = false
        highlightImageBorder(isCorrectAnswer: false)
        // Иначе, если еще не просмотрели 10 гифок, то увеличиваем счетчик и обновляем UIlabel с счетчиком
        checkLookedTenGifts()
        
        // Загружаем следующую гифку
        // presenter.fetchNextGiphy()
        presenter.fetchNextGiphy()
    }
    
    // Слой Presenter - бизнес логика приложения, к которым должен общаться UIViewController
    private lazy var presenter: GiphyPresenterProtocol = {
        let presenter = GiphyPresenter()
        presenter.viewController = self
        return presenter
    }()
    
    // MARK: - Жизенный цикл экрана
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restart()
        alertPresenter = AlertPresenter(alertPresent: self)
    }
}

// MARK: - Приватные методы

private extension GiphyViewController {
    // Увеличиваем счетчик просмотренных гифок на 1
    // Обновляем UILabel который находится в верхнем UIStackView и отвечает за количество просмотренных гифок
    // Обновляем счетчик просмотренных гифок UIlabel
    func updateCounterLabel() {
        showGifCounter += 1
        counterLabel.text = "\(likedGifCounter)/\(showGifCounter)"
    }
    
    // Перезапускаем счетчики просмотренных гифок и понравившихся гифок
    // Обновляем UILabel который находится в верхнем UIStackView и отвечает за количество просмотренных гифок
    // Загружаем гифку
    func restart() {
        showGifCounter = 1
        likedGifCounter = 0
        counterLabel.text = "\(likedGifCounter)/\(showGifCounter)"
        // presenter.fetchNextGiphy()
        presenter.fetchNextGiphy()
    }
    
    func checkLookedTenGifts() {
        let maxAttempts = 9
        if showGifCounter > maxAttempts {
            showEndOfGiphy()
            restart()
        } else {
            updateCounterLabel()
        }
    }
    
}

// MARK: - GiphyViewControllerProtocol

extension GiphyViewController: GiphyViewControllerProtocol {
    // Показ ошибки UIAlertController, что не удалось загрузить гифку
    
    func showEndOfGiphy() {
        // Необходимо показать UIAlertController
        // Заголовок -- Мемы закончились!
        // Сообщение -- Вам понравилось: \(n)\\10
        // Кнопка -- Хочу посмотреть еще гифок
        //
        // При нажатии сбросить все счетчики -- вызов метода restart
        
        let model = AlertModel(
            title: "Мемы закончились!",
            message: "Вам понравилось: \(likedGifCounter)/10",
            buttonText: "Хочу посмотреть ещё гифок"
        ) { [weak self] _ in
            guard let self = self else { return }
            self.restart()
        }
        presentAlert(model)
    }
    
    // Показать гифку UIImage
    func showGiphy(_ image: UIImage?) {
        // giphyImageView.image = image
        giphyImageView.image = image
        activatedButton()
    }
    
    // Показать лоадер
    // Присвоить UIImageView.image = nil
    // Вызвать giphyActivityIndicatorView показа индикатора загрузки
    func showLoader() {
        giphyActivityIndicatorView.startAnimating()
        giphyActivityIndicatorView.isHidden = false
    }
    
    // Остановить giphyActivityIndicatorView показа индикатора загрузки
    func hideHoaler() {
        giphyActivityIndicatorView.stopAnimating()
        giphyActivityIndicatorView.isHidden = true
        giphyImageView.layer.borderWidth = 0
    }
    
    func presentAlert(_ alert: AlertModel) {
        alertPresenter?.showAlert(with: alert)
    }
    
    func activatedButton() {
        noButton.isEnabled = true
        yesButton.isEnabled = true
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        
        giphyImageView.layer.masksToBounds = true
        giphyImageView.layer.borderWidth = 8
        giphyImageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
}
