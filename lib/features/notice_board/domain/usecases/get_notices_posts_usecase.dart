import 'package:dairysathi/features/notice_board/domain/repository/notice_board_repo.dart';

class GetNoticesPostsUsecase {
  final NoticeBoardRepo noticeBoardRepo;

  GetNoticesPostsUsecase(this.noticeBoardRepo);

  Future<Map> call(String dairyId) {
    return noticeBoardRepo.getAllNoticesPost(dairyId);
  }
}
