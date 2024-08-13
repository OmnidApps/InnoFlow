import 'package:flutter/material.dart';
import '../data/models/usecase.dart';

// TODO: Use generic card widget
class UsecaseCard extends StatelessWidget {
  final Usecase usecase;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const UsecaseCard({
    Key? key,
    required this.usecase,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
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
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      usecase.name,
                      style: textTheme.titleLarge,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      usecase.description,
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onEdit,
                icon: Icon(Icons.edit),
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => _showDeleteConfirmation(context, usecase),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Usecase usecase) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Usecase'),
        content: Text('Are you sure you want to delete this usecase?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: onDelete,
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}