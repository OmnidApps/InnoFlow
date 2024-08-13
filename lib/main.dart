import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/usecase_repository.dart';
import 'data/workflow_repository.dart';
import 'data/workflow_content_provider.dart';
import 'services/usecase_service.dart';
import 'services/workflow_service.dart';
import 'screens/home_screen.dart';
import 'widgets/create_usecase.dart';

@pragma('vm:entry-point')
void workflowContentProviderEntrypoint() {
  final workflowRepository = WorkflowRepository();
  WorkflowContentProvider(workflowRepository: workflowRepository);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: Extract out the intialization of the repositories
  WorkflowRepository workflowRepository = WorkflowRepository();
  await workflowRepository.createTable();
  // FIXME: mutiple workflow repositories created currently.
  workflowContentProviderEntrypoint();

  UsecaseRepository usecaseRepository = UsecaseRepository();
  await usecaseRepository.createTable();

  WorkflowService workflowService = WorkflowService(repository: workflowRepository);
  await workflowService.fetchWorkflows();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<UsecaseService>(
          create: (_) => UsecaseService(repository: usecaseRepository),
        ),
        ChangeNotifierProvider<WorkflowService>(create: (_) => workflowService),
        ChangeNotifierProvider<CreateUsecaseWidget>(create: (_) => CreateUsecaseWidget()),
      ],
      child: InnoflowApp(),
    ),
  );
}

class InnoflowApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InnoFlow',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}