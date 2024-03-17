import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:quizletapp/enums/text_style_enum.dart';
import 'package:quizletapp/widgets/text.dart';
import 'package:quizletapp/widgets/item_list.dart';

class GroupList extends StatefulWidget {
  final int itemCount;
  final double itemHeight;
  final String title;
  final bool isShowOption;
  final Function()? onShowAll;
  final Widget Function(BuildContext context, int index)? buildItem;
  const GroupList({
    required this.buildItem,
    required this.itemCount,
    required this.title,
    this.itemHeight = 170,
    this.isShowOption = true,
    this.onShowAll,
    super.key,
  });

  @override
  State<GroupList> createState() => _GroupListState();
}

class _GroupListState extends State<GroupList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CustomText(
                  text: widget.title,
                  type: TextStyleEnum.large,
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              if (widget.isShowOption)
                GestureDetector(
                  onTap: widget.onShowAll != null ? widget.onShowAll! : () {},
                  child: CustomText(
                    text: 'Xem tất cả',
                    style: TextStyle(
                      color: Colors.indigo.shade200,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        Container(
          height: (widget.itemHeight),
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: widget.itemCount,
            separatorBuilder: (context, index) => const SizedBox(
              width: 16,
            ),
            itemBuilder: widget.buildItem!,
          ),
        ),
      ],
    );
  }
}
