import UIKit

//В приложении используется архитектурный паттерн MVP (Model, View, Presenter)

// Model - представление наших данных.
// View - это UIViewController и его подклассы.
// Presenter — не имеет отношения к жизненному циклу View Controller.
// View может быть легко заменена Mock-объектами, поэтому в Presenter нет layout-кода,
// но он отвечает за обновление View в соответствии с новыми данными и состоянием

// Экран на котором показываются гифки
final class GiphyViewController: UIViewController {
    
    private let mainStackView = UIStackView()
    
    private let titleStackView = UIStackView()
    private let titleLabel = UILabel()
    private let counterLabel = UILabel()
    
    private let giphyImageView = UIImageView()
    
    private let paddingView = UIView()
    private let buttonStackView = UIStackView()
    private let yesButton = UIButton()
    private let noButton = UIButton()
    
    private let giphyActivityIndicatorView = UIActivityIndicatorView()
    
    private var alertPresenter: AlertPresenter?
    
    // Переменная Int -- Счетчик залайканых или задизлайканых гифок
    private var showGifCounter = 0
    
    // Переменная Int -- Количество понравившихся гифок
    private var likedGifCounter = 0
    
    // Слой Presenter - бизнес логика приложения, к которым должен общаться UIViewController
    private lazy var presenter: GiphyPresenterProtocol = {
        let presenter = GiphyPresenter()
        presenter.viewController = self
        return presenter
    }()
    
    // MARK: - Жизненный цикл экрана
    override func viewDidLoad() {
        super.viewDidLoad()
        
        actionButton()
        applyStyle()
        applyLayout()
        restart()
        alertPresenter = AlertPresenter(alertPresent: self)
    }
}

// MARK: - Приватные методы и UI
private extension GiphyViewController {
    func applyStyle() {
        view.backgroundColor = Theme.backgroundColor
        
        applyStyleLabel(
            titleLabel,
            text: "Text title label".localized()
        )
        applyStyleLabel(
            counterLabel,
            textAlignment: .right
        )
        
        giphyImageView.image = UIImage(named: "Giphy logo") ?? UIImage()
        giphyImageView.contentMode = .scaleAspectFit
        giphyImageView.layer.cornerRadius = Theme.imageCornerRadius
        
        applyStyleAnswerButton(yesButton, title: "👍")
        applyStyleAnswerButton(noButton, title: "👎")
        
        giphyActivityIndicatorView.style = .large
        giphyActivityIndicatorView.color = .ypWhite
    }
    
    func applyLayout() {
        arrangeStackView(
            mainStackView,
            subviews: [
                titleStackView,
                giphyImageView,
                paddingView
            ],
            spacing: Theme.spacing,
            axis: .vertical
        )
        
        arrangeStackView(
            titleStackView,
            subviews: [titleLabel, counterLabel]
        )
        counterLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        arrangeStackView(
            buttonStackView,
            subviews: [noButton, yesButton],
            spacing: Theme.spacing,
            distribution: .fillEqually
        )
        
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        paddingView.addSubview(buttonStackView)
        buttonStackView.setContentCompressionResistancePriority(.required, for: .vertical)
        
        [mainStackView, giphyActivityIndicatorView].forEach { item in
            item.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(item)
        }
        
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Theme.leftOffset),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Theme.leftOffset),
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Theme.topOffset),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            titleStackView.heightAnchor.constraint(equalToConstant: Theme.titleStackHeight),
            
            giphyImageView.widthAnchor.constraint(equalTo: giphyImageView.heightAnchor, multiplier: Theme.imageHeightAspect),
            
            giphyActivityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            giphyActivityIndicatorView.centerYAnchor.constraint(equalTo: giphyImageView.centerYAnchor),
            giphyActivityIndicatorView.heightAnchor.constraint(equalToConstant: Theme.spacing),
            giphyActivityIndicatorView.widthAnchor.constraint(equalToConstant: Theme.spacing),
            
            buttonStackView.leadingAnchor.constraint(equalTo: paddingView.leadingAnchor, constant: Theme.leftOffsetButtonStack),
            buttonStackView.trailingAnchor.constraint(equalTo: paddingView.trailingAnchor, constant: -Theme.leftOffsetButtonStack),
            buttonStackView.centerYAnchor.constraint(equalTo: paddingView.centerYAnchor),
            
            buttonStackView.heightAnchor.constraint(equalToConstant: Theme.buttonHeight)
        ])
    }
    
    func actionButton() {
        yesButton.addTarget(self, action: #selector(yesButtonTapped), for: .primaryActionTriggered)
        noButton.addTarget(self, action: #selector(noButtonTapped), for: .primaryActionTriggered)
    }
    
    // MARK: Supporting methods
    func arrangeStackView(
        _ stackView: UIStackView,
        subviews: [UIView],
        spacing: CGFloat = 0,
        axis: NSLayoutConstraint.Axis = .horizontal,
        distribution: UIStackView.Distribution = .fill,
        alignment: UIStackView.Alignment = .fill
    ) {
        stackView.axis = axis
        stackView.spacing = spacing
        stackView.distribution = distribution
        stackView.alignment = alignment
        
        subviews.forEach { item in
            item.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(item)
        }
    }
    
    func applyStyleLabel(
        _ label: UILabel,
        text: String = "",
        font: UIFont? = Theme.mediumLargeFont,
        textColor: UIColor = .ypWhite,
        textAlignment: NSTextAlignment = .left,
        numberOfLines: Int = 1
    ) {
        label.text = text
        label.font = font
        label.textColor = textColor
        label.textAlignment = textAlignment
        label.numberOfLines = numberOfLines
    }
    
    func applyStyleAnswerButton(_ button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = Theme.mediumLargeFont
        button.setTitleColor(.ypBlack, for: .normal)
        button.backgroundColor = .ypWhite
        button.layer.cornerRadius = Theme.buttonCornerRadius
        button.layer.masksToBounds = true
        button.isEnabled = false
    }
    
    func setGiphyImageViewBorder(width: CGFloat = 0, color: CGColor = UIColor.ypWhite.cgColor) {
        giphyImageView.layer.borderWidth = width
        giphyImageView.layer.borderColor = color
    }
    
    func restart() {
        showGifCounter = 1
        likedGifCounter = 0
        setTextForCounterLabel()
        presenter.fetchNextGiphy()
    }
    
    func didAnswer(isYes: Bool) {
        if isYes {
            likedGifCounter += 1
            // Сохраняем понравившуюся гифку
            presenter.saveGif(giphyImageView.image)
        }
        checkLookedTenGifts()
        showImageBorder(isAnswer: isYes)
        setTextForCounterLabel()
    }
    
    func checkLookedTenGifts() {
        let maxAttempts = 9
        if showGifCounter > maxAttempts {
            showEndOfGiphy()
        } else {
            showGifCounter += 1
            presenter.fetchNextGiphy()
        }
    }
    
    func setTextForCounterLabel() {
        counterLabel.text = "\(likedGifCounter)/\(showGifCounter)"
    }
    
    func showImageBorder(isAnswer: Bool) {
        let color = isAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        setGiphyImageViewBorder(width: Theme.imageAnswerBorderWidth, color: color)
        
        [noButton, yesButton].forEach { $0.isEnabled = false }
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
        let messageLocalized = "Did you like it: %d/10".localized()
        
        let model = AlertModel(
            title: "Memes are over!".localized(),
            message: String.localizedStringWithFormat(messageLocalized, likedGifCounter),
            buttonText: "I want to see more gifs".localized()
        ) { [weak self] _ in
            guard let self = self else { return }
            self.restart()
            self.giphyImageView.image = UIImage(named: "Giphy logo") ?? UIImage()
        }
        presentAlert(model)
    }
    
    // Показать гифку UIImage
    func showGiphy(_ image: UIImage?) {
        giphyImageView.image = image
        activatedButton()
    }
    
    // Вызвать giphyActivityIndicatorView показа индикатора загрузки
    func showLoader() {
        giphyActivityIndicatorView.startAnimating()
        giphyActivityIndicatorView.isHidden = false
    }
    
    // Остановить giphyActivityIndicatorView показа индикатора загрузки
    func hideHoaler() {
        giphyActivityIndicatorView.stopAnimating()
        setGiphyImageViewBorder()
    }
    
    func presentAlert(_ alert: AlertModel) {
        alertPresenter?.showAlert(with: alert)
    }
    
    func activatedButton() {
        [noButton, yesButton].forEach { $0.isEnabled = true }
    }
}

// MARK: - Actions
private extension GiphyViewController {
    // Нажатие на кнопку лайка
    @objc private func yesButtonTapped() {
        // Проверка на то просмотрели или нет 10 гифок
        // Если все 10 гифок просмотрели необходимо показать UIAlertController о завершении
        // При нажатии на кнопку в UIAlertController необходимо сбросить счетчики и начать сначала
        // Иначе, если еще не просмотрели 10 гифок, то увеличиваем счетчик и обновляем UIlabel с счетчиком
        didAnswer(isYes: true)
    }
    
    // Нажатие на кнопку дизлайка
    @objc private func noButtonTapped() {
        // Проверка на то просмотрели или нет 10 гифок
        // Если все 10 гифок просмотрели необходимо показать UIAlertController о завершении
        // При нажатии на кнопку в UIAlertController необходимо сбросить счетчики и начать
        // Иначе, если еще не просмотрели 10 гифок, то увеличиваем счетчик и обновляем UIlabel с счетчиком
        didAnswer(isYes: false)
    }
}
