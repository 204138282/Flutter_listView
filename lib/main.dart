import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Welcome to flutter',
        home: new RandomWords(),
        theme: new ThemeData(
          primaryColor: Colors.blue
        ),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  createState() => new RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final _save = new Set<WordPair>();//存储用户喜欢（收藏）的单词对

  @override
  Widget build(BuildContext context) {
    // final wordPair = new WordPair.random();
    // return new Text(wordPair.asPascalCase);
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Startup Name Generator'),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.list), onPressed: _pushSaved)],
      ),
      body: _buildSuggestions(),
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) {
          final tiles = _save.map(
            (pair) {
              return new ListTile(
                title: new Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            }
          );
          final divided = ListTile
          .divideTiles(
            context: context,
            tiles: tiles
          )
          .toList();

          return new Scaffold(
            appBar: new AppBar(
              title: new Text('Saved Suggestions')
            ),
            body: new ListView(children: divided),
          );
        }
      )
    );
  }

  Widget _buildSuggestions() {
    return new ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        //在每一列之前,添加1像素高的分隔线widget
        if (i.isOdd) return new Divider();

        /*
        >:  语法'i ~/ 2表示 i除以2,但返回值是整数(向下取整), 如i为:1,2,3,4,5,结果为0,1,1,2,2',
        >:  这可以计算出ListView中减去分隔线后的实际单词对数量
        */
        final index = i ~/ 2;

        if (index >= _suggestions.length) {
          // 如果是建议列表中最后一个单词对
          _suggestions.addAll(generateWordPairs().take(10)); // ...接着再生成10个单词对，然后添加到建议列表
        }
        return _buildRow(_suggestions[index]);
      },
    );
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _save.contains(pair);//确保wordPair(单词对)还没有被添加到收藏夹中
    return new ListTile(
      title: new Text(
        pair.asPascalCase,
        style: _biggerFont
      ),
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null 
      ),
      onTap: () {
        //提示: 在Flutter的响应式风格的框架中，调用setState() 会为State对象触发build()方法，从而导致对UI的更新
        setState(() {
          if (alreadySaved) {
            _save.remove(pair);
          } else {
            _save.add(pair);
          }
        });
      },
    );
  }
}
