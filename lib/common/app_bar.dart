import 'package:flutter/material.dart';

import '../config.dart';

class AppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  const AppBarWidget(
      {super.key,
      this.title,
      this.tabBar,
      this.preferredSize = const Size.fromHeight(55.0),
      this.leading,
      this.actions,
      this.gradient,
      this.automaticallyImplyLeading = true,
      this.builder,
      this.textStyle,
      this.primary = true,
      this.centerTitle = true});

  final Widget? title;
  final List<Color>? gradient;
  final TabBar? tabBar;
  final Widget? leading;
  final Widget? builder;
  final TextStyle? textStyle;
  final List<Widget>? actions;
  final bool automaticallyImplyLeading;
  final bool primary;
  final bool centerTitle;
  @override
  final Size preferredSize;

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> actions = widget.actions ?? [];
    final List<Color> gradient = widget.gradient ??
        [
          primaryColor,
          primaryColor,
        ];
    final Widget? builder = widget.title ?? widget.builder;
    return AppBar(
      primary: widget.primary,
      leading: widget.leading,
      automaticallyImplyLeading: widget.automaticallyImplyLeading,
      leadingWidth:
          widget.leading == null && !widget.automaticallyImplyLeading ? 0 : 56,
      title: DefaultTextStyle(
        style: const TextStyle(color: Colors.white, fontSize: 20),
        child: builder ?? Container(),
      ),
      centerTitle: widget.centerTitle,
      backgroundColor: Colors.white,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradient,
          ),
        ),
      ),
      actions: actions,
      bottom: widget.tabBar,
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }
}
