import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../models/product.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  /* Firebase Realtime Database instance */
  final DatabaseReference _productsRef = FirebaseDatabase.instance.ref('products');
  final Reference _imagesRef = FirebaseStorage.instance.ref('images');
  final Reference _videosRef = FirebaseStorage.instance.ref('videos');
  late StreamSubscription _userProductsStream;

  /* getting the current user instance */
  final _currentUser = FirebaseAuth.instance.currentUser;

  ProductsBloc()
      :
        // call to super
        super(ProductsInitial(products: List.empty(), status: ProductsStatus.initialized)) {
    /* Events */
    on<PostProduct>(_handlePostProduct);
    on<Initialize>(_initializer);
    on<Dispose>(_disposer);

    /* Private Events */
    on<_Update>(_updator);
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

            await newProductVideo.putFile(File(video.path));

            // get the download url
            final String downloadUrl = await newProductVideo.getDownloadURL();
            // put the file in database

            // add to videos url
            videosURLs.add(downloadUrl);
          }
        }

        // Now that once we have handled both images and videos
        // we will make the product instance
        final Product product = Product(
          newProductRef.path.split('/').last,
          uid: _currentUser!.uid,
          name: event.name,
          condition: event.condition,
          location: event.location,
          price: event.price,
          category: event.category,
          description: event.description,
          color: event.color,
          year: event.year,
          model: event.model,
          images: imagesURLs,
          videos: videosURLs,
          quantity: event.quantity,
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

  // Get all products for the current logged in user
  FutureOr<void> _initializer(Initialize event, Emitter<ProductsState> emit) {
    emit(ProductsUpdate(products: state.products, status: ProductsStatus.processing));

    try {
      // Get the reference to the User Products
      final userProductsRef = _productsRef.child(_currentUser!.uid);

      // Subscribe to the changes under this reference
      _userProductsStream = userProductsRef.onValue.listen((event) {
        // snapshot data container
        List<Product> products = List.empty(growable: true);

        // get the latest snapshot
        DataSnapshot data = event.snapshot;

        // checking if data exists
        if (data.value != null) {
          // Parsing the values
          final parsed = data.value! as Map<dynamic, dynamic>;

          // iterate over the products under the user ref
          for (var product in parsed.values) {
            // parse the product for our product model
            final Product modalProduct = Product.fromJson(product);

            products.add(modalProduct);
          }
        }

        add(_Update(products: products));
      });

      // incase of error
    } on FirebaseException catch (error) {
      emit(ProductsUpdate(
        products: [...state.products],
        error: error.toString(),
        status: ProductsStatus.error,
      ));
    }
  }

  /* Dispose of resources occupied */
  FutureOr<void> _disposer(Dispose event, Emitter<ProductsState> emit) async {
    await _userProductsStream.cancel();
  }

  /* get a single product based on pid from user products */
  Product getProduct(String pid) {
    return state.products.firstWhere((element) => element.pid == pid);
  }

  /* Private event Handlers */
  FutureOr<void> _updator(_Update event, Emitter<ProductsState> emit) {
    emit(ProductsUpdate(products: event.products, status: ProductsStatus.updated));
  }
}
