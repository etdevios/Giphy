import Foundation

// Сетевой слой, необходим для загрузки гифок из сети
// Возвращает сетевую модель GiphyAPIModel
final class GiphyURLSession: GiphyURLSessionProtocol {
    private let urlSession: URLSession

    // MARK: - GiphyURLSessionProtocol

    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }

    func fetchGiphy(completion: ((Result<GiphyAPIModel, GiphyError>) -> Void)?) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.giphy.com"
        urlComponents.path = "/v1/gifs/random"
        urlComponents.queryItems = [
            .init(name: "api_key", value: "3kc6OFgsZGKURypdRNAiXhK2r5gnQaVs"),
            .init(name: "tag", value: ""),
            .init(name: "rating", value: "g")
        ]

        guard let url = urlComponents.url else {
            completion?(.failure(GiphyError.wrongRequestURL))
            return
        }
        
        urlSession.dataTask(with: url, completionHandler: { (data, response, error) in
            guard let data = data else {
                completion?(.failure(GiphyError.emptyData))
                return
            }

            do {
                let apiModel = try JSONDecoder().decode(GiphyAPIModel.self, from: data)
                completion?(.success(apiModel))
            } catch {
                completion?(.failure(.wrongDecoding))
            }
        }).resume()
    }
}
