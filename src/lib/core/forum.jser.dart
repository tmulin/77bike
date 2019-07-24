// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forum.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$ForumDataSerializer implements Serializer<ForumData> {
  Serializer<BoardCategory> __boardCategorySerializer;
  Serializer<BoardCategory> get _boardCategorySerializer =>
      __boardCategorySerializer ??= BoardCategorySerializer();
  Serializer<BoardClassification> __boardClassificationSerializer;
  Serializer<BoardClassification> get _boardClassificationSerializer =>
      __boardClassificationSerializer ??= BoardClassificationSerializer();
  @override
  Map<String, dynamic> toMap(ForumData model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(
        ret,
        'boardCategories',
        codeIterable(model.boardCategories,
            (val) => _boardCategorySerializer.toMap(val as BoardCategory)));
    setMapValue(
        ret,
        'boardClasses',
        codeIterable(
            model.boardClasses,
            (val) => _boardClassificationSerializer
                .toMap(val as BoardClassification)));
    return ret;
  }

  @override
  ForumData fromMap(Map map) {
    if (map == null) return null;
    final obj = ForumData();
    obj.boardCategories = codeIterable<BoardCategory>(
        map['boardCategories'] as Iterable,
        (val) => _boardCategorySerializer.fromMap(val as Map));
    obj.boardClasses = codeIterable<BoardClassification>(
        map['boardClasses'] as Iterable,
        (val) => _boardClassificationSerializer.fromMap(val as Map));
    return obj;
  }
}

abstract class _$BoardClassificationSerializer
    implements Serializer<BoardClassification> {
  Serializer<Classification> __classificationSerializer;
  Serializer<Classification> get _classificationSerializer =>
      __classificationSerializer ??= ClassificationSerializer();
  @override
  Map<String, dynamic> toMap(BoardClassification model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'id', model.id);
    setMapValue(
        ret,
        'classes',
        codeIterable(model.classes,
            (val) => _classificationSerializer.toMap(val as Classification)));
    return ret;
  }

  @override
  BoardClassification fromMap(Map map) {
    if (map == null) return null;
    final obj = BoardClassification();
    obj.id = map['id'] as int;
    obj.classes = codeIterable<Classification>(map['classes'] as Iterable,
        (val) => _classificationSerializer.fromMap(val as Map));
    return obj;
  }
}

abstract class _$ClassificationSerializer
    implements Serializer<Classification> {
  @override
  Map<String, dynamic> toMap(Classification model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'id', model.id);
    setMapValue(ret, 'name', model.name);
    return ret;
  }

  @override
  Classification fromMap(Map map) {
    if (map == null) return null;
    final obj = Classification();
    obj.id = map['id'] as int;
    obj.name = map['name'] as String;
    return obj;
  }
}
