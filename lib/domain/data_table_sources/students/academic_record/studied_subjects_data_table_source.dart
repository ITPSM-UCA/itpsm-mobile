import 'package:data_table_2/data_table_2.dart';

class StudiedSubjectsAsyncDataTableSource extends AsyncDataTableSource {
  bool _empty = false;
  int? _errorCounter;

  StudiedSubjectsAsyncDataTableSource.empty() {
    _empty = true;
  }
  
  @override
  Future<AsyncRowsResponse> getRows(int start, int end) async {
    return AsyncRowsResponse(
      0, 
      []
    );
  }
}