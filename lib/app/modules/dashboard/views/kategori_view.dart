import 'package:flutter/material.dart';
import 'package:myapp/app/data/kategori_response.dart';

// Simulasi ambil data kategori dan berita-berita di dalamnya
Future<KategoriResponse> fetchKategoriWithBerita() async {
  await Future.delayed(Duration(seconds: 1)); // Simulasi delay

  return KategoriResponse.fromJson({
    "success": true,
    "data": [
      {
        "id": 1,
        "cover": "https://example.com/cover1.jpg",
        "judul": "Berita A",
        "id_user": 1,
        "id_kategori": 1,
        "isi": "Isi Berita A...",
        "created_at": "2024-01-01",
        "updated_at": "2024-01-02",
        "user": {
          "id": 1,
          "name": "Penulis A",
          "email": "penulis@example.com",
          "is_admin": 0,
          "email_verified_at": null,
          "created_at": "2024-01-01",
          "updated_at": "2024-01-02"
        },
        "kategori": {
          "id": 1,
          "nama": "Teknologi",
          "deskripsi": "Berita seputar teknologi",
          "created_at": "2024-01-01",
          "updated_at": "2024-01-01"
        }
      },
      {
        "id": 2,
        "cover": "https://example.com/cover2.jpg",
        "judul": "Berita B",
        "id_user": 2,
        "id_kategori": 1,
        "isi": "Isi Berita B...",
        "created_at": "2024-01-03",
        "updated_at": "2024-01-03",
        "user": {
          "id": 2,
          "name": "Penulis B",
          "email": "penulis2@example.com",
          "is_admin": 0,
          "email_verified_at": null,
          "created_at": "2024-01-01",
          "updated_at": "2024-01-01"
        },
        "kategori": {
          "id": 1,
          "nama": "Teknologi",
          "deskripsi": "Berita seputar teknologi",
          "created_at": "2024-01-01",
          "updated_at": "2024-01-01"
        }
      }
    ]
  });
}

class KategoriView extends StatelessWidget {
  const KategoriView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Berita per Kategori'),
      ),
      body: FutureBuilder<KategoriResponse>(
        future: fetchKategoriWithBerita(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.data == null) {
            return Center(child: Text("Data kosong."));
          }

          final beritaList = snapshot.data!.data!;
          return ListView.builder(
            itemCount: beritaList.length,
            itemBuilder: (context, index) {
              final berita = beritaList[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: ListTile(
                  leading: berita.cover != null
                      ? Image.network(berita.cover!, width: 60, fit: BoxFit.cover)
                      : Icon(Icons.image_not_supported),
                  title: Text(berita.judul ?? 'Tanpa Judul'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Kategori: ${berita.kategori?.nama ?? '-'}"),
                      Text("Penulis: ${berita.user?.name ?? '-'}"),
                      SizedBox(height: 4),
                      Text(berita.isi ?? '', maxLines: 2, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                  onTap: () {
                    // Tambahkan navigasi ke halaman detail jika perlu
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
