import 'package:flutter/material.dart';
import 'package:myapp/app/data/berita_response.dart';

// Misal data kamu sudah didecode ke dalam BeritaResponse
// Buat dummy function untuk ambil data, ganti nanti dengan API
Future<BeritaResponse> fetchBerita() async {
  // Replace this with actual API call
  await Future.delayed(Duration(seconds: 1)); // Simulasi delay
  return BeritaResponse.fromJson({
    "success": true,
    "data": [
      {
        "id": 1,
        "cover": "https://example.com/image.jpg",
        "judul": "Judul Berita 1",
        "id_user": 1,
        "id_kategori": 1,
        "isi": "Isi berita lengkap...",
        "created_at": "2024-01-01",
        "updated_at": "2024-01-01",
        "user": {
          "id": 1,
          "name": "Penulis 1",
          "email": "email@example.com",
          "is_admin": 0,
          "email_verified_at": null,
          "created_at": "2024-01-01",
          "updated_at": "2024-01-01"
        },
        "kategori": {
          "id": 1,
          "nama": "Teknologi",
          "deskripsi": "Berita teknologi",
          "created_at": "2024-01-01",
          "updated_at": "2024-01-01"
        }
      }
    ]
  });
}

class BeritaView extends StatelessWidget {
  const BeritaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Berita'),
      ),
      body: FutureBuilder<BeritaResponse>(
        future: fetchBerita(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Terjadi kesalahan: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.data == null) {
            return Center(child: Text("Tidak ada data."));
          }

          List<Data> beritaList = snapshot.data!.data!;

          return ListView.builder(
            itemCount: beritaList.length,
            itemBuilder: (context, index) {
              final berita = beritaList[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: berita.cover != null
                      ? Image.network(
                          berita.cover!,
                          width: 60,
                          fit: BoxFit.cover,
                        )
                      : null,
                  title: Text(berita.judul ?? 'Judul tidak tersedia'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Kategori: ${berita.kategori?.nama ?? '-'}"),
                      Text("Penulis: ${berita.user?.name ?? '-'}"),
                    ],
                  ),
                  onTap: () {
                    // Tambahkan aksi jika ingin ke detail
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
