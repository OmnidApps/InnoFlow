import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/usecase_service.dart';
import '../services/workflow_service.dart';
import '../data/models/usecase.dart';
import '../data/models/workflow.dart';

// TODO: Rename to Usecase Screen.
// FIXME: Extract widget code.
class CreateUsecaseScreen extends StatefulWidget {
  final Usecase? editingUsecase;
  final Workflow? selectedWorkflow;

  CreateUsecaseScreen({this.editingUsecase, this.selectedWorkflow});

  @override
  _CreateUsecaseScreenState createState() => _CreateUsecaseScreenState();
}

class _CreateUsecaseScreenState extends State<CreateUsecaseScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final int _id;
  Workflow? _selectedWorkflow;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.editingUsecase?.name);
    _descriptionController = TextEditingController(text: widget.editingUsecase?.description);
    _id = widget.editingUsecase?.id ?? 0;
    // FIXME: Add selected workflow without duplicating objects from provider.
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void setSelectedWorkflow(Workflow? workflow) {
    _selectedWorkflow = workflow;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 32.0),
          Text(
            'Manage Usecase',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 24.0),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Name',
            ),
          ),
          SizedBox(height: 16.0),
          TextField(
            controller: _descriptionController,
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
                    child: Text(
                      workflow.name,
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ))
              .toList(),
            decoration: InputDecoration(
              labelText: 'Workflow',
            ),
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              final name = _nameController.text.trim();
              final description = _descriptionController.text.trim();
              if (name.isNotEmpty && description.isNotEmpty) {
                if (widget.editingUsecase == null) {
                  final usecase = Usecase(
                    name: name,
                    description: description,
                    workflowID: _selectedWorkflow?.id
                  );
                  Provider.of<UsecaseService>(context, listen: false)
                      .createUsecase(usecase);
                } else {
                  final updatedUsecase = widget.editingUsecase!.copyWith(
                    id: _id,
                    name: name,
                    description: description,
                    workflowID: _selectedWorkflow?.id
                  );
                  Provider.of<UsecaseService>(context, listen: false)
                      .updateUsecase(updatedUsecase);
                }
                Navigator.pop(context);
              }
            },
            child: Text(widget.editingUsecase == null ? 'Create' : 'Update'),
          ),
        ],
      ),
    );
  }
}