import 'package:dairysathi/core/network/api_endpoints.dart';
import 'package:dio/dio.dart';

class NoticeDataSource {
  final Dio dio;

  NoticeDataSource(this.dio);

  Future<Map> addNoticePost(Map params) async {
    final response = await dio.post(ApiEndpoints.addNotice, data: params);
    return response.data;
  }

  Future<Map> updateNoticePost(Map params) async {
    final response = await dio.post(ApiEndpoints.updateNotice, data: params);
    return response.data;
  }

  Future<Map> getAllNoticesPost(String dairyId) async {
    final response = await dio.get(
      '${ApiEndpoints.getNotices}?dairy_id=$dairyId',
    );
    return response.data;
  }

  Future<Map> deleteNoticePost(String noticeId) async {
    final response = await dio.delete('${ApiEndpoints.deleteNotice}/$noticeId');
    return response.data;
  }
}
