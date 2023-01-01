// Фабрика для получения гифки из сетевого слоя и преобразования сетевой мобели в бизнес модель
// Через фабрику можно:
// - Получить модель гифки
// - Размапить сетеву модель в бизнес модель
// - Вернуть полученный ответ
protocol GiphyFactoryProtocol {
    // Делегат по которому будет возвращаться ответ из сети
    var delegate: GiphyFactoryDelegate? { get set }

    // Коснтруктор для фабрики получени] гифок
    init(urlSession: GiphyURLSessionProtocol, mapper: GiphyModelMapperProtocol)

    // Получение случайной гифки
    func requestNextGiphy()
}
