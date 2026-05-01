import '../../data/client/dio_client.dart';
import '../../common/constants.dart';

class GameRepository {
  final DioClient _dioClient = DioClient();

  /// Fetches games from the API with the specified limits
  /// 
  /// [featuredLimit] - Number of featured games to fetch (default: 3)
  /// [newLimit] - Number of new games to fetch (default: 10)
  Future<Map<String, dynamic>> getGames({
    int featuredLimit = defaultFeaturedLimit,
    int newLimit = defaultNewLimit,
  }) async {
    try {
      final response = await _dioClient.get(
        gameLibEndpoint,
        // queryParameters: {
        //   'featured_limit': featuredLimit,
        //   'new_limit': newLimit,
        // },
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Failed to load games: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      // Error is already handled by DioClient interceptor
      // Re-throw with additional context if needed
      throw Exception('Error fetching games: $e\nStack trace: $stackTrace');
    }
  }
}