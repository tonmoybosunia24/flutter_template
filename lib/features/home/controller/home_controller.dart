import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:template/core/core.dart';
import 'package:template/features/home/model/home_post.dart';
import 'package:template/features/home/repository/home_repository.dart';

/// Holds the state and logic of the home tab: loads the post feed and tracks its loading and error state.
class HomeController extends GetxController {
  final HomeRepository _repository = Get.find<HomeRepository>();

  final RxList<HomePost> posts = <HomePost>[].obs; 
  final RxBool isLoading = false.obs; 
  final RxnString errorMessage = RxnString(); 
  final RxSet<int> likedPostIds = <int>{}.obs;

  final TextEditingController titleController = TextEditingController(); 
  final RxBool canCreatePost = false.obs; 
  final RxBool isCreatingPost = false.obs; 
  final RxnString createPostError = RxnString(); 
  final String authorName = 'Tonmoy Bosunia';
  final String postCategory = 'Travel';
  final String authorAvatarPath = '/images/avatars/profile.jpg';
  final String postBody = 'Shared from the app.';
  final String postImagePath = '/images/posts/3.jpg';

  bool isLiked(int postId) => likedPostIds.contains(postId); 
  int likeCount(HomePost post) => post.likes + (isLiked(post.id) ? 1 : 0); 
  void likePost(int postId) => likedPostIds.add(postId); 
  void toggleLike(int postId) { // Adds or removes the user's like on the post with [postId].
    if (!likedPostIds.remove(postId)) likedPostIds.add(postId);
  }

  // How long ago [post] was published, in the current language.
  String timeAgo(HomePost post) {
    final elapsed = DateTime.now().difference(post.createdAt);

    if (elapsed.inMinutes < 1) return AppStrings.homeJustNow.tr;
    if (elapsed.inHours < 1) {
      return AppStrings.homeMinutesAgo.trParams({
        'count': '${elapsed.inMinutes}',
      });
    }
    if (elapsed.inDays < 1) {
      return AppStrings.homeHoursAgo.trParams({'count': '${elapsed.inHours}'});
    }
    return AppStrings.homeDaysAgo.trParams({'count': '${elapsed.inDays}'});
  }

  @override
  void onInit() {
    super.onInit();
    titleController.addListener(_updateCanCreatePost);
    fetchPosts();
  }

  @override
  void onClose() {
    titleController.dispose();
    super.onClose();
  }

  void _updateCanCreatePost() => canCreatePost.value = titleController.text.trim().isNotEmpty;

  // Loads the feed. Also used by pull-to-refresh and the retry button.
  Future<void> fetchPosts() async {
    isLoading.value = true;
    errorMessage.value = null;
    final response = await _repository.getPosts();
    // The tab may have been closed while the request was running.
    if (isClosed) return;
    if (response.isSuccess) {
      posts.assignAll(response.data ?? const []);
    } else {
      errorMessage.value = response.errorMessage;
    }
    isLoading.value = false;
  }

  // Sends the typed title as a new post and shows it at the top of the feed.
  Future<void> createPost() async {
    final title = titleController.text.trim();
    if (title.isEmpty || isCreatingPost.value) return;

    isCreatingPost.value = true;
    createPostError.value = null;
    final response = await _repository.createPost(
      title: title,
      authorName: authorName,
      authorAvatar: authorAvatarPath,
      category: postCategory,
      body: postBody,
      image: postImagePath,
    );
    if (isClosed) return;

    final post = response.data;
    if (response.isSuccess && post != null) {
      posts.insert(0, post);
      titleController.clear();
      FocusManager.instance.primaryFocus?.unfocus();
    } else {
      createPostError.value = response.errorMessage;
    }
    isCreatingPost.value = false;
  }
}
