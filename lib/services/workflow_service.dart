import 'dart:async';
import 'package:flutter/foundation.dart';
import '../data/models/workflow.dart';
import '../data/workflow_repository.dart';

class WorkflowService extends ChangeNotifier {
  final WorkflowRepository _workflowRepository;

  List<Workflow> _workflows = [];
  bool _isLoading = false;
  String? _error;

  WorkflowService({required WorkflowRepository repository})
      : _workflowRepository = repository;

  List<Workflow> get workflows => _workflows;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchWorkflows() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _workflows = await _workflowRepository.getAll();
      print(_workflows);
      _isLoading = false;
    } catch (e) {
      _error = 'Failed to fetch workflows: $e';
      print(_error);
      _isLoading = false;
    }
    notifyListeners();
  }
  
  Future<Workflow?> getById(int id) async {
    return await _workflowRepository.getById(id);
  }
}

// TODO: If llamalab decides to help us, this will be helpful.

// import 'dart:convert';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/services.dart';
// import '../data/models/workflow.dart';
// 
// class WorkflowService extends ChangeNotifier {
//   static const MethodChannel _channel = MethodChannel('com.omnidapps.innoflow/workflows');
//   WorkflowService() {
//     _channel.setMethodCallHandler(_handleMethod);
//   }
// 
//   List<Workflow> _workflows = [];
//   bool _isLoading = false;
//   String? _error;
// 
//   List<Workflow> get workflows => _workflows;
//   bool get isLoading => _isLoading;
//   String? get error => _error;
// 
//   Future<void> fetchWorkflows() async {
//     _isLoading = true;
//     _error = null;
//     notifyListeners();
// 
//     try {
//       final List<dynamic> result = await _channel.invokeMethod('getWorkflows');
//       _workflows = result.map((item) => Workflow.fromMap(json.decode(item))).toList();
//       _isLoading = false;
//     } on PlatformException catch (e) {
//       _error = 'Failed to fetch workflows: ${e.message}';
//       _isLoading = false;
//     } catch (e) {
//       _error = 'Unexpected error: ${e.toString()}';
//       _isLoading = false;
//     }
//     notifyListeners();
//   }
// 
//   Future<void> executeWorkflow(String workflowId) async {
//     try {
//       await _channel.invokeMethod('executeWorkflow', {'id': workflowId});
//     } on PlatformException catch (e) {
//       _error = 'Failed to execute workflow: ${e.message}';
//       notifyListeners();
//     } catch (e) {
//       _error = 'Unexpected error: ${e.toString()}';
//       notifyListeners();
//     }
//   }
// 
//   Future<void> _handleMethod(MethodCall call) async {
//     switch (call.method) {
//       case 'updateWorkflows':
//         final List<dynamic> workflowsJson = jsonDecode(call.arguments);
//         _workflows = workflowsJson.map((json) => Workflow.fromMap(json)).toList();
//         _isLoading = false;
//         notifyListeners();
//         break;
//     }
//   }
// }