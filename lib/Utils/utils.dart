// ignore_for_file: unnecessary_null_comparison
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

// for picking up image from gallery
pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: source);
  file = await _cropImage(imageFile: file!);
  file = await customCompressed(imagePathToCompress: file!);
  if (file != null) {
    return await file.readAsBytes();
  }
  debugPrint('No Image Selected');
}

Future<XFile> customCompressed({
  required XFile imagePathToCompress,
  quality = 1000,
  percentage = 0.2,
}) async {
  var pathimage = await FlutterNativeImage.compressImage(
    imagePathToCompress.path,
  );
  return XFile(pathimage.path);
}

Future<XFile?> _cropImage({required XFile imageFile}) async {
  CroppedFile? croppedImage =
      await ImageCropper().cropImage(sourcePath: imageFile.path);
  if (croppedImage == null) return null;
  return XFile(croppedImage.path);
}

// for displaying snackbars
showSnackBar(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}
