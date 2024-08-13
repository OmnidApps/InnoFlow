import 'package:flutter/material.dart';
import '../data/models/workflow.dart';

class WorkflowCard extends StatelessWidget {
  final Workflow workflow;
  final VoidCallback onTap;

  const WorkflowCard({
    Key? key,
    required this.workflow,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                workflow.name,
                style: textTheme.titleLarge,
              ),
              SizedBox(height: 8.0),
              Text(
                workflow.description!,
                style: textTheme.bodyMedium,
              ),
              SizedBox(height: 8.0),
              // Chip(
              //   label: Text(workflow.category),
              //   backgroundColor: Colors.blueGrey[100],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}