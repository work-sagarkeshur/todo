import 'package:flutter/material.dart';
import 'package:todo/models/plan.dart';
import 'package:todo/models/task.dart';
import 'package:todo/path_provider.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  Plan plan = const Plan();
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController()
      ..addListener(() {
        FocusScope.of(context).requestFocus(FocusNode());
      });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Master Plan')),
      body: ValueListenableBuilder<Plan>(
        valueListenable: PlanProvider.of(context),
        builder: (context, plan, child) {
          return Column(
            children: [
              Expanded(child: _buildList(plan)),
              SafeArea(child: Text(plan.completenessMessage)),
            ],
          );
        },
      ),
      floatingActionButton: _buildAddTaskButton(),
    );
  }

  Widget _buildList(Plan plan) {
    return SafeArea(
      child: ListView.builder(
        itemCount: plan.tasks.length,
        controller: scrollController,
        keyboardDismissBehavior:
            Theme.of(context).platform == TargetPlatform.iOS
                ? ScrollViewKeyboardDismissBehavior.onDrag
                : ScrollViewKeyboardDismissBehavior.manual,
        itemBuilder: (context, index) =>
            _buildTaskTile(plan.tasks[index], index),
      ),
    );
  }

  Widget _buildTaskTile(Task task, int index) {
    ValueNotifier<Plan> planNotifier = PlanProvider.of(context);

    return ListTile(
      leading: Checkbox(
        value: task.complete,
        onChanged: (selected) {
          ///new code
          Plan currentPlan = planNotifier.value;

          planNotifier.value = Plan(
            name: currentPlan.name,
            tasks: List<Task>.from(currentPlan.tasks)
              ..[index] = Task(
                complete: selected ?? false,
                description: task.description,
              ),
          );

          ///Old code
          // setState(() {
          //   plan = Plan(
          //     name: plan.name,
          //     tasks: List<Task>.from(plan.tasks)
          //       ..[index] = Task(
          //         description: task.description,
          //         complete: selected ?? false,
          //       ),
          //   );
          // });
        },
      ),
      title: TextFormField(
        initialValue: task.description,
        onChanged: (text) {
          ///new code
          Plan currentPlan = planNotifier.value;
          planNotifier.value = Plan(
            name: currentPlan.name,
            tasks: List<Task>.from(currentPlan.tasks)
              ..[index] = Task(
                complete: task.complete,
                description: text,
              ),
          );

          ///old code
          // setState(
          //   () {
          //     plan = Plan(
          //       name: plan.name,
          //       tasks: List<Task>.from(plan.tasks)
          //         ..[index] = Task(
          //           description: text,
          //           complete: task.complete,
          //         ),
          //     );
          // },
          // );
        },
      ),
    );
  }

  Widget _buildAddTaskButton() {
    ValueNotifier<Plan> planNotifier = PlanProvider.of(context);

    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        ///new code with value notifier
        Plan currentPlan = planNotifier.value;
        planNotifier.value = Plan(
          name: currentPlan.name,
          tasks: List<Task>.from(currentPlan.tasks)..add(Task()),
        );

        ///Old code
        // setState(() {
        //   plan = Plan(
        //     name: plan.name,
        //     tasks: List<Task>.from(plan.tasks)..add(Task()),
        //   );
        // });
      },
    );
  }
}
