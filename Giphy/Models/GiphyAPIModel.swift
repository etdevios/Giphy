import Foundation

// Сетевая модель для получения и декодинга гифок
struct GiphyAPIModel: Decodable {
    // Данные для гифки
    let data: Data?
}

extension GiphyAPIModel {
    struct Data: Decodable {
        // Уникальный идентификатор гифки
        let id: String?

        // Ссылка для скачинваия гифки
        let images: Images?
    }
}

extension GiphyAPIModel.Data {
    struct Images: Decodable {
//        let preview_gif: PreviewGif?
//        let original: Original?
        let downsized_large: Downsized_large?
    }
}

extension GiphyAPIModel.Data.Images {
//    struct PreviewGif: Decodable {
//        let url: URL?
//    }
//    struct Original: Decodable {
//        let url: URL?
//    }
    struct Downsized_large: Decodable {
        let url: URL?
    }
}
