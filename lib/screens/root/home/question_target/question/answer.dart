import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/models/question/answer.dart';
import 'package:hackathon_2020_summer/models/question/reply.dart';
import 'package:hackathon_2020_summer/models/user/account.dart';
import 'package:hackathon_2020_summer/screens/root/home/question_target/question/reply.dart';
import 'package:hackathon_2020_summer/shared/constants.dart';
import 'package:hackathon_2020_summer/shared/utils.dart';
import 'package:hackathon_2020_summer/shared/widgets/loading.dart';
import 'package:hackathon_2020_summer/shared/widgets/user_card.dart';
import 'package:hackathon_2020_summer/shared/writing_status.dart';
import 'package:provider/provider.dart';

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

  void setIsAnswerEditing(bool isAnswerEditing) {
    setState(() {
      this.isAnswerEditing = isAnswerEditing;
    });
    WritingStatusNotification(
      writingStatus:
          isAnswerEditing ? WritingStatus.Writing : WritingStatus.NotWriting,
    ).dispatch(context);
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
                      (isAnswerEditing)
                          ? Row(
                              key: ValueKey(true),
                              children: [
                                IconButton(
                                  icon: Icon(Icons.check),
                                  onPressed: () {
                                    final content =
                                        _answerContentController.text;
                                    if (content.isNotEmpty &&
                                        content != widget.answer.content) {
                                      widget.answer.reference.update({
                                        'content': content,
                                        'updatedAt': DateTime.now(),
                                      });
                                    }
                                    setIsAnswerEditing(false);
                                  },
                                ),
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
                              ],
                            )
                          : Row(
                              key: ValueKey(false),
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed:
                                      (writingStatus == WritingStatus.Writing)
                                          ? null
                                          : () {
                                              setIsAnswerEditing(true);
                                            },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: writingStatus ==
                                          WritingStatus.Writing
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
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text('キャンセル'),
                                                  ),
                                                  FlatButton(
                                                    onPressed: () {
                                                      widget.answer.reference
                                                          .delete();
                                                      Navigator.of(context)
                                                          .pop();
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
                  duration: Duration(milliseconds: 500),
                  child: (isAnswerEditing)
                      ? TextField(
                          autofocus: true,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: textFieldDecoration.copyWith(
                            border:
                                OutlineInputBorder(borderSide: BorderSide()),
                          ),
                          controller: _answerContentController,
                        )
                      : SelectableText(_answerContentController.text),
                ),
                SizedBox(height: 16.0),
                if (widget.answer.updatedAt != null)
                  Align(
                    alignment: Alignment.centerRight,
                    child:
                        Text(getDateString(widget.answer.updatedAt.toDate())),
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
                  Divider(
                    color: Colors.black,
                    indent: 8.0,
                    endIndent: 8.0,
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
          Divider(
            color: Colors.black,
            indent: 8.0,
            endIndent: 8.0,
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
