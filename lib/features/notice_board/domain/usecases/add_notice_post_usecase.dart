import 'package:DairyVikas/features/notice_board/domain/repository/notice_board_repo.dart';

class AddNoticePostUsecase {
  final NoticeBoardRepo noticeBoardRepo;

  AddNoticePostUsecase(this.noticeBoardRepo);

  Future<Map> call(Map params) {
    return noticeBoardRepo.addNoticePost(params);
  }
}
