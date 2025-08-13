import 'package:image_picker/image_picker.dart';

import 'camera_gallery_service.dart';

// implementacion del paquete image_picker para poder tomar fotos y seleccionar imágenes
class CameraGalleryServiceImpl extends CameraGalleryService {
  // instancia de la clase ImagePicker
  final ImagePicker _picker = ImagePicker();

  @override
  Future<String?> takePhoto() async{
    // toma una foto con la cámara del dispositivo
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80, // definimos la calidad de la imagen
      preferredCameraDevice: CameraDevice.rear, // definimos el dispositivo de la cámara, rear o front
    );

    if(photo == null) return null;
    print('Photo path: ${photo.path}');
    // el path de las imagenes es un lugar temporal donde se guardan las imágenes dentro del dispositivo
    return photo.path;
  }

  @override
  Future<String?> selectPhoto() async{
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80, // definimos la calidad de la imagen
    );

    if(image == null) return null;
    print('image path: ${image.path}');
    return image.path;
  }
}