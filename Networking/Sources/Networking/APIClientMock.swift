
public final class APIClientMock: APIClient {
    public var response: Decodable?
    public var error: APIError?

    public init() { }

    public func get<T>(endpoint: Endpoint, queryItems: [String : String]?, headers: [String : String]?) async throws -> T where T : Decodable {
        if let error {
            throw error
        }
        return response as! T
    }
}
