import 'package:flutter/material.dart';
import 'package:notes_app/data/local/db_helper.dart';

class HomePageScreen extends StatefulWidget {
  @override
  State<HomePageScreen> createState() => HomePageState();
}

class HomePageState extends State<HomePageScreen> {
  var titleController = TextEditingController();
  var descController = TextEditingController();

  List<Map<String, dynamic>> allNotes = [];
  DBHelper? dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = DBHelper.getInstance;
    getNotes();
  }

  void getNotes() async {
    allNotes = await dbRef!.getAllNotes();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Notes App"),
        centerTitle: true,
        backgroundColor: Colors.teal.shade600,
        elevation: 4,
      ),
      body: allNotes.isNotEmpty
          ? ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: allNotes.length,
        itemBuilder: (_, index) {
          return Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(
                  horizontal: 16, vertical: 12),
              title: Text(
                allNotes[index][DBHelper.COLUMN_TITLE],
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.teal.shade800),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Text(
                  allNotes[index][DBHelper.COLUMN_DESCRIPTION],
                  style: TextStyle(fontSize: 14),
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit,
                        color: Colors.green.shade700),
                    onPressed: () {
                      titleController.text =
                      allNotes[index][DBHelper.COLUMN_TITLE];
                      descController.text =
                      allNotes[index][DBHelper.COLUMN_DESCRIPTION];
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20))),
                        builder: (context) => getBottomSheetWidget(
                            isUpdate: true,
                            sno: allNotes[index]
                            [DBHelper.TABLE_COLUMN_SNO]),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      bool check = await dbRef!.deleteNote(
                          sno: allNotes[index]
                          [DBHelper.TABLE_COLUMN_SNO]);
                      if (check) getNotes();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      )
          : Center(
        child: Text(
          "No Notes yet!",
          style: TextStyle(
              fontSize: 18, color: Colors.grey.shade600),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          titleController.clear();
          descController.clear();
          bool check = await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20))),
            builder: (context) => getBottomSheetWidget(),
          );
          if (check) getNotes();
        },
        icon: Icon(Icons.add,color: Colors.white70,),
        label: Text("Add Note",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.teal.shade600,
      ),
    );
  }

  Widget getBottomSheetWidget({bool isUpdate = false, int sno = 0}) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 25,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isUpdate ? "Update Note" : "Add Note",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal.shade700),
            ),
            SizedBox(height: 20),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: "* Title",
                hintText: "Enter note title",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15)),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: descController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: "* Description",
                hintText: "Enter note description",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15)),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      var title = titleController.text.trim();
                      var desc = descController.text.trim();

                      if (title.isNotEmpty && desc.isNotEmpty) {
                        bool check = isUpdate
                            ? await dbRef!.updateNote(
                            mtitle: title, mDesc: desc, sno: sno)
                            : await dbRef!
                            .addNote(mtitle: title, mDesc: desc);

                        if (check) getNotes();

                        titleController.clear();
                        descController.clear();
                        Navigator.pop(context, true);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                            Text("Please fill all required fields"),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal.shade600,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    icon: Icon(isUpdate ? Icons.update : Icons.add,color: Colors.white,),
                    label: Text(isUpdate ? "Update Note" : "Add Note",style: TextStyle(color: Colors.white),),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text("Cancel"),
                    style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
