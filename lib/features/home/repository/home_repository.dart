import 'package:get/get.dart';
import 'package:template/core/core.dart';
import 'package:template/core/network/api_endpoints.dart';
import 'package:template/core/network/app_error.dart';
import 'package:template/core/network/network_caller.dart';
import 'package:template/core/network/response_data.dart';
import 'package:template/features/home/model/home_post.dart';

/// Loads the data of the home tab and turns API responses into typed models. Params: [networkCaller]: makes the requests. Defaults to the registered [NetworkCaller].
class HomeRepository {
  final NetworkCaller _caller;

  HomeRepository({NetworkCaller? networkCaller})
    : _caller = networkCaller ?? Get.find<NetworkCaller>();

  // Fetches the posts of the feed.
  Future<ResponseData<List<HomePost>>> getPosts() async {
    final response = await _caller.getRequest(ApiEndpoints.postsNewestFirst);

    try {
      return response.mapData<List<HomePost>>(
        (data) => (data as List<dynamic>)
            .map((item) => HomePost.fromJson(item as Map<String, dynamic>))
            .toList(),
      );
    } catch (e, stackTrace) {
      AppLogger.logError('Unexpected posts response', e, stackTrace);
      return ResponseData.failure(
        error: AppError.unknown,
        statusCode: response.statusCode,
      );
    }
  }

  // Creates a post from the given values. The server sets the counters and the date.
  Future<ResponseData<HomePost>> createPost({
    required String title,
    required String authorName,
    required String authorAvatar,
    required String category,
    required String body,
    required String image,
  }) async {
    final response = await _caller.postRequest(
      ApiEndpoints.posts,
      body: {
        'author': {'name': authorName, 'avatar': authorAvatar},
        'category': category,
        'title': title,
        'body': body,
        'image': image,
      },
    );

    try {
      return response.mapData<HomePost>(
        (data) => HomePost.fromJson(data as Map<String, dynamic>),
      );
    } catch (e, stackTrace) {
      AppLogger.logError('Unexpected create post response', e, stackTrace);
      return ResponseData.failure(
        error: AppError.unknown,
        statusCode: response.statusCode,
      );
    }
  }
}
