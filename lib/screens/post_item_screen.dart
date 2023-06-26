import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../blocs/images/images_cubit.dart';
import '../blocs/products/products_bloc.dart';
import '../blocs/videos/videos_cubit.dart';
import '../models/product.dart';
import '../widgets/images_container.dart';
import '../widgets/videos_container.dart';

class PostItemScreen extends StatefulWidget {
  const PostItemScreen({super.key});

  @override
  State<PostItemScreen> createState() => _PostItemScreenState();
}

class _PostItemScreenState extends State<PostItemScreen> {
  /* Dependency Cubits */
  late ImagesCubit imagesCubit;
  late VideosCubit videosCubit;

  /* Controllers */
  final TextEditingController name = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController condition = TextEditingController();
  final TextEditingController location = TextEditingController();
  final TextEditingController price = TextEditingController();

  ProductCategory category = ProductCategory.none;
  final TextEditingController hexController = TextEditingController();
  late Color pickerColor;
  DateTime year = DateTime.now();

  bool includeAddOn = false;

  @override
  void didChangeDependencies() {
    pickerColor = Theme.of(context).colorScheme.primary;

    imagesCubit = context.watch<ImagesCubit>();
    videosCubit = context.watch<VideosCubit>();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    ProductsBloc productsBloc = context.read<ProductsBloc>();

    return BlocListener<ProductsBloc, ProductsState>(
      listener: (context, state) {
        switch (state.status) {
          case ProductsStatus.processing:
            Navigator.of(context).push(
              DialogRoute(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.primary,
                        backgroundColor: Theme.of(context).colorScheme.background,
                      ),
                    );
                  }),
            );
            break;
          case ProductsStatus.error:
            Navigator.of(context).pop();
            // First Clear the State for snackbars
            ScaffoldMessenger.of(context).clearSnackBars();

            // Then show New
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('${state.error}'),
              action: SnackBarAction(
                label: 'Dismiss',
                onPressed: () => ScaffoldMessenger.of(context).removeCurrentSnackBar(),
              ),
            ));
            break;

          case ProductsStatus.success:
            Navigator.of(context).pop();
            // First Clear the State for snackbars
            ScaffoldMessenger.of(context).clearSnackBars();

            // Then show New
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('The item has been successfully uploaded'),
              ),
            );
            break;

          default:
        }
      },
      child: Scaffold(
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
                    'Item Details *',
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
                      SizedBox(height: 36.h),

                      // condition
                      TextFormField(
                        controller: condition,
                        decoration: const InputDecoration(
                          label: Text('Condition'),
                        ),
                      ),
                      // spacing
                      SizedBox(height: 36.h),

                      // location
                      TextFormField(
                        controller: location,
                        keyboardType: TextInputType.streetAddress,
                        decoration: const InputDecoration(
                          label: Text('Location'),
                        ),
                      ),
                      // spacing
                      SizedBox(height: 36.h),

                      // price
                      TextFormField(
                        controller: price,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          label: Text('Price'),
                        ),
                      ),

                      // spacing
                      SizedBox(height: 36.h),

                      // Category
                      LayoutBuilder(
                        builder: (context, constraints) => DropdownMenu(
                          width: constraints.maxWidth,
                          label: const Text('Category'),
                          dropdownMenuEntries: const <DropdownMenuEntry<ProductCategory>>[
                            DropdownMenuEntry(
                              label: 'Free',
                              value: ProductCategory.free,
                            ),
                            DropdownMenuEntry(
                              label: 'Furniture',
                              value: ProductCategory.furniture,
                            ),
                            DropdownMenuEntry(
                              label: 'Jewllery',
                              value: ProductCategory.jewllery,
                            ),
                            DropdownMenuEntry(
                              label: 'Clothing',
                              value: ProductCategory.clothing,
                            ),
                            DropdownMenuEntry(
                              label: 'Vehicles',
                              value: ProductCategory.vehicles,
                            ),
                            DropdownMenuEntry(
                              label: 'Electronics',
                              value: ProductCategory.electronics,
                            ),
                            DropdownMenuEntry(
                              label: 'Books',
                              value: ProductCategory.books,
                            ),
                          ],
                          initialSelection: category,
                          onSelected: (val) {
                            if (val != null) setState(() => category = val);
                          },
                        ),
                      ),

                      // spacing
                      SizedBox(height: 36.h),

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

                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 48.0.h),
                        child: Text(
                          'Media',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),

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
          onPressed: () => publisher(productsBloc),
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
          child: Text(
            'Publish',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
          ),
        ),
      ),
    );
  }

  /* Publisher */
  void publisher(ProductsBloc productsBloc) {
    if (name.text.isEmpty ||
        condition.text.isEmpty ||
        location.text.isEmpty ||
        price.text.isEmpty ||
        description.text.isEmpty ||
        category.index == 0) {
      /* Show the Dialog that User needs to fill all required fields */
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('Edit Required'),
                content: const Text('All of the Item Detail fields are mandatory.'),
                actions: [
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Okay'),
                  )
                ],
              ));
    } else {
      try {
        if (includeAddOn) {
          if (imagesCubit.isNotEmpty() && videosCubit.isNotEmpty()) {
            productsBloc.add(
              PostProduct(
                name: name.text.trim(),
                condition: condition.text.trim(),
                location: location.text.trim(),
                price: double.parse(price.text.trim()),
                category: category,
                description: description.text.trim(),
                color: colorToHex(pickerColor),
                year: year,
                images: imagesCubit.state.images,
                videos: videosCubit.state.videos,
              ),
            );
          } else if (imagesCubit.isEmpty() && videosCubit.isNotEmpty()) {
            productsBloc.add(
              PostProduct(
                name: name.text.trim(),
                condition: condition.text.trim(),
                location: location.text.trim(),
                price: double.parse(price.text.trim()),
                category: category,
                description: description.text.trim(),
                color: colorToHex(pickerColor),
                year: year,
                videos: videosCubit.state.videos,
              ),
            );
          } else if (imagesCubit.isNotEmpty() && videosCubit.isEmpty()) {
            productsBloc.add(
              PostProduct(
                name: name.text.trim(),
                condition: condition.text.trim(),
                location: location.text.trim(),
                price: double.parse(price.text.trim()),
                category: category,
                description: description.text.trim(),
                color: colorToHex(pickerColor),
                year: year,
                images: imagesCubit.state.images,
              ),
            );
          } else if (imagesCubit.isEmpty() && videosCubit.isEmpty()) {
            productsBloc.add(
              PostProduct(
                name: name.text.trim(),
                condition: condition.text.trim(),
                location: location.text.trim(),
                price: double.parse(price.text.trim()),
                category: category,
                description: description.text.trim(),
                color: colorToHex(pickerColor),
                year: year,
              ),
            );
          }
        } else {
          if (imagesCubit.isNotEmpty() && videosCubit.isNotEmpty()) {
            productsBloc.add(
              PostProduct(
                name: name.text.trim(),
                condition: condition.text.trim(),
                location: location.text.trim(),
                price: double.parse(price.text.trim()),
                category: category,
                description: description.text.trim(),
                images: imagesCubit.state.images,
                videos: videosCubit.state.videos,
              ),
            );
          } else if (imagesCubit.isEmpty() && videosCubit.isNotEmpty()) {
            productsBloc.add(
              PostProduct(
                name: name.text.trim(),
                condition: condition.text.trim(),
                location: location.text.trim(),
                price: double.parse(price.text.trim()),
                category: category,
                description: description.text.trim(),
                videos: videosCubit.state.videos,
              ),
            );
          } else if (imagesCubit.isNotEmpty() && videosCubit.isEmpty()) {
            productsBloc.add(
              PostProduct(
                name: name.text.trim(),
                condition: condition.text.trim(),
                location: location.text.trim(),
                price: double.parse(price.text.trim()),
                category: category,
                description: description.text.trim(),
                images: imagesCubit.state.images,
              ),
            );
          } else if (imagesCubit.isEmpty() && videosCubit.isEmpty()) {
            productsBloc.add(
              PostProduct(
                name: name.text.trim(),
                condition: condition.text.trim(),
                location: location.text.trim(),
                price: double.parse(price.text.trim()),
                category: category,
                description: description.text.trim(),
              ),
            );
          }
        }
      } catch (error) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Edit Required'),
            content: Text(error.toString()),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Okay'),
              )
            ],
          ),
        );
      }
    }
  }
}
