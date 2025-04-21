import 'package:flutter/material.dart';
import 'package:myapp/app/data/kategori_response.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
          // Tampilkan loading indicator saat memuat data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // Tampilkan pesan error jika terjadi kesalahan
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 50, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    "Gagal memuat data",
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Silakan coba lagi nanti",
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Refresh data
                      (context as Element).markNeedsBuild();
                    },
                    child: Text("Coba Lagi"),
                  ),
                ],
              ),
            );
          }

          // Handle data kosong atau null
          final List<Data> beritaList = snapshot.data?.data ?? [];
          if (beritaList.isEmpty) {
            return _buildEmptyState();
          }

          // Group berita berdasarkan kategori
          final Map<String, List<Data>> groupedBerita = {};
          for (var berita in beritaList) {
            final kategoriNama = berita.kategori?.nama ?? 'Tanpa Kategori';
            groupedBerita.putIfAbsent(kategoriNama, () => []).add(berita);
          }

          return ListView(
            children: groupedBerita.entries.map((entry) {
              return _buildKategoriSection(entry.key, entry.value);
            }).toList(),
          );
        },
      ),
    );
  }

  // Widget untuk menampilkan state kosong
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.newspaper, size: 50, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            "Belum ada berita tersedia",
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 8),
          Text(
            "Silakan kembali lagi nanti",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // Widget untuk membangun section kategori
  Widget _buildKategoriSection(String kategoriName, List<Data> beritaList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          color: Colors.grey[300],
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            kategoriName,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...beritaList.map((berita) => _buildBeritaCard(berita)).toList(),
      ],
    );
  }

  // Widget untuk membangun card berita
  Widget _buildBeritaCard(Data berita) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: ListTile(
        leading: berita.cover != null
            ? Image.network(
                berita.cover!,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.broken_image);
                },
              )
            : Icon(Icons.image_not_supported),
        title: Text(berita.judul ?? 'Tanpa Judul'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Penulis: ${berita.user?.name ?? '-'}"),
            SizedBox(height: 4),
            Text(
              berita.isi ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        onTap: () {
          // Navigasi ke detail berita
        },
      ),
    );
  }
}

// Fungsi untuk mengambil data dari API dengan fallback data default
Future<KategoriResponse> fetchKategoriWithBerita() async {
  try {
    // Ganti dengan API call sebenarnya
    final response = await http.get(Uri.parse('YOUR_API_ENDPOINT'));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return KategoriResponse.fromJson(data);
    } else {
      // Return data default jika API error
      return _getDefaultData();
    }
  } catch (e) {
    // Return data default jika terjadi exception
    return _getDefaultData();
  }
}

// Fungsi untuk menyediakan data default
KategoriResponse _getDefaultData() {
  return KategoriResponse(
    success: false,
    data: [
      Data(
        id: 1,
        judul: "Contoh Berita 1",
        isi: "Ini adalah contoh berita default yang ditampilkan ketika data kosong atau terjadi error.",
        user: User(name: "Admin", email: "admin@example.com"),
        kategori: Kategori(nama: "Umum", deskripsi: "Kategori umum"),
      ),
      Data(
        id: 2,
        judul: "Contoh Berita 2",
        isi: "Berita contoh lainnya untuk memberikan gambaran bagaimana tampilan seharusnya.",
        user: User(name: "Redaksi", email: "redaksi@example.com"),
        kategori: Kategori(nama: "Teknologi", deskripsi: "Berita teknologi terbaru"),
      ),
    ],
  );
}