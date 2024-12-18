
public final class APIClientMock: APIClientProtocol {
    public init() { }

    public func get<T>(endpoint: Endpoint, queryItems: [String : String]?, headers: [String : String]?) async throws -> T where T : Decodable {
        fatalError("Not implemented")
    }
}
