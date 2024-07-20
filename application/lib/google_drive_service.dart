
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/auth_io.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    drive.DriveApi.driveScope,
    drive.DriveApi.driveFileScope,
  ],
);

Future<drive.DriveApi?> getDriveApi() async {
  final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  if (googleUser == null) {
    print('Google sign-in failed');
    return null;
  }

  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  final AuthClient authClient = authenticatedClient(
    http.Client(),
    AccessCredentials(
      AccessToken(
        'Bearer',
        googleAuth.accessToken!,
        DateTime.now().add(Duration(hours: 1)).toUtc(),
      ),
      null,
      [
        drive.DriveApi.driveScope,
        drive.DriveApi.driveFileScope,
      ],
    ),
  );

  return drive.DriveApi(authClient);
}

Future<void> uploadFileToDrive(String folderId) async {
  final driveApi = await getDriveApi();
  if (driveApi == null) {
    print('Failed to get Google Drive API');
    return;
  }

  final Directory dir = Directory.current;
  final List<FileSystemEntity> entities = dir.listSync();

  for (var entity in entities) {
    if (entity is File && entity.path.endsWith('.jpg')) {
      final File file = entity;
      final drive.File driveFile = drive.File();
      driveFile.name = file.uri.pathSegments.last;
      driveFile.parents = [folderId];

      try {
        final drive.Media media = drive.Media(file.openRead(), file.lengthSync());
        final drive.File uploadedFile = await driveApi.files.create(
          driveFile,
          uploadMedia: media,
        );

        print('Uploaded file: ${uploadedFile.name}, ID: ${uploadedFile.id}');
      } catch (e) {
        print('Failed to upload file: $e');
        if (e is drive.DetailedApiRequestError) {
          print('API Request Error: ${e.status} - ${e.message}');
          if (e.status == 403) {
            print('Permission error: Ensure the user has access to the folder and the correct scopes are used.');
          }
        }
      }
    }
  }
}

void main() async {
  final String folderId = '1fCdqX7eFrpYmRYiVYjudYFh3F2i_iCkr';
  await uploadFileToDrive(folderId);
}
