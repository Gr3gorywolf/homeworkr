import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:homeworkr/constants/app.dart';
import 'package:homeworkr/helpers/alerts_helpers.dart';
import 'package:homeworkr/repository/user_repository.dart';
import 'package:homeworkr/stores/stores.dart';
import 'package:homeworkr/ui/widgets/custom_form_field.dart';
import 'package:homeworkr/ui/widgets/custom_icon_button.dart';
import 'package:homeworkr/ui/widgets/placeholder.dart';
import 'package:stripe_native/stripe_native.dart';

class StudentsForm extends StatefulWidget {
  @override
  _StudentsFormState createState() => _StudentsFormState();
}

class _StudentsFormState extends State<StudentsForm> {
  var _formKey = GlobalKey<FormState>();
  var _isLoading = false;
  int chargeAmount = 0;

  @override
  void initState() { 
    super.initState();
    if(!kIsWeb){
      initPayments();
    }
  }
  submitForm() async {
    setLoading(true);
    var isValid = _formKey.currentState.validate();
    if(chargeAmount < 200){
       AlertsHelpers.showErrorSnackbar(context,
          exception: Exception("El monto minimo es 200 DOP"));
          setLoading(false);
          return;
    }
    if (isValid) {
      await makeStripePayment((token) async {
        setLoading(true);
        var _user = Stores.userStore;
        var newAmount = _user.user.balance + chargeAmount;

        await UserRepository().setBalance(_user.user.uUID, newAmount);
        setLoading(false);
        AlertsHelpers.showAlert(context, "Fondos ingresados exitosamente",
            "Se han ingresado los fondos de manera correcta",
            acceptTitle: "Ok", cancelable: false, callback: () {
          Navigator.of(context).pop();
        });
      });
    }
    setLoading(false);
  }

  setLoading(bool val) {
    setState(() {
      _isLoading = val;
    });
  }

  initPayments() {
    StripeNative.setPublishableKey(AppConstants.kStripeToken);
    StripeNative.setCurrencyKey("DOP");
  }

  makeStripePayment(Function(String token) callback) async {
    try {
      var order = Order(chargeAmount.toDouble(), 0.0, 0.0, "Homeworkr");
      var token = await StripeNative.useNativePay(order);
      callback(token);
    } catch (err) {
      AlertsHelpers.showErrorSnackbar(context,
          exception: Exception("Falla al procesar el pago: " + err.message));
    }
  }

  @override
  Widget build(BuildContext context) {
    var _screen = MediaQuery.of(context).size;
    if (kIsWeb) {
      return CustomPlaceholder(
        "No disponible en web",
        Icons.close,
        subtitle:
            "Para ingresar balance necesita hacer la transferencia desde la aplicacion movil",
      );
    }

    return Form(
        key: _formKey,
        child: Center(
            child: Container(
                width: _screen.width * 0.8,
                padding: EdgeInsets.only(top: 25, bottom: 10),
                child: Column(children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.account_balance_wallet,
                            size: 40,
                            color: Colors.grey,
                          ),
                          Text(
                            "Ingresar fondos",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                                color: Colors.grey),
                          ),
                          Text(
                            "Nota: No se guardara ningun tipo de informacion referente a sus tarjetas de credito/debito. Toda esa informacion quedara almacenada en su wallet de google",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                          SizedBox(height: 22),
                          CustomFormField(
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.numberWithOptions(
                                decimal: false, signed: false),
                            validator: ValidationBuilder()
                                .required()
                                .maxLength(9)
                                .build(),
                            label: "Monto a ingresar",
                            initialValue: chargeAmount.toString(),
                            maxLines: 1,
                            minLines: 1,
                            onChanged: (text) => chargeAmount = int.parse(text),
                          ),
                          SizedBox(height: 22),
                        ],
                      ),
                    ),
                  ),
                  CustomIconButton(
                    isLoading: _isLoading,
                    onPressed: submitForm,
                    text: "Ingresar fondos",
                    textColor: Colors.white,
                    backgroundColor: Colors.teal,
                  )
                ]))));
  }
}
