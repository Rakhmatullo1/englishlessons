import 'package:englishlessons/screens/lessons_screen_extra.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/dictionary.dart';

class MainOverview extends StatefulWidget {
  final String data;
  final List<GloData> listData;
  final List<RefData> refData;
  const MainOverview({
    required this.data,
    required this.listData,
    required this.refData,
    super.key,
  });

  @override
  State<MainOverview> createState() => _MainOverviewState();
}

class RefData {
  String title;
  String ref;
  RefData(this.title, this.ref);
}

class _MainOverviewState extends State<MainOverview> {
  bool isLoading = false;
  bool isLoadingOne = false;
  bool? isEmpty = false;

  Future<void> tappingSelectedText(
      String text, bool type, String definition) async {
    Map<String, WordDefinition> data = {};
    String? phoneticSpelling;
    if (!type) {
      try {
        setState(() {
          isLoadingOne = true;
        });
        await Provider.of<DictionaryProvider>(context, listen: false)
            .getDefinitions(text);
        setState(() {
          data = Provider.of<DictionaryProvider>(context, listen: false).data!;
          if (data.isEmpty) {
            isEmpty =
                Provider.of<DictionaryProvider>(context, listen: false).isEmpty;
          } else {
            phoneticSpelling =
                Provider.of<DictionaryProvider>(context, listen: false)
                    .phoneticSpelling;
          }
        });
      } finally {
        setState(() {
          isLoadingOne = false;
        });
      }
    }

    // ignore: use_build_context_synchronously
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        context: context,
        builder: (context) => ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.6),
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: const BoxDecoration(
                color: Colors.green,
              ),
              child: Scaffold(
                  body: isEmpty!
                      ? Container(
                          height: MediaQuery.of(context).size.height * 0.6,
                          padding: const EdgeInsets.only(
                              left: 40, right: 40, top: 4),
                          child: Column(
                            children: [
                              Container(
                                height: 5,
                                width: 50,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Colors.grey.shade100),
                                    borderRadius: BorderRadius.circular(3),
                                    color: Colors.grey.shade500),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width -
                                          145,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            text,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 40),
                                          ),
                                          const Text('Nothing is found')
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ))
                      : type
                          ? Container(
                              height: MediaQuery.of(context).size.height * 0.6,
                              padding: const EdgeInsets.only(
                                  left: 40, right: 40, top: 4),
                              child: Column(
                                children: [
                                  Container(
                                    height: 5,
                                    width: 50,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1,
                                            color: Colors.grey.shade100),
                                        borderRadius: BorderRadius.circular(3),
                                        color: Colors.grey.shade500),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: Text(
                                          text,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 40),
                                        ),
                                      ),
                                      Text(definition)
                                    ],
                                  )
                                ],
                              ))
                          : Container(
                              height: MediaQuery.of(context).size.height * 0.6,
                              padding: const EdgeInsets.only(
                                  left: 40, right: 40, top: 4),
                              child: Column(
                                children: [
                                  Container(
                                    height: 5,
                                    width: 50,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1,
                                            color: Colors.grey.shade100),
                                        borderRadius: BorderRadius.circular(3),
                                        color: Colors.grey.shade500),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15),
                                        child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                145,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 8.0),
                                                  child: Text(
                                                    text,
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20),
                                                  ),
                                                ),
                                                Text(
                                                  "[$phoneticSpelling]",
                                                  style: TextStyle(
                                                      color:
                                                          Colors.grey.shade300,
                                                      fontSize: 14),
                                                ),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.4,
                                                  child: ListView.builder(
                                                      itemCount: data.length,
                                                      itemBuilder:
                                                          (context, index) =>
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    data["$index"]!
                                                                        .lexicalCategory,
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            14),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 400 /
                                                                        (index +
                                                                            1),
                                                                    child: ListView
                                                                        .builder(
                                                                      itemCount: data[
                                                                              "$index"]!
                                                                          .definition
                                                                          .length,
                                                                      itemBuilder:
                                                                          (context, i) =>
                                                                              SizedBox(
                                                                        height:
                                                                            100,
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Expanded(
                                                                              flex: 2,
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.only(top: 5.0, left: 14),
                                                                                child: Text("${i + 1}. ${data["$index"]!.definition[i].definition}", style: const TextStyle(fontSize: 20)),
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                                flex: 3,
                                                                                child: ListView.builder(
                                                                                    itemCount: data["$index"]!.definition[i].syn.length,
                                                                                    itemBuilder: (context, j) {
                                                                                      return Text(
                                                                                        "* ${data["$index"]!.definition[i].syn[j]}",
                                                                                        style: TextStyle(color: Colors.grey[500]),
                                                                                      );
                                                                                    }))
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              )),
                                                ),
                                              ],
                                            )),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )),
            )));
  }

  List<TextSpan> words = [];
  List<TextSpan> ref = [];

  List<TextSpan>? _transform1(String data) {
    List<String> word = data.split(" ");
    for (int i = 0; i < word.length; i++) {
      if (widget.listData.any((element) =>
          element.word.trim().toLowerCase() == word[i].trim().toLowerCase())) {
        words.add(TextSpan(

            text: "${word[i]} ",
            style: const TextStyle(
              backgroundColor: Color.fromRGBO(251, 240, 217, 1),
              color: Colors.black,
            )));
      } else {
        words.add(TextSpan(
            text: "${word[i]} ",
        ));
      }
    }

    return words;
  }

  List<TextSpan> _transform2(String dataOne) {
    List<String> word = dataOne.split("\$");
    for (int i = 0; i < word.length; i++) {
      String part = word[i];

      if (widget.refData.any((element) =>
          element.title.trim().toLowerCase() == part.trim().toLowerCase())) {
        ref.add(TextSpan(
            text: part,
            // children: _transform1(part),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20.0)),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    builder: (context) {
                      return ConstrainedBox(
                        constraints: BoxConstraints(
                            maxHeight:
                                MediaQuery.of(context).size.height * 0.6),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 5,
                                    width: 50,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1,
                                            color: Colors.grey.shade100),
                                        borderRadius: BorderRadius.circular(3),
                                        color: Colors.grey.shade500),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Text: ${word[i]}",
                                style: const TextStyle(fontSize: 24),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                "Reference: ${widget.refData.firstWhere((element) => element.title.trim() == word[i].trim()).ref}",
                                style: TextStyle(
                                    color: Colors.grey.shade500, fontSize: 18),
                              )
                            ],
                          ),
                        ),
                      );
                    });
              },
            style: const TextStyle(
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w500)));
      } else {
        ref.add(TextSpan(
          text: part,
          style: const TextStyle(color: Colors.transparent)
        ));
      }
    }
    return ref;
  }

  String? data;
  @override
  void initState() {
    super.initState();
    data = widget.data;
    List<String> words = data!.split("\$");
    data = words.join("");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: isLoadingOne ? Colors.white70 : Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SelectableText.rich(
                    TextSpan(
                      children: _transform1(data!),
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  SelectableText.rich(
                      TextSpan(
                        children: _transform2(widget.data),
                      ),
                      textAlign: TextAlign.justify,
                      selectionControls: CustomTextSelection(
                    custom: ((start, end) {
                      String short = "";
                      for (int i = start; i < end; i++) {
                        short = short + data![i];
                      }
                      if (widget.listData.any(
                        (element) => element.word == short,
                      )) {
                        final definition = widget.listData
                            .firstWhere((element) => element.word == short)
                            .definition;
                        tappingSelectedText(short, true, definition);
                      } else {
                        if (!short.contains(' ')) {
                          tappingSelectedText(short, false, '');
                        }
                      }
                    }),
                  )),
                  if (isLoadingOne)
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 40,
                                offset: const Offset(0, 15))
                          ]),
                      height: 200,
                      width: 200,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

typedef OffsetValue = void Function(int start, int end);

class CustomTextSelection extends TextSelectionControls {
  CustomTextSelection({
    required this.custom,
  });

  final OffsetValue custom;

  @override
  Widget buildHandle(
      BuildContext context, TextSelectionHandleType type, double textLineHeight,
      [VoidCallback? onTap]) {
    return Container(
      width: 10,
      height: 10,
      color: Colors.transparent,
    );
  }

  static const double _kToolbarContentDistanceBelow = 20.0;
  static const double _kToolbarContentDistance = 8.0;

  @override
  Widget buildToolbar(
      BuildContext context,
      Rect globalEditableRegion,
      double textLineHeight,
      Offset selectionMidpoint,
      List<TextSelectionPoint> endpoints,
      TextSelectionDelegate delegate,
      ClipboardStatusNotifier? clipboardStatus,
      Offset? lastSecondaryTapDownPosition) {
    final TextSelectionPoint startTextSelectionPoint = endpoints[0];
    final TextSelectionPoint endTextSelectionPoint =
        endpoints.length > 1 ? endpoints[1] : endpoints[0];
    final Offset anchorAbove = Offset(
        globalEditableRegion.left + selectionMidpoint.dx,
        globalEditableRegion.top +
            startTextSelectionPoint.point.dy -
            textLineHeight -
            _kToolbarContentDistance);
    final Offset anchorBelow = Offset(
      globalEditableRegion.left + selectionMidpoint.dx,
      globalEditableRegion.top +
          endTextSelectionPoint.point.dy +
          _kToolbarContentDistanceBelow,
    );

    return MyTextSelectionToolbar(
      key: GlobalKey(),
      anchorAbove: anchorAbove,
      anchorBelow: anchorBelow,
      clipboardStatus: clipboardStatus!,
      handleCopy: () {},
      customButton: () {
        custom(delegate.textEditingValue.selection.start,
            delegate.textEditingValue.selection.end);
        delegate.hideToolbar();
      },
    );
  }

  @override
  Offset getHandleAnchor(TextSelectionHandleType type, double textLineHeight) {
    return const Offset(0, 1);
  }

  @override
  Size getHandleSize(double textLineHeight) {
    return const Size(0, 0);
  }
}

class MyTextSelectionToolbar extends StatefulWidget {
  const MyTextSelectionToolbar({
    required Key key,
    required this.anchorAbove,
    required this.anchorBelow,
    required this.clipboardStatus,
    required this.handleCopy,
    required this.customButton,
  }) : super(key: key);

  final Offset anchorAbove;
  final Offset anchorBelow;
  final ClipboardStatusNotifier clipboardStatus;
  final VoidCallback? handleCopy;
  final VoidCallback? customButton;

  @override
  MyTextSelectionToolbarState createState() => MyTextSelectionToolbarState();
}

class _TextSelectionToolbarItemData {
  const _TextSelectionToolbarItemData({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;
}

class MyTextSelectionToolbarState extends State<MyTextSelectionToolbar> {
  void _onChangedClipboardStatus() {
    setState(() {
      // Inform the widget that the value of clipboardStatus has changed.
    });
  }

  @override
  void initState() {
    super.initState();
    widget.clipboardStatus.addListener(_onChangedClipboardStatus);
    widget.clipboardStatus.update();
  }

  @override
  void didUpdateWidget(MyTextSelectionToolbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.clipboardStatus != oldWidget.clipboardStatus) {
      widget.clipboardStatus.addListener(_onChangedClipboardStatus);
      oldWidget.clipboardStatus.removeListener(_onChangedClipboardStatus);
    }
    widget.clipboardStatus.update();
  }

  @override
  void dispose() {
    super.dispose();
    if (!widget.clipboardStatus.disposed) {
      widget.clipboardStatus.removeListener(_onChangedClipboardStatus);
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);

    final List<_TextSelectionToolbarItemData> itemDatas =
        <_TextSelectionToolbarItemData>[
      if (widget.handleCopy != null)
        _TextSelectionToolbarItemData(
          label: localizations.copyButtonLabel,
          onPressed: widget.handleCopy!,
        ),
      if (widget.customButton != null)
        _TextSelectionToolbarItemData(
            label: 'Definition', onPressed: widget.customButton!),
    ];

    int childIndex = 0;
    return TextSelectionToolbar(
      anchorAbove: widget.anchorAbove,
      anchorBelow: widget.anchorBelow,
      toolbarBuilder: (BuildContext context, Widget child) {
        return Card(child: child);
      },
      children: itemDatas.map((_TextSelectionToolbarItemData itemData) {
        return TextSelectionToolbarTextButton(
          padding: TextSelectionToolbarTextButton.getPadding(
              childIndex++, itemDatas.length),
          onPressed: itemData.onPressed,
          child: Text(itemData.label),
        );
      }).toList(),
    );
  }
}
