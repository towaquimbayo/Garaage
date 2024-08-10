import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../data/models/chat/ai_diagnostic_request.dart';
import '../../../service_locator.dart';
import '../../repositories/ai_message.dart';

class GetDiagnosticReport extends UseCase<Either, AiDiagnosticRequest> {
  @override
  Future<Either> call({AiDiagnosticRequest? params}) async {
    return sl<AiMessageRepository>().getDiagnosticReport(params!);
  }
}
