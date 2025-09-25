import 'package:flutter/material.dart';
import 'package:ugcworks/repositories/collaborations-repository.dart';


class EarningsOverviewViewModel extends ChangeNotifier {
  final CollaborationsRepository collaborationsRepository;

  EarningsOverviewViewModel({required this.collaborationsRepository}) {
    collaborationsRepository.addListener(_onRepositoryChanged);
  }

  void _onRepositoryChanged() {
    notifyListeners();
  }

  List<EarningsEntryViewModelFields> get entries {
    return collaborationsRepository.collaborations
        .map((collab) => EarningsEntryViewModelFields(
              date: collab.deadline.date,
              title: collab.title,
              brand: collab.partner.companyName,
              amount: collab.fee.amount,
            ))
        .toList();
  }

  @override
  void dispose() {
    collaborationsRepository.removeListener(_onRepositoryChanged);
    super.dispose();
  }
}

class EarningsEntryViewModelFields {
  final DateTime date;
  final String title;
  final String brand;
  final double amount;

  EarningsEntryViewModelFields({
    required this.date,
    required this.title,
    required this.brand,
    required this.amount,
  });
}
