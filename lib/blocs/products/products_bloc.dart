import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/product.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  /* Firebase Realtime Database instance */
  final DatabaseReference _productsRef = FirebaseDatabase.instance.ref('products');
  final Reference _imagesRef = FirebaseStorage.instance.ref('images');
  final Reference _videosRef = FirebaseStorage.instance.ref('videos');

  /* getting the current user instance */
  final _currentUser = FirebaseAuth.instance.currentUser;

  ProductsBloc()
      :
        // call to super
        super(ProductsInitial(products: List.empty(), status: ProductsStatus.initialized)) {
    /* Events */
    on<PostProduct>(_handlePostProduct);
  }

  /* Post Item Handler 
    What this function does?
      - Create an entry for the product in the products path for the user in the realtime database
      
      and in order to create that entry we also first need to 
      ~ get the references to all the pictures
        and videos that the user uploaded 

      and then make an instance of the product and upload to path
      root/products/uid
  */
  FutureOr<void> _handlePostProduct(PostProduct event, Emitter<ProductsState> emit) async {
    emit(ProductsUpdate(
      products: [...state.products],
      status: ProductsStatus.processing,
    ));

    try {
      // if we have a user logged in
      if (_currentUser != null) {
        // products reference
        var userProductsRef = _productsRef.child(_currentUser!.uid);

        // get the latest snapshots of images and videos
        final latestImages = event.images;
        final latestVideos = event.videos;

        // Now we start talking to database
        // 1. get the product ref
        final DatabaseReference newProductRef = userProductsRef.push();

        // 2. create the images and videos ref in storage using product id
        List<String>? imagesURLs;
        List<String>? videosURLs;

        // upload images if there are any present
        if (latestImages != null) {
          // initialize the imagesURLs list
          imagesURLs = List.empty(growable: true);

          // get the reference to product storage
          final Reference productImagesRef =
              _imagesRef.child(newProductRef.path.split('/').last);

          // for each image in the images
          for (var image in latestImages) {
            // get the reference to user product in storage and place image there
            final Reference newProductImage = productImagesRef.child(image.name);

            // put the file in database
            await newProductImage.putFile(File(image.path));

            // get the download url
            final String downloadUrl = await newProductImage.getDownloadURL();

            // add to images url
            imagesURLs.add(downloadUrl);
          }
        }

        // upload videos if there are any present
        if (latestVideos != null) {
          // initialize the videosURLs list
          videosURLs = List.empty(growable: true);

          // get the reference to product storage
          final Reference productVideosRef =
              _videosRef.child(newProductRef.path.split('/').last);

          // for each image in the images
          for (var video in latestVideos) {
            // get the reference to user product in storage and place video there
            final Reference newProductVideo = productVideosRef.child(video.name);

            // put the file in database
            await newProductVideo.putFile(File(video.path));

            // get the download url
            final String downloadUrl = await newProductVideo.getDownloadURL();

            // add to videos url
            videosURLs.add(downloadUrl);
          }
        }

        // Now that once we have handled both images and videos
        // we will make the product instance
        final Product product = Product(
          name: event.name,
          condition: event.condition,
          location: event.location,
          price: event.price,
          category: event.category,
          description: event.description,
          color: event.color,
          year: event.year,
          images: imagesURLs,
          videos: videosURLs,
        );

        // and finally upload the product to the database
        await newProductRef.set(product.toJson());

        emit(ProductsUpdate(
          products: [...state.products, product],
          status: ProductsStatus.success,
        ));
      }
    } catch (error) {
      emit(ProductsUpdate(
        products: [...state.products],
        status: ProductsStatus.error,
        error: error.toString(),
      ));
    }
  }
}
