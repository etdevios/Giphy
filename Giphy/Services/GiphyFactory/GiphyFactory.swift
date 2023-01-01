// Фабрика получения следующей гифки
// По делегату передается либо успешный ответ, либо ошибка
final class GiphyFactory: GiphyFactoryProtocol {
    // Сетевой слой для получения случайной гифки
    private let urlSession: GiphyURLSessionProtocol

    // Слой маппинг данных из сетевой модели в бизнес модель
    private let mapper: GiphyModelMapperProtocol

    // Делегат по которому будет возвращаться ответ
    weak var delegate: GiphyFactoryDelegate?

    // MARK: - GiphyFactoryProtocol

    init(
        urlSession: GiphyURLSessionProtocol = GiphyURLSession(),
        mapper: GiphyModelMapperProtocol = GiphyModelMapper()
    ) {
        self.urlSession = urlSession
        self.mapper = mapper
    }

    // Загрузка гифки
    func requestNextGiphy() {
        urlSession.fetchGiphy { [weak self] result in
            // результат загрузки гифки
            switch result {

                // Успех
            case .success(let apiModel):
                if let model = self?.mapper.map(model: apiModel) {
                    self?.delegate?.didRecieveNextGiphy(model)
                } else {
                    self?.delegate?.didReciveError(.emptyData)
                }

                // Ошибка
            case .failure(let error):
                self?.delegate?.didReciveError(error)
            }
        }
    }
}
