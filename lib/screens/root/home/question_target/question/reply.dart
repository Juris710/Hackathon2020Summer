import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/models/question/reply.dart';
import 'package:hackathon_2020_summer/models/user/account.dart';
import 'package:hackathon_2020_summer/shared/constants.dart';
import 'package:hackathon_2020_summer/shared/utils.dart';
import 'package:hackathon_2020_summer/shared/widgets/user_card.dart';
import 'package:hackathon_2020_summer/shared/writing_status.dart';
import 'package:provider/provider.dart';

class CreateReplyTile extends StatefulWidget {
  final DocumentReference answerReference;

  CreateReplyTile({this.answerReference});

  @override
  _CreateReplyTileState createState() => _CreateReplyTileState();
}

class _CreateReplyTileState extends State<CreateReplyTile>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  final _replyContentController = TextEditingController();
  bool isCreating = false;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    super.initState();
  }

  @override
  void dispose() {
    _replyContentController.dispose();
    super.dispose();
  }

  void setIsCreating(bool isCreating) {
    setState(() {
      this.isCreating = isCreating;
    });
    WritingStatusNotification(
      writingStatus:
          isCreating ? WritingStatus.Writing : WritingStatus.NotWriting,
    ).dispatch(context);
    if (isCreating) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final account = Provider.of<AccountModel>(context);
    final writingStatus = Provider.of<WritingStatus>(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          SizeTransition(
            sizeFactor: _animationController
                .drive(
                  CurveTween(curve: Curves.fastOutSlowIn),
                )
                .drive(
                  Tween<double>(
                    begin: 0,
                    end: 1,
                  ),
                ),
            child: TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: textFieldDecoration.copyWith(
                border: OutlineInputBorder(borderSide: BorderSide()),
              ),
              controller: _replyContentController,
            ),
          ),
          isCreating
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      onPressed: () {
                        setIsCreating(false);
                      },
                      child: Text(
                        'キャンセル',
                      ),
                    ),
                    FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      onPressed: () {
                        if (_replyContentController.text.isNotEmpty) {
                          widget.answerReference.collection('replies').add({
                            'content': _replyContentController.text,
                            'createdBy': account.reference,
                            'createdAt': DateTime.now(),
                          });
                          _replyContentController.clear();
                        }
                        setIsCreating(false);
                      },
                      child: Text(
                        '決定',
                      ),
                    ),
                  ],
                )
              : FlatButton(
                  textColor: Theme.of(context).primaryColor,
                  disabledTextColor: Colors.grey,
                  onPressed: writingStatus == WritingStatus.Writing
                      ? null
                      : () {
                          setIsCreating(true);
                        },
                  child: Text(
                    '返信する',
                  ),
                ),
        ],
      ),
    );
  }
}

class ReplyTile extends StatefulWidget {
  final ReplyModel reply;

  ReplyTile({this.reply});

  @override
  _ReplyTileState createState() => _ReplyTileState();
}

class _ReplyTileState extends State<ReplyTile> {
  final _replyContentController = TextEditingController();
  bool isReplyEditing = false;

  @override
  void initState() {
    _replyContentController.text = widget.reply.content;
    super.initState();
  }

  @override
  void dispose() {
    _replyContentController.dispose();
    super.dispose();
  }

  void setIsReplyEditing(isReplyEditing) {
    setState(() {
      this.isReplyEditing = isReplyEditing;
    });
    WritingStatusNotification(
      writingStatus:
          isReplyEditing ? WritingStatus.Writing : WritingStatus.NotWriting,
    ).dispatch(context);
  }

  @override
  Widget build(BuildContext context) {
    final account = Provider.of<AccountModel>(context);
    final writingStatus = Provider.of<WritingStatus>(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (widget.reply.createdBy != null)
                UserCard(
                  userReference: widget.reply.createdBy,
                ),
              if (account.reference == widget.reply.createdBy)
                isReplyEditing
                    ? Row(
                        key: ValueKey(true),
                        children: [
                          IconButton(
                            icon: Icon(Icons.check),
                            onPressed: () {
                              final content = _replyContentController.text;
                              if (content.isNotEmpty &&
                                  content != widget.reply.content) {
                                widget.reply.reference.update({
                                  'content': content,
                                });
                              }
                              setIsReplyEditing(false);
                            },
                          ),
                          FlatButton(
                            child: Text('キャンセル'),
                            onPressed: () {
                              WritingStatusNotification(
                                writingStatus: WritingStatus.NotWriting,
                              ).dispatch(context);
                              setState(() {
                                isReplyEditing = false;
                              });
                            },
                          ),
                        ],
                      )
                    : Row(
                        key: ValueKey(false),
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: (writingStatus == WritingStatus.Writing)
                                ? null
                                : () {
                                    setIsReplyEditing(true);
                                  },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: writingStatus == WritingStatus.Writing
                                ? null
                                : () async {
                                    await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text('確認'),
                                          content: Text(
                                              'この返信を削除してもよろしいですか？\n削除した場合、元に戻すことはできません。'),
                                          actions: [
                                            FlatButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('キャンセル'),
                                            ),
                                            FlatButton(
                                              onPressed: () {
                                                widget.reply.reference.delete();
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('削除する'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                          ),
                        ],
                      ),
            ],
          ),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 200),
            child: (isReplyEditing)
                ? TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: textFieldDecoration.copyWith(
                      border: OutlineInputBorder(borderSide: BorderSide()),
                    ),
                    controller: _replyContentController,
                  )
                : SelectableText(_replyContentController.text),
          ),
          SizedBox(height: 16.0),
          if (widget.reply.createdAt != null)
            Align(
              alignment: Alignment.centerRight,
              child: Text(getDateString(widget.reply.createdAt.toDate())),
            )
        ],
      ),
    );
  }
}
