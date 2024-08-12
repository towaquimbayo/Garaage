import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../data/models/chat/ai_diagnostic_request.dart';
import '../../../service_locator.dart';
import '../../repositories/ai_message.dart';

/// A use case for retrieving a diagnostic report based on a request.
class GetDiagnosticReport extends UseCase<Either, AiDiagnosticRequest> {
  @override
  Future<Either> call({AiDiagnosticRequest? params}) async {
    // Ensures that the parameters are not null and calls the repository to get the diagnostic report.
    return sl<AiMessageRepository>().getDiagnosticReport(params!);
  }
}
