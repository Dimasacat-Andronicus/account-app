import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeLoadingState()) {
    on<FetchAccountsEvent>(_onFetchAccounts);
    on<DeleteAccountEvent>(_onDeleteAccount);
  }

  Future<void> _onFetchAccounts(
    FetchAccountsEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final box = Hive.box('authBox');
      final accounts = box.get(
        'accounts',
        defaultValue: <Map<String, String>>[],
      );
      if (accounts is List) {
        final parsedAccounts =
            accounts
                .map((e) => Map<String, String>.from(e as Map))
                .where((account) => account['username'] != 'admin')
                .toList();
        emit(HomeLoadedState(parsedAccounts));
      } else {
        emit(HomeLoadedState([]));
      }
    } catch (e) {
      emit(HomeErrorState('Failed to fetch accounts: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteAccount(
    DeleteAccountEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final box = Hive.box('authBox');
      final accounts = box.get(
        'accounts',
        defaultValue: <Map<String, String>>[],
      );

      if (accounts is List) {
        final parsedAccounts =
            accounts.map((e) => Map<String, String>.from(e as Map)).toList();
        final filteredAccounts =
            parsedAccounts
                .where((account) => account['username'] != 'admin')
                .toList();

        final accountToDelete = filteredAccounts[event.index];
        final originalIndex = parsedAccounts.indexOf(accountToDelete);

        parsedAccounts.removeAt(originalIndex);
        await box.put('accounts', parsedAccounts);

        emit(
          HomeLoadedState(
            parsedAccounts
                .where((account) => account['username'] != 'admin')
                .toList(),
          ),
        );
      } else {
        emit(HomeErrorState('Accounts data is not in the expected format.'));
      }
    } catch (e) {
      emit(HomeErrorState('Failed to delete account: ${e.toString()}'));
    }
  }
}
