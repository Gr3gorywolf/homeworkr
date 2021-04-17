import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:homeworkr/helpers/alerts_helpers.dart';
import 'package:homeworkr/stores/stores.dart';
import 'package:homeworkr/ui/widgets/custom_form_field.dart';
import 'package:homeworkr/ui/widgets/custom_icon_button.dart';

class MentorsForm extends StatefulWidget {
  @override
  _MentorsFormState createState() => _MentorsFormState();
}

class _MentorsFormState extends State<MentorsForm> {
  var _formKey = GlobalKey<FormState>();
  var _withdraw_amount = 0.0;
  var _selectedBank = "";
  var banks = [
    "BanReservas",
    "Banco Agrícola"
        "Banco Popular Dominicano",
    "Banco BHD León",
    "Banco Vimenca",
    "Banco Santa Cruz",
    "Banco Caribe",
    "Banco BDI",
    "Banco López de Haro",
    "Banco Ademi",
    "Banco BELLBANK",
    "Banco Múltiple Activo Dominicana",
    "Scotiabank",
    "Citibank",
    "Banco Promerica",
    "Banesco",
    "Bancamerica",
    "Banco Atlántico",
    "Banco Bancotui",
    "Banco BDA",
    "Banco Adopem",
    "Banco Agrícola De La República Dominicana",
    "Banco Pyme Bhd",
    "Banco Capital",
    "Banco Confisa",
    "Banco Empire",
    "Banco Motor Crédito",
    "Banco Rio",
    "Banco Del Caribe",
    "Banco Inmobiliario (Banaci)",
    "Banco Gruficorp",
    "Banco Cofaci",
    "Banco Bonanza",
    "Banco Fihogar",
    "Banco Federal",
    "Banco Micro",
    "Banco Union",
    "Asociación Popular",
    "Asociación Popular de Ahorros y Préstamos",
    "Asociación Cibao",
    "Asociación Nortena",
    "Asociación Peravia",
    "Asociación Romana",
    "Asociación Higuamo",
    "Asociación La Vega Real",
    "Asociación Duarte",
    "Asociación Barahona",
    "Asociación Maguana",
    "Asociación Mocana",
    "Asociación Bonao",
    "Asociación La Nacional"
  ];
  var _isLoading = false;

  @override
  void initState() { 
    super.initState();
    _selectedBank = banks[0];
  }
  setLoading(bool val) {
    setState(() {
      _isLoading = val;
    });
  }

  submitForm() async {
    var isValid = _formKey.currentState.validate();
    if (_withdraw_amount > Stores.userStore.user.balance) {
      AlertsHelpers.showSnackbar(
          context, "El monto no puede ser mayor a su balance",
          title: "Error");
      return;
    }
    var discounted_amount = (_withdraw_amount * .10);
    var netValue = _withdraw_amount - discounted_amount;
    if (isValid) {
      AlertsHelpers.showAlert(
          context,
          "Advertencia",
          "Al realizar este retiro se le descontaran " +
              discounted_amount.toString() +
              "DOP (10%) dando un total de: " +
              netValue.toString() +
              "DOP",
          acceptTitle: "Entendido",
          cancelable: true,
          callback: processPayment);
    }
  }

  processPayment() async {
    setLoading(true);
    await Future.delayed(Duration(seconds: 1));
    AlertsHelpers.showAlert(context, "Exito",
        "La solicitud fue enviada exitosamente. En un plazo de 24 horas se procesara su retiro y se le descontara el balance",
        cancelable: false, acceptTitle: "Entendido", callback: () {
      Navigator.of(context).pop();
    });

    setLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    var _screen = MediaQuery.of(context).size;
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
                          Text(
                            "Enviar solicitud de retiro de fondos",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 30),
                          ),
                          SizedBox(height: 22),
                          CustomFormField(
                            textInputAction: TextInputAction.next,
                            validator: ValidationBuilder()
                                .required()
                                .minLength(4)
                                .maxLength(24)
                                .build(),
                            label: "Numero de cuenta",
                            maxLength: 24,
                            onChanged: (text) => "",
                          ),
                          SizedBox(height: 22),
                          InputDecorator(
                            decoration: CustomFormField.decorator("Banco"),
                            child: DropdownButton<String>(
                                underline: Container(),
                                isDense: true,
                                isExpanded: true,
                                value: banks[0],
                                items: banks.map((String value) {
                                  return new DropdownMenuItem<String>(
                                    value: value,
                                    child: new Text(value),
                                  );
                                }).toList(),
                                onChanged: (_) {
                                  setState(() {
                                    _selectedBank = _;
                                  });
                                }),
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
                            label: "Monto a retirar",
                            initialValue: "0",
                            maxLines: 1,
                            minLines: 1,
                            onChanged: (text) =>
                                _withdraw_amount = double.parse(text),
                          ),
                          SizedBox(height: 22),
                          CustomFormField(
                            textInputAction: TextInputAction.done,
                            validator:
                                ValidationBuilder().maxLength(180).build(),
                            label: "Notas adicionales",
                            maxLength: 180,
                            maxLines: 5,
                            minLines: 5,
                            onChanged: (text) => "",
                          ),
                          SizedBox(height: 22),
                        ],
                      ),
                    ),
                  ),
                  CustomIconButton(
                    isLoading: _isLoading,
                    onPressed: submitForm,
                    text: "Enviar solicitud de retiro",
                    textColor: Colors.white,
                    backgroundColor: Colors.teal,
                  )
                ]))));
  }
}
