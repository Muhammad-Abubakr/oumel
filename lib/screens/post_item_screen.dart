import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/images_container.dart';
import '../widgets/videos_container.dart';

class PostItemScreen extends StatefulWidget {
  const PostItemScreen({super.key});

  @override
  State<PostItemScreen> createState() => _PostItemScreenState();
}

class _PostItemScreenState extends State<PostItemScreen> {
  /* Controllers */
  final TextEditingController name = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController category = TextEditingController();
  final TextEditingController condition = TextEditingController();
  final TextEditingController location = TextEditingController();
  final TextEditingController price = TextEditingController();

  final TextEditingController hexController = TextEditingController();
  late Color pickerColor;
  DateTime year = DateTime.now();

  bool includeAddOn = false;

  @override
  void didChangeDependencies() {
    pickerColor = Theme.of(context).colorScheme.primary;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post item'),
        centerTitle: true,
      ),
      body: SizedBox(
        width: 1.sw,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 0.05.sw),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 64.0.h),
                child: Text(
                  'Item Details',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),

              // TextFields
              Form(
                child: Column(
                  children: [
                    // name
                    TextFormField(
                      controller: name,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        label: Text('Item Name'),
                      ),
                    ),

                    // spacing
                    SizedBox(height: 24.h),

                    // category
                    TextFormField(
                      controller: category,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        label: Text('Category'),
                      ),
                    ),
                    // spacing
                    SizedBox(height: 24.h),

                    // condition
                    TextFormField(
                      controller: condition,
                      decoration: const InputDecoration(
                        label: Text('Condition'),
                      ),
                    ),
                    // spacing
                    SizedBox(height: 24.h),

                    // location
                    TextFormField(
                      controller: location,
                      keyboardType: TextInputType.streetAddress,
                      decoration: const InputDecoration(
                        label: Text('Location'),
                      ),
                    ),
                    // spacing
                    SizedBox(height: 24.h),

                    // price
                    TextFormField(
                      controller: price,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        label: Text('Price'),
                      ),
                    ),

                    // spacing
                    SizedBox(height: 24.h),

                    // description
                    TextFormField(
                      controller: description,
                      maxLines: null,
                      minLines: 6,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        label: Text('Description'),
                      ),
                    ),

                    // spacing
                    SizedBox(height: 96.h),

                    /* Images Container */
                    const ImagesContainer(),

                    // spacing
                    SizedBox(height: 96.h),

                    /* Videos Container */
                    const VideosContainer(),

                    // spacing
                    SizedBox(height: 96.h),

                    /* Title: Add-ons */
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 48.h),
                      child: Text(
                        'Add-ons',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),

                    // model
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Model
                        ChoiceChip(
                          selected: includeAddOn,
                          onSelected: (val) => setState(() => includeAddOn = val),
                          label: const Text('Model'),
                        ),

                        // Color
                        if (includeAddOn) ...[
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: pickerColor,
                              foregroundColor: pickerColor.computeLuminance() > 0.5
                                  ? Colors.grey.shade700
                                  : Colors.white,
                            ),
                            onPressed: () => showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor:
                                    Theme.of(context).dialogBackgroundColor.withAlpha(230),
                                titlePadding: const EdgeInsets.all(0),
                                contentPadding: const EdgeInsets.all(0),
                                content: SingleChildScrollView(
                                  child: ColorPicker(
                                      enableAlpha: true,
                                      displayThumbColor: true,
                                      pickerAreaBorderRadius: BorderRadius.circular(72.r),
                                      pickerColor: pickerColor,
                                      onColorChanged: (color) {
                                        setState(() => pickerColor = color);
                                      }),
                                ),
                              ),
                            ),
                            child: Text(colorToHex(pickerColor, includeHashSign: true)),
                          ),

                          // Year
                          ElevatedButton(
                            onPressed: () => showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(96.r),
                                  child: YearPicker(
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime.now(),
                                    selectedDate: year,
                                    currentDate: year,
                                    onChanged: (date) {
                                      setState(() => year = date);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                              ),
                            ),
                            child: Text('${year.year}'),
                          )
                        ]
                      ],
                    ),

                    SizedBox(height: 128.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            side: BorderSide.none,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            padding: EdgeInsets.symmetric(
              vertical: 48.h,
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary),
        child: const Text('PUBLISH'),
      ),
    );
  }
}
