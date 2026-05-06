import 'package:dairysathi/features/notice_board/domain/repository/notice_board_repo.dart';

class UpdateNoticeUsecase {
  final NoticeBoardRepo noticeBoardRepo;

  UpdateNoticeUsecase(this.noticeBoardRepo);

  Future<Map> call(Map params) {
    return noticeBoardRepo.updateNoticePost(params);
  }
}
