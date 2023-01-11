// Фабрика для получения гифки из сетевого слоя и преобразования сетевой модели в бизнес модель
// Через фабрику можно:
// - Получить модель гифки
// - Размапить сетевую модель в бизнес модель
// - Вернуть полученный ответ
protocol GiphyFactoryProtocol {
    // Делегат по которому будет возвращаться ответ из сети
    var delegate: GiphyFactoryDelegate? { get set }
    
    // Конструктор для фабрики получения гифок
    init(urlSession: GiphyURLSessionProtocol, mapper: GiphyModelMapperProtocol)
    
    // Получение случайной гифки
    func requestNextGiphy()
}
