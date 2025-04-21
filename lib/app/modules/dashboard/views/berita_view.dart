import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Berita App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const BeritaView(),
    );
  }
}

class BeritaView extends StatelessWidget {
  const BeritaView({super.key});

  // 1. Fungsi untuk membuat menu navigasi
  Widget _buildNavItem(String text, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue[800], size: 20),
        const SizedBox(height: 4),
        Text(text, style: TextStyle(color: Colors.blue[800], fontSize: 12)),
      ],
    );
  }

  // 2. Fungsi untuk mendapatkan data berita (mock data)
  Future<List<Map<String, dynamic>>> _getBeritaData() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulasi loading
    
    return [
      {
        'judul': 'SMK ASSALAAM BANDUNG\nSEKOLAH PUSAT KEUNGGULAN',
        'cover': 'https://via.placeholder.com/400x200?text=SMK+ASSALAAM', // Ganti dengan URL gambar asli
        'kategori': 'Education',
        'penulis': 'Penulis 1',
        'subjudul': 'DISTINUUMULEI\nESTINAUMULEI',
      },
      {
        'judul': 'Kegiatan Ekstrakulikuler di SM...',
        'cover': 'https://via.placeholder.com/400x200?text=Ekstrakulikuler', // Ganti dengan URL gambar asli
        'kategori': 'Education',
        'penulis': 'Penulis 1',
      }
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text('GETTING.COM', style: TextStyle(fontSize: 20)),
            Text('EDUCATION BASED', style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.8))),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
      ),
      
      body: Column(
        children: [
          // 3. Menu Navigasi
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade300))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem('Home', Icons.home),
                _buildNavItem('Category', Icons.category),
                _buildNavItem('About', Icons.info),
                _buildNavItem('Comment', Icons.comment),
              ],
            ),
          ),
          
          // 4. Header "READING NOW"
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'READING NOW',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
          
          // 5. Daftar Berita
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _getBeritaData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (snapshot.hasError) {
                  return const Center(child: Text('Gagal memuat data'));
                }
                
                final beritaList = snapshot.data ?? [];
                
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: beritaList.length,
                  itemBuilder: (context, index) {
                    final berita = beritaList[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 6. Tampilan Gambar Berita
                          Container(
                            height: 180,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(10)),
                            ),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(10)),
                              child: Image.network(
                                berita['cover'],
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, progress) {
                                  return progress == null 
                                    ? child 
                                    : const Center(child: CircularProgressIndicator());
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
                                    child: Icon(Icons.broken_image, size: 50, color: Colors.grey));
                                },
                              ),
                            ),
                          ),
                          
                          // 7. Judul Berita
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                            child: Text(
                              berita['judul'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                            ),
                          ),
                          
                          // 8. Subjudul (hanya untuk berita pertama)
                          if (index == 0 && berita['subjudul'] != null)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                              child: Text(
                                berita['subjudul'],
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                  height: 1.4,
                                ),
                              ),
                            ),
                          
                          // 9. Kategori dan Penulis
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                            child: Row(
                              children: [
                                Icon(Icons.category, size: 16, color: Colors.grey[600]),
                                const SizedBox(width: 4),
                                Text(berita['kategori'], style: TextStyle(color: Colors.grey[600])),
                                const SizedBox(width: 16),
                                Icon(Icons.person, size: 16, color: Colors.grey[600]),
                                const SizedBox(width: 4),
                                Text(berita['penulis'], style: TextStyle(color: Colors.grey[600])),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}