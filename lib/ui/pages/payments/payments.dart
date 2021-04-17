import 'package:flutter/material.dart';
import 'package:flutter_store/provider.dart';
import 'package:homeworkr/models/user.dart';
import 'package:homeworkr/stores/stores.dart';
import 'package:homeworkr/ui/pages/payments/widgets/mentors_form.dart';
import 'package:homeworkr/ui/pages/payments/widgets/students_form.dart';

class PaymentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      store: Stores.userStore,
      child: Builder(builder: (ctx) {
        var _user = Stores.useUserStore(ctx);
        return Scaffold(
          appBar: AppBar(
            title: Text(_user.userRole == UserRoles.mentor
                ? "Retirar fondos"
                : "Ingresar fondos"),
          ),
          body: _user.userRole == UserRoles.mentor
              ? MentorsForm()
              : StudentsForm(),
        );
      }),
    );
  }
}
