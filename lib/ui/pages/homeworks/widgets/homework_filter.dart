import 'package:flutter/material.dart';
import 'package:homeworkr/models/homework.dart';

class HomeworkFilter extends StatefulWidget {
  List<String> categories;
  Function(String) onSelectionChanged;
  String selectedItem;
  HomeworkFilter(
      {@required this.categories,
      @required this.onSelectionChanged,
      this.selectedItem});
  @override
  _HomeworkFilterState createState() => _HomeworkFilterState();
}

class _HomeworkFilterState extends State<HomeworkFilter> {
  String _selectedCategory;

  Widget getText(String text) {
    return Text(
      traslateHomeworkStatus(text),
      style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.bold),
    );
  }

  List<String> getCategories() {
    return [
      ...["Todas"],
      ...widget.categories
    ];
  }

  handleSelected(String cat) {
    setState(() {
      _selectedCategory = cat;
    });
    widget.onSelectionChanged(cat);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      if (widget.selectedItem == null) {
        _selectedCategory = getCategories()[0];
      } else {
        _selectedCategory = widget.selectedItem;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: getCategories().map((e) {
            if (e == _selectedCategory) {
              return InkWell(
                onTap: () {
                  handleSelected(e);
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: getText(e),
                  ),
                ),
              );
            } else {
              return InkWell(
                onTap: () {
                  handleSelected(e);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: getText(e),
                ),
              );
            }
          }).toList(),
        ));
  }
}
