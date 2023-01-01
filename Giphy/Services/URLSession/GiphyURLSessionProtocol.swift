import Foundation

// Протокол сетевого слоя, через который будут загружаться гифки
// Через сетевой слой будут загружаться гифки
//
// Документация: https://developers.giphy.com/explorer/?
// Токен: 3kc6OFgsZGKURypdRNAiXhK2r5gnQaVs
// Ресурс: Public API
// Endpoint: Random
// Пример запроса: https://api.giphy.com/v1/gifs/random?api_key=3kc6OFgsZGKURypdRNAiXhK2r5gnQaVs&tag=&rating=g

protocol GiphyURLSessionProtocol {
    // Конструктор для сетевого слоя
    init(urlSession: URLSession)

    // Метод загрузки гифок, возвращает:
    // - GiphyAPIModel: сетевую модель, если данные загрузились корректно
    // - Error: ошибку, если не удалось загрузить данные, сервер не доступен или отсутствует соединение с интернетом
    func fetchGiphy(completion: ((Result<GiphyAPIModel, GiphyError>) -> Void)?)
}
