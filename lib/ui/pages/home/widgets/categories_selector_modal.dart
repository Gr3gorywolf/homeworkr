import 'package:flutter/material.dart';
import 'package:homeworkr/helpers/alerts_helpers.dart';
import 'package:homeworkr/repository/register_repository.dart';
import 'package:homeworkr/stores/stores.dart';
import 'package:homeworkr/ui/widgets/custom_icon_button.dart';

class CategoriesSelectorModal extends StatefulWidget {
  CategoriesSelectorModal({Key key}) : super(key: key);

  static show(BuildContext context) {
    print("pase");
    Future.delayed(Duration(milliseconds: 200)).then((value) {
      showModalBottomSheet(
          context: context,
          isDismissible: false,
          enableDrag: false,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          builder: (ctx) {
            return WillPopScope(
                onWillPop: () {}, child: CategoriesSelectorModal());
          });
    });
  }

  @override
  _CategoriesSelectorModalState createState() =>
      _CategoriesSelectorModalState();
}

class _CategoriesSelectorModalState extends State<CategoriesSelectorModal> {
  var _isLoading = false;
  List<String> _selectedItems = [];
  completeProfile() async {
    if (_selectedItems.length > 0) {
      setLoading(true);
      try {
        await RegisterRepository().setUserPreferredCategories(_selectedItems);
        Navigator.of(context).pop();
      } catch (err) {
        print(err);
        AlertsHelpers.showErrorSnackbar(context,
            exception: Exception("Error al actualizar las categorias"));
      }
      setLoading(false);
    } else {
      AlertsHelpers.showErrorSnackbar(context,
          exception: Exception("Debe seleccionar almenos una materia"));
    }
  }

  setLoading(bool val) {
    setState(() {
      _isLoading = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        child: Column(
          children: [
            Text(
              "En que materias se desempeña",
              style: TextStyle(fontSize: 19),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CategoriesList((selection) {
                  setState(() {
                    _selectedItems = selection;
                  });
                }),
              ),
            ),
            CustomIconButton(
              isLoading: _isLoading,
              onPressed: () {
                completeProfile();
              },
              text: "Completar registro",
              textColor: Colors.white,
              backgroundColor: Colors.teal,
            )
          ],
        ),
      ),
    );
  }
}

class CategoriesList extends StatefulWidget {
  Function(List<String>) onChange;
  CategoriesList(this.onChange);
  @override
  _CategoriesListState createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  List<String> _selectedItems = [];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: Stores.subjectStore.subjects.length,
        itemBuilder: (BuildContext context, int index) {
          var item = Stores.subjectStore.subjects[index];
          var containsItem = _selectedItems.contains(item);
          return new Card(
            child: new Container(
              padding: new EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  new CheckboxListTile(
                      activeColor: Colors.teal,
                      dense: true,
                      //font change
                      title: new Text(
                        item,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5),
                      ),
                      value: _selectedItems.contains(item),
                      onChanged: (bool val) {
                        if (containsItem) {
                          _selectedItems.remove(item);
                        } else {
                          _selectedItems.add(item);
                        }
                        widget.onChange(_selectedItems);
                        setState(() {
                          _selectedItems;
                        });
                      })
                ],
              ),
            ),
          );
        });
  }
}
