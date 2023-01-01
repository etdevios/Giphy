// Делегат по которому будет возвращаться гифка
protocol GiphyFactoryDelegate: AnyObject {
    // Успешное получение гифки, необходимо отобразить гифку
    func didRecieveNextGiphy(_ giphy: GiphyModel)

    // Ошибка при загрузке гифки
    func didReciveError(_ error: GiphyError)
}
