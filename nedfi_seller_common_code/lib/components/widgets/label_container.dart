import '../../app_imports.dart';

/**
 * @Author: Ajinkya Aher, Bhushan Lambole
 * @Date: 20-12-2023
 */

class LabelContainer extends StatelessWidget {
  final String imageName,title;
  const LabelContainer({super.key,required this.imageName,required this.title});

  @override
  Widget build(BuildContext context) {
    return  Container(
      width: (MediaQuery.of(context).size.width / 2) - 15,
      height: 58,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 14,vertical:19),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
      // margin: const EdgeInsets.only(right: 16),
      child: Row(
        children: [
          SvgPicture.asset("assets/images/$imageName.svg"),
          const SizedBox(width: 7),
          WidgetUtils.appTextWidget(context: context, title:title??"", fontSize: 14, family: 'Graphik', fontWeight: FontWeight.w500),
        ],
      ),
    );
  }
}
