import Foundation

// Кастомные ошибки при загрузке данных для гифок из сети
enum GiphyError: Error {
    // Некорректно задан URL запрос
    case wrongRequestURL

    // Не удалось распарсить сетевой ответ
    case wrongDecoding

    // Пустые данные
    case emptyData

    // Не удалось загрузить гифку из URL
    case wrongGifURL
}
