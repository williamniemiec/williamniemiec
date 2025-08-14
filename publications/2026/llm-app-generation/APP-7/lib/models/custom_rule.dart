import 'package:equatable/equatable.dart';

enum RuleType { block, allow }

class CustomRule extends Equatable {
  final String domain;
  final RuleType type;

  const CustomRule({
    required this.domain,
    required this.type,
  });

  @override
  List<Object?> get props => [domain, type];
}