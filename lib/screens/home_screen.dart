import 'package:flutter/material.dart';
import 'package:innoflow/data/workflow_repository.dart';
import 'package:provider/provider.dart';
import '../data/models/workflow.dart';
import '../services/usecase_service.dart';
import '../services/workflow_service.dart';
import '../screens/create_usecase_screen.dart';
import '../widgets/usecase_card.dart';
import '../widgets/create_usecase.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Fetch usecases when the screen is first built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UsecaseService>(context, listen: false).fetchUsecases();
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('InnoFlow'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Consumer<UsecaseService>(
        builder: (context, usecaseService, child) {
          if (usecaseService.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (usecaseService.error != null) {
            return Center(child: Text(usecaseService.error!));
          }

          if (usecaseService.usecases.isEmpty) {
            return Center(
              child: Text(
                'No usecases available',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 18,
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: usecaseService.fetchUsecases,
            child: ListView.builder(
              itemCount: usecaseService.usecases.length,
              itemBuilder: (context, index) {
                final usecase = usecaseService.usecases[index];
                return UsecaseCard(
                  usecase: usecase,
                  onTap: () {

                  },
                  onEdit: () async {
                    final createUsecaseWidget = context.read<CreateUsecaseWidget>();
                    createUsecaseWidget.setEditingUsecase(usecase);
                    // TODO: This needs cleanup.
                    Workflow? workflow = await context.read<WorkflowService>().getById(usecase.workflowID ?? 0);
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => CreateUsecaseScreen(
                        editingUsecase: usecase,
                        selectedWorkflow: workflow,
                      ),
                    );
                  },
                  onDelete: () {
                    context.read<UsecaseService>().deleteUsecase(usecase);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final createUsecaseWidget =
              Provider.of<CreateUsecaseWidget>(context, listen: false);
          createUsecaseWidget.setEditingUsecase(null);
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => CreateUsecaseScreen(editingUsecase: null),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}