
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:justmeet_frontend/redux/app/app_state.dart';

class ZoomScaffold extends StatefulWidget {
  final Widget menuScreen;
  final Layout contentScreen;

  ZoomScaffold({
    this.menuScreen,
    this.contentScreen,
  });

  @override
  _ZoomScaffoldState createState() => new _ZoomScaffoldState();
}

class _ZoomScaffoldState extends State<ZoomScaffold>
    with TickerProviderStateMixin {
  Curve scaleDownCurve = new Interval(0.0, 0.3, curve: Curves.easeOut);
  Curve scaleUpCurve = new Interval(0.0, 1.0, curve: Curves.easeOut);
  Curve slideOutCurve = new Interval(0.0, 1.0, curve: Curves.easeOut);
  Curve slideInCurve = new Interval(0.0, 1.0, curve: Curves.easeOut);


  createContentDisplay() {
    return zoomAndSlideContent(new Container(
      child: widget.contentScreen.contentBuilder(context)
    ));
  }

  zoomAndSlideContent(Widget content) {
    var slidePercent, scalePercent;

    switch (StoreProvider.of<AppState>(context).state.menuState.menuController.state) {
      case MENU_STATE_LABEL.closed:
        slidePercent = 0.0;
        scalePercent = 0.0;
        break;
      case MENU_STATE_LABEL.open:
        slidePercent = 1.0;
        scalePercent = 1.0;
        break;
      case MENU_STATE_LABEL.opening:
        slidePercent = slideOutCurve.transform(
            StoreProvider.of<AppState>(context).state.menuState.menuController.percentOpen);
        scalePercent = scaleDownCurve.transform(
            StoreProvider.of<AppState>(context).state.menuState.menuController.percentOpen);
        break;
      case MENU_STATE_LABEL.closing:
        slidePercent = slideInCurve.transform(
            StoreProvider.of<AppState>(context).state.menuState.menuController.percentOpen);
        scalePercent = scaleUpCurve.transform(
            StoreProvider.of<AppState>(context).state.menuState.menuController.percentOpen);
        break;
    }

    final slideAmount = 275.0 * slidePercent;
    final contentScale = 1.0 - (0.2 * scalePercent);
    final cornerRadius =
        16.0 * StoreProvider.of<AppState>(context).state.menuState.menuController.percentOpen;

    return new Transform(
      transform: new Matrix4.translationValues(slideAmount, 0.0, 0.0)
        ..scale(contentScale, contentScale),
      alignment: Alignment.centerLeft,
      child: new Container(
        decoration: new BoxDecoration(
          boxShadow: [
            new BoxShadow(
              color: Colors.black12,
              offset: const Offset(0.0, 5.0),
              blurRadius: 15.0,
              spreadRadius: 10.0,
            ),
          ],
        ),
        child: new ClipRRect(
            borderRadius: new BorderRadius.circular(cornerRadius),
            child: content),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: Scaffold(
            body: widget.menuScreen,
          ),
        ),
        createContentDisplay()
      ],
    );
  }
}

class ZoomScaffoldMenuController extends StatefulWidget {
  final ZoomScaffoldBuilder builder;

  ZoomScaffoldMenuController({
    this.builder,
  });

  @override
  ZoomScaffoldMenuControllerState createState() {
    return new ZoomScaffoldMenuControllerState();
  }
}

class ZoomScaffoldMenuControllerState
    extends State<ZoomScaffoldMenuController> {
  @override
  Widget build(BuildContext context) {
    return widget.builder(
        context, StoreProvider.of<AppState>(context).state.menuState.menuController);
  }
}

typedef Widget ZoomScaffoldBuilder(
    BuildContext context, MenuController menuController);

class Layout {
  final WidgetBuilder contentBuilder;

  Layout({
    this.contentBuilder,
  });
}

class MenuController extends ChangeNotifier {
  final TickerProvider vsync;
  final AnimationController _animationController;
  MENU_STATE_LABEL state = MENU_STATE_LABEL.closed;

  MenuController({
    this.vsync,
  }) : _animationController = new AnimationController(vsync: vsync) {
    _animationController
      ..duration = const Duration(milliseconds: 250)
      ..addListener(() {
        notifyListeners();
      })
      ..addStatusListener((AnimationStatus status) {
        switch (status) {
          case AnimationStatus.forward:
            state = MENU_STATE_LABEL.opening;
            break;
          case AnimationStatus.reverse:
            state = MENU_STATE_LABEL.closing;
            break;
          case AnimationStatus.completed:
            state = MENU_STATE_LABEL.open;
            break;
          case AnimationStatus.dismissed:
            state = MENU_STATE_LABEL.closed;
            break;
        }
        notifyListeners();
      });
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  get percentOpen {
    return _animationController.value;
  }

  open() {
    _animationController.forward();
  }

  close() {
    _animationController.reverse();
  }

  toggle() {
    if (state == MENU_STATE_LABEL.open) {
      close();
    } else if (state == MENU_STATE_LABEL.closed) {
      open();
    }
  }
}

enum MENU_STATE_LABEL {
  closed,
  opening,
  open,
  closing,
}