import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram/widgets/small_text.dart';
import 'package:instagram/widgets/text_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'instagram',
          style: GoogleFonts.dancingScript(
            textStyle: const TextStyle(
              fontSize: 30,
              color: Colors.black87,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              CupertinoIcons.heart,
              color: Colors.black,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              CupertinoIcons.text_bubble,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            width: 4,
          ),
        ],
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: SmallText(
              textAlign: TextAlign.start,
              text: 'Suggested for you',
              fontSize: 20,
            ),
          ),
          ListTile(
            titleAlignment: ListTileTitleAlignment.bottom,
            contentPadding: const EdgeInsets.only(left: 12),
            visualDensity: VisualDensity.compact,
            leading: const CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://i.pinimg.com/236x/7c/61/f7/7c61f76df6d50c88b2ad87601dff12c2.jpg'),
            ),
            title: const SmallText(
              textAlign: TextAlign.start,
              text: 'jagritixjha',
              fontSize: 12,
            ),
            subtitle: const SmallText(
              textAlign: TextAlign.start,
              text: '12 hours ago',
              fontSize: 12,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo.shade50,
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const SmallText(
                    text: 'Follow',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {},
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(
                    CupertinoIcons.ellipsis_vertical,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 380,
            width: double.infinity,
            decoration: const BoxDecoration(
              // color: Colors.red,
              image: DecorationImage(
                image: NetworkImage(
                    'https://i.pinimg.com/564x/f9/b2/06/f9b2062b1c744a6ef889b15ff3b144de.jpg'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Row(
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {},
                visualDensity: VisualDensity.compact,
                icon: const Icon(
                  CupertinoIcons.heart,
                  size: 28,
                  color: Colors.black,
                ),
              ),
              const SmallText(
                text: '187K',
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              const SizedBox(
                width: 4,
              ),
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {},
                visualDensity: VisualDensity.compact,
                icon: const Icon(
                  CupertinoIcons.chat_bubble,
                  size: 28,
                  color: Colors.black,
                ),
              ),
              const SmallText(
                text: '1,485',
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              const SizedBox(
                width: 4,
              ),
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {},
                visualDensity: VisualDensity.compact,
                icon: const Icon(
                  Icons.navigation_outlined,
                  size: 28,
                  color: Colors.black,
                ),
              ),
              const SmallText(
                text: '69.6K',
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              const Spacer(),
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {},
                visualDensity: VisualDensity.comfortable,
                icon: const Icon(
                  CupertinoIcons.bookmark,
                  size: 24,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                SmallText(
                  text: 'jagritixjha  you can do anything! 🫡😶‍🌫️',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: CustomTextButton(
              text: 'View all 1,578 comments',
              fontWeight: FontWeight.w500,
              textColor: Colors.grey.shade600,
              onTap: () {},
            ),
          )
        ],
      ),
    );
  }
}
