// TODO: Extract to usecase_card

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../services/workflow_service.dart';
// import '../data/models/workflow.dart';
// 
// class WorkflowManager extends StatelessWidget {
//   final Widget Function(BuildContext context, WorkflowState state) builder;
// 
//   const WorkflowManager({Key? key, required this.builder}) : super(key: key);
// 
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<WorkflowService>(
//       builder: (context, workflowService, _) {
//         return builder(
//           context,
//           WorkflowState(
//             workflows: workflowService.workflows,
//             isLoading: workflowService.isLoading,
//             error: workflowService.error,
//             refreshWorkflows: workflowService.fetchWorkflows,
//             executeWorkflow: (workflowId) async {
//               try {
//                 await workflowService.executeWorkflow(workflowId);
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('Workflow executed successfully')),
//                 );
//               } catch (e) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('Failed to execute workflow: $e')),
//                 );
//               }
//             },
//           ),
//         );
//       },
//     );
//   }
// }
// 
// class WorkflowState {
//   final List<Workflow> workflows;
//   final bool isLoading;
//   final String? error;
//   final Future<void> Function() refreshWorkflows;
//   final Future<void> Function(String) executeWorkflow;
// 
//   WorkflowState({
//     required this.workflows,
//     required this.isLoading,
//     required this.error,
//     required this.refreshWorkflows,
//     required this.executeWorkflow,
//   });
// }