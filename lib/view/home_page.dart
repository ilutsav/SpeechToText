import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SpeechToText _speechToText = SpeechToText();

  bool _speechEnabled = true;
  String wordsSpoken = "";
  double confidenceLevel = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSpeech();
  }

  void initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {
      confidenceLevel = 0;
    });
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(result) {
    setState(() {
      wordsSpoken = "${result.recognizedWords}";
      confidenceLevel = result.confidence;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Speech to text'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            children: [
              Container(
                child: Text(_speechToText.isListening
                    ? "listening..."
                    : _speechEnabled
                        ? "Tap the button and start speaking"
                        : "Speech not available"),
              ),
              Expanded(
                  child: Container(
                      child: Text(
                wordsSpoken,
              ))),
              if (_speechToText.isNotListening && confidenceLevel > 0)
                Text("Confidence : ${confidenceLevel.toStringAsFixed(2)}%"),
            ],
          ),
        ),
        floatingActionButton: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.red,
            child: IconButton(
              icon: Icon(
                  _speechToText.isNotListening ? Icons.mic_off : Icons.mic),
              tooltip: 'Listen',
              onPressed: () {
                _speechToText.isListening
                    ? _stopListening()
                    : _startListening();
              },
            )));
  }
}
