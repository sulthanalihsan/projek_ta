class ArtikelModel {
  String id_artikel;
  String id_adm;
  String judul_artikel;
  String tgl_artikel;
  String isi_artikel;
  String foto_header;

  ArtikelModel(this.id_artikel, this.id_adm, this.judul_artikel,
      this.tgl_artikel, this.isi_artikel, this.foto_header);

  factory ArtikelModel.fromJson(Map<String, dynamic> json) {
    return ArtikelModel(
        json['id_artikel'],
        json['id_adm'],
        json['judul_artikel'],
        json['tgl_artikel'],
        json['isi_artikel'],
        json['foto_header']);
  }
}
