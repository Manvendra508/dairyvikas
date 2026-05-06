import 'package:dairysathi/features/notice_board/domain/repository/notice_board_repo.dart';

class DeleteNoticePostUsecase {
  final NoticeBoardRepo noticeBoardRepo;

  DeleteNoticePostUsecase(this.noticeBoardRepo);

  Future<Map> call(String noticeId) {
    return noticeBoardRepo.deleteNoticePost(noticeId);
  }
}
