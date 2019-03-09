import 'dart:math';

import 'package:fifteenpuzzle/config/ui.dart';
import 'package:fifteenpuzzle/data/board.dart';
import 'package:fifteenpuzzle/links.dart';
import 'package:fifteenpuzzle/utils/url.dart';
import 'package:fifteenpuzzle/widgets/about/dialog.dart';
import 'package:fifteenpuzzle/widgets/game/board.dart';
import 'package:flutter/material.dart' hide AboutDialog;
import 'package:flutter/widgets.dart';

Widget createMoreBottomSheet(
  BuildContext context, {
  @required Function(int) call,
}) {
  final config = ConfigUiContainer.of(context);

  Widget createBoard({int size}) => Center(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(8.0),
              padding: EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black54
                    : Colors.black12,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: InkWell(
                onTap: () {
                  call(size);
                  Navigator.of(context).pop();
                },
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    final puzzleSize = min(
                      constraints.maxWidth,
                      constraints.maxHeight,
                    );

                    return BoardWidget(
                      board: Board.createNormal(size),
                      onTap: null,
                      showNumbers: false,
                      size: puzzleSize,
                    );
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text('${size}x$size'),
            ),
          ],
        ),
      );

  final items = <Widget>[
    SizedBox(height: 16),
    Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: 4),
        IconButton(
          icon: const Icon(Icons.info_outline),
          onPressed: () {
            Navigator.of(context).pop();
            showDialog(
                context: context,
                builder: (context) {
                  return AboutDialog();
                });
          },
        ),
        IconButton(
          icon: const Icon(Icons.code),
          onPressed: () {
            Navigator.of(context).pop();
            launchUrl(url: URL_REPOSITORY);
          },
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: OutlineButton(
              shape: const RoundedRectangleBorder(
                borderRadius:
                    const BorderRadius.all(const Radius.circular(16.0)),
              ),
              onPressed: () {
                var shouldUseDarkTheme = !config.useDarkTheme;
                config.setUseDarkTheme(shouldUseDarkTheme, save: true);
              },
              child: Text('Toggle theme'),
            ),
          ),
        ),
        SizedBox(width: 16),
      ],
    ),
    SizedBox(height: 4),
    Row(
      children: <Widget>[
        SizedBox(width: 8),
        Expanded(child: createBoard(size: 3)),
        Expanded(child: createBoard(size: 4)),
        Expanded(child: createBoard(size: 5)),
        SizedBox(width: 8),
      ],
    ),
    SizedBox(height: 16),
  ];

  return new Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: items,
  );
}
