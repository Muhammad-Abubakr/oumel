import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/images_container.dart';
import '../widgets/videos_container.dart';

class PostItemScreen extends StatefulWidget {
  const PostItemScreen({super.key});

  @override
  State<PostItemScreen> createState() => _PostItemScreenState();
}

class _PostItemScreenState extends State<PostItemScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post item'),
      ),
      body: SizedBox(
        width: 1.sw,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 0.05.sw),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /* Images Container */
              const ImagesContainer(),

              // spacing
              SizedBox(height: 96.h),

              /* Videos Container */
              const VideosContainer(),

              // spacing
              SizedBox(height: 96.h),

              // TextFields
              Form(
                child: Column(
                  children: [
                    // name
                    TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Item Name'),
                      ),
                    ),

                    // spacing
                    SizedBox(height: 24.h),

                    // description
                    TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Description'),
                      ),
                    ),
                    // spacing
                    SizedBox(height: 24.h),

                    // category
                    TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Category'),
                      ),
                    ),
                    // spacing
                    SizedBox(height: 24.h),

                    // condition
                    TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Condition'),
                      ),
                    ),
                    // spacing
                    SizedBox(height: 24.h),

                    // location
                    TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Location'),
                      ),
                    ),
                    // spacing
                    SizedBox(height: 24.h),

                    // price
                    TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Price'),
                      ),
                    ),

                    // spacing
                    SizedBox(height: 64.h),

                    Text(
                      'Add-ons',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),

                    // spacing
                    SizedBox(height: 24.h),

                    // model
                    TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Model'),
                      ),
                    ),

                    // spacing
                    SizedBox(height: 24.h),

                    // color
                    TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Color'),
                      ),
                    ),

                    // spacing
                    SizedBox(height: 24.h),

                    // year
                    TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Year'),
                      ),
                    ),

                    // spacing
                    SizedBox(height: 128.h),

                    // Publish
                    /* Uploader */
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 172.w,
                          vertical: 32.h,
                        ),
                      ),
                      child: const Text('Publish'),
                    ),

                    // spacing
                    SizedBox(height: 128.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
