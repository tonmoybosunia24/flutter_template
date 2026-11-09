/// A post shown in the home feed. Params: [id]: unique id of the post. [authorName]: full name of the author. [avatarUrl]: the author's photo. [category]: short label shown under the author's name. [title]: heading of the post. [body]: main text of the post. [imageUrl]: the post's photo. [likes]: number of likes. [comments]: number of comments. [createdAt]: when the post was published.
class HomePost {
  final int id;
  final String authorName;
  final String avatarUrl;
  final String category;
  final String title;
  final String body;
  final String imageUrl;
  final int likes;
  final int comments;
  final DateTime createdAt;

  const HomePost({
    required this.id,
    required this.authorName,
    required this.avatarUrl,
    required this.category,
    required this.title,
    required this.body,
    required this.imageUrl,
    required this.likes,
    required this.comments,
    required this.createdAt,
  });

  // Creates a post from one item of the API response.
  factory HomePost.fromJson(Map<String, dynamic> json) {
    final author = json['author'] as Map<String, dynamic>;

    return HomePost(
      id: json['id'] as int,
      authorName: author['name'] as String,
      avatarUrl: author['avatar'] as String,
      category: json['category'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      imageUrl: json['image'] as String,
      likes: json['likes'] as int,
      comments: json['comments'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
