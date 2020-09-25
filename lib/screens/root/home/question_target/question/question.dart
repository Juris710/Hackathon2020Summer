import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/models/question/answer.dart';
import 'package:hackathon_2020_summer/models/question/question.dart';
import 'package:hackathon_2020_summer/models/question/reply.dart';
import 'package:hackathon_2020_summer/models/user/account.dart';
import 'package:hackathon_2020_summer/screens/root/home/question_target/edit_question.dart';
import 'package:hackathon_2020_summer/services/database.dart';
import 'package:hackathon_2020_summer/shared/constants.dart';
import 'package:hackathon_2020_summer/shared/utils.dart';
import 'package:hackathon_2020_summer/shared/widgets/loading.dart';
import 'package:hackathon_2020_summer/shared/widgets/user_card.dart';
import 'package:provider/provider.dart';

class WritingStatusNotification extends Notification {
  final WritingStatus writingStatus;

  WritingStatusNotification({this.writingStatus});
}

enum WritingStatus { NotWriting, Writing }

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
                Row(
                  children: [
                    IconButton(
                      icon: Icon(isReplyEditing ? Icons.check : Icons.edit),
                      onPressed: (writingStatus == WritingStatus.Writing &&
                              !isReplyEditing)
                          ? null
                          : () {
                              if (isReplyEditing) {
                                widget.reply.reference.update({
                                  'content': _replyContentController.text,
                                });
                              }
                              WritingStatusNotification(
                                writingStatus: isReplyEditing
                                    ? WritingStatus.NotWriting
                                    : WritingStatus.Writing,
                              ).dispatch(context);
                              setState(() {
                                isReplyEditing = !isReplyEditing;
                              });
                            },
                    ),
                    if (isReplyEditing)
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
                    if (!isReplyEditing)
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
          if (isReplyEditing)
            TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: textFieldDecoration.copyWith(
                border: OutlineInputBorder(borderSide: BorderSide()),
              ),
              controller: _replyContentController,
            ),
          if (!isReplyEditing) Text(_replyContentController.text),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (widget.reply.createdAt != null)
                Text(getDateString(widget.reply.createdAt.toDate())),
            ],
          ),
        ],
      ),
    );
  }
}

class CreateReplyTile extends StatefulWidget {
  final DocumentReference answerReference;

  CreateReplyTile({this.answerReference});

  @override
  _CreateReplyTileState createState() => _CreateReplyTileState();
}

class _CreateReplyTileState extends State<CreateReplyTile> {
  final _replyContentController = TextEditingController();
  bool isCreating = false;

  @override
  void dispose() {
    _replyContentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final account = Provider.of<AccountModel>(context);
    final writingStatus = Provider.of<WritingStatus>(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          if (isCreating)
            TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: textFieldDecoration.copyWith(
                border: OutlineInputBorder(borderSide: BorderSide()),
              ),
              controller: _replyContentController,
            ),
          if (isCreating)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton(
                  textColor: Theme.of(context).primaryColor,
                  onPressed: () {
                    WritingStatusNotification(
                      writingStatus: WritingStatus.NotWriting,
                    ).dispatch(context);
                    setState(() {
                      isCreating = false;
                    });
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
                    WritingStatusNotification(
                      writingStatus: WritingStatus.NotWriting,
                    ).dispatch(context);

                    setState(() {
                      isCreating = false;
                    });
                  },
                  child: Text(
                    '決定',
                  ),
                ),
              ],
            ),
          if (!isCreating)
            FlatButton(
              textColor: Theme.of(context).primaryColor,
              disabledTextColor: Colors.grey,
              onPressed: writingStatus == WritingStatus.Writing
                  ? null
                  : () {
                      WritingStatusNotification(
                        writingStatus: WritingStatus.Writing,
                      ).dispatch(context);
                      setState(() {
                        isCreating = true;
                      });
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

class AnswerCard extends StatefulWidget {
  final AnswerModel answer;

  AnswerCard({this.answer});

  @override
  _AnswerCardState createState() => _AnswerCardState();
}

class _AnswerCardState extends State<AnswerCard> {
  final _answerContentController = TextEditingController();
  bool isAnswerEditing = false;

  @override
  void initState() {
    _answerContentController.text = widget.answer.content;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final account = Provider.of<AccountModel>(context);
    final writingStatus = Provider.of<WritingStatus>(context);
    return Card(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (widget.answer.createdBy != null)
                      UserCard(
                        userReference: widget.answer.createdBy,
                      ),
                    if (account.reference == widget.answer.createdBy)
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                                isAnswerEditing ? Icons.check : Icons.edit),
                            onPressed:
                                (writingStatus == WritingStatus.Writing &&
                                        !isAnswerEditing)
                                    ? null
                                    : () {
                                        if (isAnswerEditing &&
                                            _answerContentController
                                                .text.isNotEmpty) {
                                          widget.answer.reference.update({
                                            'content':
                                                _answerContentController.text,
                                            'updatedAt': DateTime.now(),
                                          });
                                        }
                                        WritingStatusNotification(
                                          writingStatus: isAnswerEditing
                                              ? WritingStatus.NotWriting
                                              : WritingStatus.Writing,
                                        ).dispatch(context);
                                        setState(() {
                                          isAnswerEditing = !isAnswerEditing;
                                        });
                                      },
                          ),
                          if (isAnswerEditing)
                            FlatButton(
                              child: Text('キャンセル'),
                              onPressed: () {
                                WritingStatusNotification(
                                  writingStatus: WritingStatus.NotWriting,
                                ).dispatch(context);
                                setState(() {
                                  isAnswerEditing = false;
                                });
                              },
                            ),
                          if (!isAnswerEditing)
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
                                                'この回答を削除してもよろしいですか？\n削除した場合、元に戻すことはできません。'),
                                            actions: [
                                              FlatButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('キャンセル'),
                                              ),
                                              FlatButton(
                                                onPressed: () {
                                                  widget.answer.reference
                                                      .delete();
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
                if (isAnswerEditing)
                  TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: textFieldDecoration.copyWith(
                      border: OutlineInputBorder(borderSide: BorderSide()),
                    ),
                    controller: _answerContentController,
                  ),
                if (!isAnswerEditing) Text(_answerContentController.text),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (widget.answer.updatedAt != null)
                      Text(getDateString(widget.answer.updatedAt.toDate())),
                  ],
                ),
              ],
            ),
          ),
          StreamBuilder<List<ReplyModel>>(
            stream: widget.answer.replies.orderBy('createdAt').snapshots().map(
                (event) => event.docs
                    .map((doc) => ReplyModel.fromFirestore(doc))
                    .toList()),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return LoadingSmall();
              }
              final replies = snapshot.data;
              if (replies.isEmpty) {
                return Container();
              }
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 0),
                    child: Divider(color: Colors.black),
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => ReplyTile(
                      reply: replies[index],
                    ),
                    separatorBuilder: (context, index) => Divider(
                      color: Colors.black,
                    ),
                    itemCount: replies.length,
                  ),
                ],
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
            child: Divider(color: Colors.black),
          ),
          CreateReplyTile(answerReference: widget.answer.reference),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _answerContentController.dispose();
    super.dispose();
  }
}

class QuestionDetail extends StatelessWidget {
  final QuestionModel question;

  QuestionDetail({this.question});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          question.title,
          style: Theme.of(context).textTheme.headline4,
        ),
        SizedBox(
          height: 8.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (question.createdBy != null)
              UserCard(
                userReference: question.createdBy,
              ),
            if (question.updatedAt != null)
              Text(getDateString(question.updatedAt.toDate())),
          ],
        ),
        SizedBox(
          height: 16.0,
        ),
        Text(
          question.content,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        SizedBox(
          height: 32.0,
        ),
      ],
    );
  }
}

class Question extends StatefulWidget {
  final DocumentReference questionReference;

  Question({this.questionReference});

  @override
  _QuestionState createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  final _answerContentController = TextEditingController();
  WritingStatus writingStatus = WritingStatus.NotWriting;

  @override
  Widget build(BuildContext context) {
    final account = Provider.of<AccountModel>(context);
    return StreamBuilder<QuestionModel>(
      stream: DatabaseService.getQuestion(widget.questionReference),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LoadingScaffold();
        }
        final question = snapshot.data;
        return Scaffold(
          appBar: AppBar(
            title: Text('質問'),
            actions: [
              if (account.reference == question.createdBy)
                FlatButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return EditQuestion(
                            questionReference: question.reference,
                          );
                        },
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  label: Text(
                    '編集',
                    style: TextStyle(color: Colors.white),
                  ),
                )
            ],
          ),
          body: NotificationListener<WritingStatusNotification>(
            onNotification: (notification) {
              setState(() {
                writingStatus = notification.writingStatus;
              });
              return true;
            },
            child: Provider.value(
              value: writingStatus,
              child: Container(
                margin: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  QuestionDetail(question: question),
                                  StreamBuilder<List<AnswerModel>>(
                                    stream: DatabaseService.getAnswers(
                                        question.answers),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return LoadingSmall();
                                      }
                                      final List<AnswerModel> answers =
                                          snapshot.data;
                                      if (answers.length == 0) {
                                        return Text('まだ回答がありません。');
                                      }
                                      return ListView.separated(
                                        separatorBuilder: (context, index) =>
                                            SizedBox(height: 32.0),
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: answers.length,
                                        itemBuilder: (context, index) {
                                          return AnswerCard(
                                              answer: answers[index]);
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (writingStatus == WritingStatus.NotWriting)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _answerContentController,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                decoration: textFieldDecoration.copyWith(
                                    hintText: '回答を入力する'),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (_answerContentController
                                    .value.text.isEmpty) {
                                  return;
                                }
                                FocusScope.of(context).unfocus();
                                widget.questionReference
                                    .collection('answers')
                                    .add({
                                  'content':
                                      _answerContentController.value.text,
                                  'createdBy': account.reference,
                                  'updatedAt': DateTime.now(),
                                });
                                _answerContentController.clear();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.send,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _answerContentController.dispose();
    super.dispose();
  }
}
