import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

const _name = 'Jose Alvarado';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
  return CupertinoApp(
    title: 'Chat',
    home: ChatScreen()
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  State createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final _navigationBarBackgroundColor = Color.fromRGBO(20, 20, 20, 1);
  final _navigationBarTextColor = Color.fromRGBO(255, 255, 255, 1);

  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = TextEditingController();
  bool _isComposing = false;

  void _handleSubmitted(String text) {
    ChatMessage message = ChatMessage(
      text: text,
      animationController: AnimationController(
        duration: Duration(milliseconds: 500),
        vsync: this,
      ),
    );
    setState(() {
      _messages.insert(0, message);
      _isComposing = false;
    });
    message.animationController.forward();
    _textController.clear();
  }

  void dispose() {
    for(ChatMessage message in _messages)
      message.animationController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: _navigationBarBackgroundColor,
        middle: Text(
          'Mi primer chat en Flutter',
          style: TextStyle(
            color: _navigationBarTextColor,
          ),),
      ),
      child: Container(
        child: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                padding: EdgeInsets.all(8.0),
                reverse: true,
                itemBuilder: (_, int index) => _messages[index],
                itemCount: _messages.length,
              )
            ),
            Divider(height: 1.0),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor
              ),
              child: _buildTextComposer(),
            ),
          ]
        ),
      ),
    );
  }

  Widget _buildTextComposer() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          Flexible(
            child: CupertinoTextField(
              controller: _textController,
              onSubmitted: _handleSubmitted,
              placeholder: 'Escribir un mensaje',
              onChanged: (String text) {
                setState(() {
                  _isComposing = text.length > 0;
                });
              },
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.0),
            child: CupertinoButton(
              child: Icon(Icons.send),
              onPressed: () => _isComposing ? _handleSubmitted(_textController.text) : null,
            ),
          )
        ],
      )
    );
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage({ this.text, this.animationController });
  final String text;
  final AnimationController animationController;
  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(
        parent: animationController,
        // Animation Effect
        curve: Curves.easeOut
      ),
      axisAlignment: 0.0,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                child: Text(_name[0]),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(_name, style: Theme.of(context).textTheme.subhead),
                  Container(
                    margin: EdgeInsets.only(top: 5.0),
                    child: Text(text)
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}