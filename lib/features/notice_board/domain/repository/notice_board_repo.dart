abstract class NoticeBoardRepo {
  Future<Map> addNoticePost(Map params);
  Future<Map> updateNoticePost(Map params);
  Future<Map> getAllNoticesPost(String dairyId);
  Future<Map> deleteNoticePost(String noticeId);
}
