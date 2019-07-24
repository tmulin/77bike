import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'package:qiqi_bike/models/forum/forum_forumlist.dart';
import 'package:scoped_model/scoped_model.dart';

part 'forum.jser.dart';

class ForumModel extends Model {
  ForumData _forumData = ForumData();

  ForumModel();

  ForumModel.fromJson(Map<String, dynamic> json) {
    try {
      ForumData data = ForumDataSerializer().fromMap(json);
      if (data != null) this._forumData = data;
    } catch (exp) {
      print("反序列化 数据模型失败 => ${exp.toString()}");
    }
    this.buildMap();
  }

  void update(
      {List<BoardCategory> categories, List<BoardClassification> classes}) {
    if (categories != null) {
      this._forumData.boardCategories = categories;
    }
    if (classes != null) {
      this._forumData.boardClasses = classes;
    }

    this.buildMap();
    notifyListeners();
  }

  Map<String, dynamic> toJson() {
    return ForumDataSerializer().toMap(this._forumData);
  }

  List<BoardCategory> get boardCategories => this._forumData.boardCategories;

  ///  Map Board ID to Board
  Map<int, Board> _boards = {};

  /// Map Board ID to Board Classifications
  Map<int, List<Classification>> _classes = {};

  Map<int, Board> get boards => this._boards;

  Map<int, List<Classification>> get boardClasses => _classes;

  void buildMap() {
    try {
      Map<int, Board> tempBoards = {};
      this.boardCategories.forEach((item) {
        tempBoards.addEntries(
            item.board_list.map((board) => MapEntry(board.board_id, board)));
      });

      this._boards.clear();
      this._boards.addAll(tempBoards);
    } catch (exp) {
      print(exp);
    }

    try {
      Map<int, List<Classification>> tempClasses = {};
      this._forumData.boardClasses.forEach((item) {
        tempClasses[item.id] = item.classes;
      });

      this._classes.clear();
      this._classes.addAll(tempClasses);
    } catch (exp) {
      print(exp);
    }
  }
}

class ForumData {
  List<BoardCategory> _boardCategories;

  List<BoardClassification> _boardClasses;

  List<BoardCategory> get boardCategories => _boardCategories ?? [];

  List<BoardClassification> get boardClasses => _boardClasses ?? [];

  set boardCategories(value) => _boardCategories = value ?? [];

  set boardClasses(value) => _boardClasses = value ?? [];
}

class BoardClassification {
  /// boardId
  int id;
  List<Classification> classes;

  BoardClassification({this.id, this.classes = const []});
}

class Classification {
  // typeId
  int id;
  String name;

  Classification({this.id, this.name});
}

@GenSerializer()
class ForumDataSerializer extends Serializer<ForumData>
    with _$ForumDataSerializer {}

@GenSerializer()
class BoardClassificationSerializer extends Serializer<BoardClassification>
    with _$BoardClassificationSerializer {}

@GenSerializer()
class ClassificationSerializer extends Serializer<Classification>
    with _$ClassificationSerializer {}
