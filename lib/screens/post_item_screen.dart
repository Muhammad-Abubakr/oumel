import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
              /* Images / Videos Container */
              Container(
                // styling
                alignment: Alignment.center,
                height: 300.h,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.secondary,
                    style: BorderStyle.solid,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(32.r),
                ),

                // child
                child: 0 == 0
                    ? const Text(
                        'Upload images or videos to preview here',
                        textAlign: TextAlign.center,
                      )
                    : ListView.separated(
                        separatorBuilder: (context, _) => const VerticalDivider(),
                        itemBuilder: (context, index) => Image.file(File('')),
                        itemCount: 0,
                      ),
              ),

              // spacing
              SizedBox(height: 96.h),

              /* Uploader */
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.file_upload_outlined),
                label: const Text('Upload Images / Videos'),
              ),

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
