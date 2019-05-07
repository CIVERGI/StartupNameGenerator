import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() {
    return RandomWordsState();
  }
}

//Esto hace referencia a una clase generica
class RandomWordsState extends State<RandomWords> {
  final List<WordPair> _suggestions = <WordPair>[];
  final Set<WordPair> _saved = Set<WordPair>(); // Stores the word pairing
  final TextStyle _biggerFont = const TextStyle(fontSize: 18);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list), 
            onPressed: _pushSaved, //Aqui nos cambiamos de pantalla con la llamada de este metodo
            ),
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
      //Crea una lista scrolleable la cual se rellena bajo demanda...
      // This constructor is appropriate for list views with a large (or infinite)
      // number of children because the builder is called only for those children that
      // are actually visible.
      padding: const EdgeInsets.all(16),
      itemBuilder: (BuildContext _context, int i) {
        //Este metodo es llamado cuando i sea mayor que 0...
        //Builder methods essentially create a widget once
        //for each piece of data in a Dart List.

        if (i.isOdd) {
          //Verifica que sea impar de una forma muy cool
          return Divider();
        }
        final int index = i ~/
            2; //Divide y retorna un resultado entero (Ignorando su residuo)
        // print('------------------------------');
        // print('i = $i');
        // print('index = $index');
        // print('suggestions length = ${_suggestions.length}');
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs()
              .take(10)); //La magia startupera se genera aqui!🔥🔥🔥
        }
        return _buildRow(_suggestions[index]);
      },
    );
  }

  Widget _buildRow(WordPair pair) {
    final bool alreadySaved =
        _saved.contains(pair); //Verifica si se encuentra guardado por _saved
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {//Llamada de funcion anonima
        setState(() {
          // Tip: In Flutter's reactive style framework, calling setState() triggers 
          // a call to the build() method for the State object, resulting in an update 
          // to the UI.


          if (alreadySaved) {
            _saved.remove(pair); //Accede a nuestra lista de atributos guardados y lo elimina
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  //Cuando se hace click en la lista 
  void _pushSaved(){
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context){
          final Iterable <ListTile> tiles = _saved.map(
            (WordPair pair){
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final List<Widget> divideed = ListTile.divideTiles(
            context: context,
            tiles: tiles
          )
          .toList();

          return Scaffold(
            appBar: AppBar(
              title: Text('Saved Suggestions'),
            ),
            body: ListView(children: divideed,),
          );
        }
      )
    );

  }
}
