import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../data/perfil_service.dart';
import '../models/perfil_model.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  final PerfilService service = PerfilService();
  final ImagePicker picker = ImagePicker();

  late Future<PerfilModel> futurePerfil;
  bool isUploading = false;

  @override
  void initState() {
    super.initState();
    futurePerfil = service.getPerfil();
  }

  Future<void> recargarPerfil() async {
    setState(() {
      futurePerfil = service.getPerfil();
    });
  }

  Future<void> seleccionarYSubirFoto() async {
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (pickedFile == null) return;

    setState(() {
      isUploading = true;
    });

    try {
      await service.subirFotoPerfil(File(pickedFile.path));

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Foto de perfil actualizada correctamente'),
        ),
      );

      await recargarPerfil();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isUploading = false;
        });
      }
    }
  }

  Widget infoTile(String label, String value) {
    return Card(
      child: ListTile(
        title: Text(label),
        subtitle: Text(value.isEmpty ? 'No disponible' : value),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        actions: [
          IconButton(
            onPressed: isUploading ? null : seleccionarYSubirFoto,
            icon: isUploading
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.photo_camera),
          ),
        ],
      ),
      body: FutureBuilder<PerfilModel>(
        future: futurePerfil,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text('No se pudo cargar el perfil'),
            );
          }

          final perfil = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 55,
                  backgroundImage: perfil.fotoUrl.isNotEmpty
                      ? NetworkImage(perfil.fotoUrl)
                      : null,
                  child: perfil.fotoUrl.isEmpty
                      ? const Icon(Icons.person, size: 50)
                      : null,
                ),
                const SizedBox(height: 16),
                Text(
                  '${perfil.nombre} ${perfil.apellido}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                infoTile('Matrícula', perfil.matricula),
                infoTile('Correo', perfil.correo),
                infoTile('Rol', perfil.rol),
                infoTile('Grupo', perfil.grupo),
              ],
            ),
          );
        },
      ),
    );
  }
}