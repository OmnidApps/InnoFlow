import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/usecase_service.dart';
import '../services/workflow_service.dart';
import '../data/models/usecase.dart';
import '../data/models/workflow.dart';

class CreateUsecaseWidget extends ChangeNotifier {
  Usecase? _editingUsecase;
  Workflow? _selectedWorkflow;

  Usecase? get editingUsecase => _editingUsecase;
  Workflow? get selectedWorkflow => _selectedWorkflow;

  void setEditingUsecase(Usecase? usecase) {
    _editingUsecase = usecase;
    notifyListeners();
  }

  void setSelectedWorkflow(Workflow? workflow) {
    _selectedWorkflow = workflow;
    notifyListeners();
  }

  String _name = '';
  String _description = '';

  void _handleCreateOrUpdate(BuildContext context) {
    if (_name.isNotEmpty && _description.isNotEmpty) {
      final usecase = _editingUsecase ?? Usecase(name: _name, description: _description);
        if (_editingUsecase == null) {
        UsecaseService usecaseService = Provider.of<UsecaseService>(context, listen: false);
        usecaseService.createUsecase(usecase);
      } else {
        final updatedUsecase = Usecase(
          id: _editingUsecase!.id,
          name: _name,
          description: _description,
          workflowID: _selectedWorkflow?.id,
        );
        Provider.of<UsecaseService>(context, listen: false).updateUsecase(updatedUsecase);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            onChanged: (value) => _name = value,
            decoration: InputDecoration(
              labelText: 'Name',
            ),
          ),
          SizedBox(height: 16.0),
          TextField(
            onChanged: (value) => _description = value,
            decoration: InputDecoration(
              labelText: 'Description',
            ),
            maxLines: 3,
          ),
          SizedBox(height: 16.0),
          DropdownButtonFormField<Workflow>(
            value: _selectedWorkflow,
            onChanged: (workflow) => setSelectedWorkflow(workflow),
            items: Provider.of<WorkflowService>(context, listen: false)
                .workflows
                .map((workflow) => DropdownMenuItem<Workflow>(
                      value: workflow,
                      child: Text(workflow.name),
                    ))
                .toList(),
            decoration: InputDecoration(
              labelText: 'Workflow',
            ),
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () => _handleCreateOrUpdate(context),
            child: Text(_editingUsecase == null ? 'Create' : 'Update'),
          ),
        ],
      ),
    );
  }
}