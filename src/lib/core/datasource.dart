import 'package:scoped_model/scoped_model.dart';

abstract class DataSource<T> extends Model {
  /// 是否正在加载数据
  bool _isloading = false;

  bool get isloading => _isloading;

  /// 当前页码
  int _page = 1;

  int get page => _page;

  /// 分页大小
  int _pageSize = 10;

  int get pageSize => _pageSize;

  /// 总数据量(null表示不确定)
  int _total;

  int get total => _total;

  set total(vale) => _total = vale;

  bool _hasMore = true;

  bool get hasMore => _hasMore;

  set hasMore(value) => _hasMore = value ?? true;

  /// 排序参数
  int _order = 0;

  int get order => _order;

  set order(value) => _order = value ?? 0;

  /// 数据源当前状态信息
  String message;

  /// 数据源托管的实体数据
  T value;

  DataSource({T initValue, int page = 1, int pageSize = 10, int order = 0}) {
    this._page = page ?? 1;
    this._pageSize = pageSize ?? 10;
    this._order = order ?? 0;
    this.value = initValue;
  }

  /// 重新加载数据源
  Future<bool> reload() async {
    /// 重置内部状态
    this._page = 1;
    this._hasMore = true;
    this._total = null;

    /// 加载数据
    return await this.loadMore(reload: true);
  }

  /// 加载更多
  Future<bool> loadMore({bool reload = false}) async {
    if (_isloading) {
      return true;
    }

    if (!_hasMore) {
      return true;
    }

    this.message = null;

    _isloading = true;
    notifyListeners();

    try {
      final result = await onLoad(reload);

      if (result) {
        /// 修正当前页码
        this._page++;
      }
      return result;
    } finally {
      _isloading = false;
      notifyListeners();
    }

    print("DataSource finally ...");
    return false;
  }

  Future<bool> onLoad(bool isReload);
}
