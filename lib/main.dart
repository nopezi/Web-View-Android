import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

void main() => runApp(
    MaterialApp(
        home: MyApp(),
        debugShowCheckedModeBanner: false,
    )
);

class MyApp extends StatefulWidget {
  final String title;

  MyApp({Key key, this.title}) : super(key:key);

  @override
  State<StatefulWidget> createState(){
    return _MyApp();
  }
}

class _MyApp extends State<MyApp> {

  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text('Griya Sedekah'),
        actions: <Widget>[NavigationControls(_controller.future)],
        backgroundColor: Color.fromRGBO(36, 75, 160, 1.0),
      ),
      body: Builder(
        builder: (BuildContext context){
          return WebView(
            initialUrl: "https://griyasedekah.com/web",
            javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController){
                  _controller.complete(webViewController);
                },
          );
        },
      ),
    );
  }
}


class NavigationControls extends StatelessWidget {
  const NavigationControls(this._webViewControllerFuture);
  final Future<WebViewController>_webViewControllerFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _webViewControllerFuture,
      builder: (BuildContext context, AsyncSnapshot<WebViewController> snapshot){
        final bool webViewReady =
            snapshot.connectionState == ConnectionState.done;
        final WebViewController controller = snapshot.data;
        return Row(
          children: <Widget>[
            IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: !webViewReady ? null :() async{
                  if(await controller.canGoBack()){
                    controller.goBack();
                  }else{
                    Scaffold.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("No Back history Item"),
                        )
                    );
                  }
                }
            ),
            IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: !webViewReady ? null :() async{
                  if(await controller.canGoForward()){
                    controller.goForward();
                  }else{
                    Scaffold.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("No Forward history Item"),
                        )
                    );
                  }
                }
            ),
            IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: !webViewReady ? null :() async{
                  controller.reload();
                }
            )
          ],
        );
      },
    );
  }
}