import 'package:DairyVikas/features/notice_board/data/datasources/notice_ds.dart';
import 'package:DairyVikas/features/notice_board/domain/repository/notice_board_repo.dart';

class NoticeBoardRepoImpl implements NoticeBoardRepo {
  final NoticeDataSource noticeDataSource;

  NoticeBoardRepoImpl(this.noticeDataSource);
  @override
  Future<Map> addNoticePost(Map params) async {
    return await noticeDataSource.addNoticePost(params);
  }

  @override
  Future<Map> deleteNoticePost(String noticeId) async {
    return await noticeDataSource.deleteNoticePost(noticeId);
  }

  @override
  Future<Map> getAllNoticesPost(String dairyId) async {
    return await noticeDataSource.getAllNoticesPost(dairyId);
  }

  @override
  Future<Map> updateNoticePost(Map params) async {
    return await noticeDataSource.updateNoticePost(params);
  }
}
