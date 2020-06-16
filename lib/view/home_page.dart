import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static String tag = '/home';

  @override
  Widget build(BuildContext context) {
    var snapshots = Firestore.instance
        .collection('todo')
        .where('excluido', isEqualTo: false)
        .orderBy('data')
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text('CRUD Firebase'),
      ),
      body: StreamBuilder(
        stream: snapshots,
        builder: (
          BuildContext context,
          AsyncSnapshot<QuerySnapshot> snapshot,
        ) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data.documents.length == 0) {
            return Center(child: Text('Nenhuma tarefa ainda'));
          }

          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (BuildContext context, int i) {
              var item = snapshot.data.documents[i].data;

              return ListTile(
                leading: IconButton(
                  icon: Icon(
                    item['feito']
                        ? Icons.check_circle
                        : Icons.check_circle_outline,
                    size: 32,
                  ),
                  onPressed: () => null,
                ),
                title: Text(item['titulo']),
                subtitle: Text(item['descricao']),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => null,
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => null,
        tooltip: 'Adicionar novo',
        child: Icon(Icons.add),
      ),
    );
  }
}
