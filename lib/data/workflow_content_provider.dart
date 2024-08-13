import 'package:android_content_provider/android_content_provider.dart';
import 'package:innoflow/data/models/workflow.dart';
import 'package:innoflow/data/workflow_repository.dart';

class WorkflowCursor implements CursorData {
  final List<Workflow> data;
  final int count;
  final List<String> notificationUris;

  WorkflowCursor({
    required this.data,
    required this.count,
    required this.notificationUris,
  });

  @override
  int get length => count;

  @override
  Workflow getAt(int index) => data[index];

  @override
  Map<String, dynamic> toMap() => {};

  @override
  Map<String, dynamic> get extras => {};

  @override
  dynamic get payload => null;

  @override
  set extras(Map<String, Object?>? value) {}
}

class WorkflowContentProvider extends AndroidContentProvider {
  static const String AUTHORITY = 'com.omnidapps.innoflow.WorkflowContentProvider';
  static const String PATH = 'workflows';

  final WorkflowRepository _workflowRepository;

  WorkflowContentProvider({required WorkflowRepository workflowRepository})
      : _workflowRepository = workflowRepository,
        super(AUTHORITY);

  @override
  String get authority => AUTHORITY;

  String get path => PATH;

  @override
  Future<String?> getType(String uri) async {
    return 'vnd.android.cursor.dir/vnd.com.omnidapps.innoflow';
  }

  @override
  Future<CursorData?> query(String uri, List<String>? projection, String? selection, List<String>? selectionArgs, String? sortOrder) async {
    final workflowMaps = await _workflowRepository.query();
    final workflows = workflowMaps.map((map) => Workflow.fromMap(map)).toList();
    return WorkflowCursor(
      data: workflows,
      count: workflows.length,
      notificationUris: ['$AUTHORITY/$PATH'],
    );
  }

  @override
  Future<String?> insert(String uri, ContentValues? values) async {
    final Map<String, dynamic> valuesMap = values != null
        ? Map.fromEntries(values.entries)
        : {};
    final id = await _workflowRepository.insert(valuesMap);
    return '$AUTHORITY/$PATH/$id';
  }

  @override
  Future<int> update(String uri, ContentValues? values, String? selection, List<String>? selectionArgs) async {
    final Map<String, dynamic> valuesMap = values != null
        ? Map.fromEntries(values.entries)
        : {};
    return await _workflowRepository.update(valuesMap, selection ?? '', selectionArgs ?? []);
  }

  @override
  Future<int> delete(String uri, String? selection, List<String>? selectionArgs) async {
    return await _workflowRepository.delete(selection ?? '', selectionArgs ?? []);
  }
}