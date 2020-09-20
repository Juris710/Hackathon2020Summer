class Question {
  final String title;
  final String content;
  final String createdBy;
  final List<String> answers;
  Question._({this.title, this.content, this.createdBy, this.answers});
  factory Question.fromMap(Map<String, dynamic> data) {
    return Question._(
        title: data['title'],
        content: data['content'],
        createdBy: data['createdBy'],
        answers: data['answers'].cast<String>() as List<String>);
  }
}
