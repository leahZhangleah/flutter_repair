import 'package:flutter/material.dart';

Type _getType<T>()=>T;

class Provider<T> extends InheritedWidget{
  final T bloc;

  Provider({Key key,this.bloc,Widget child}):super(key:key,child:child);

  @override
  bool updateShouldNotify(Provider<T> oldWidget) {
    // TODO: implement updateShouldNotify
    return oldWidget.bloc != this.bloc;
  }

  static T of<T>(BuildContext context){
    final type = _getType<Provider<T>>();
    final Provider<T> provider = context.inheritFromWidgetOfExactType(type);
    return provider.bloc;
  }
}

class BlocProvider<T> extends StatefulWidget{
  final void Function(BuildContext context, T bloc) onDispose;
  final T Function(BuildContext context, T bloc) builder;
  final Widget child;


  BlocProvider({Key key, this.onDispose, this.builder, this.child}):super(key:key);

  @override
  State<BlocProvider<T>> createState() {
    // TODO: implement createState
    return BlocProviderState<T>();
  }

}

class BlocProviderState<T> extends State<BlocProvider<T>> {
  T bloc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.builder!=null){
      bloc = widget.builder(context,bloc);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if(widget.onDispose!=null){
      widget.onDispose(context,bloc);
    }
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Provider(
      bloc: bloc,
      child: widget.child,
    );
  }
}
/*
abstract class BlocBase{
  void dispose();
}

Type _getType<T >()=>T;

class Provider<T extends BlocBase> extends StatefulWidget{
  final T bloc;
  final Widget child;

  Provider({Key key,@required this.bloc,@required this.child}):super(key:key);

  @override
  bool updateShouldNotify(Provider<T> oldWidget) {
    // TODO: implement updateShouldNotify
    return oldWidget.bloc != this.bloc;
  }

  static T  of<T extends BlocBase>(BuildContext context){
    final type = _getType<BlocProviderInherited<T>>();
    final BlocProviderInherited<T> provider = context.ancestorWidgetOfExactType(type);
    return provider?.bloc;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ProviderState();
  }
}

class ProviderState extends State<Provider> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new BlocProviderInherited(
      bloc: widget.bloc,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    widget.bloc?.dispose();
    super.dispose();
  }
}


class BlocProviderInherited<T> extends InheritedWidget{
  final T bloc;

  BlocProviderInherited({Key key, this.bloc, Widget child}):super(key:key,child:child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return false;
  }

}
*/
