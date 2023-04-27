import 'package:flutter/cupertino.dart';
import 'package:image_upload/widgets/forms/register_form.dart';

import '../home/home.dart';

class UpdateClientForm extends StatelessWidget {

  const UpdateClientForm({super.key});

  @override
  Widget build(BuildContext context) {
    //TODO appbar
    return RegisterForm(toUpdateClient: Home.currentClient!,);
  }

}