class PesananModel {
  String id_pesanan;
  String id_plg;
  String id_status;
  String id_ongkir;
  String id_metode_bayar;
  String alamat_pesanan;
  String nohp_pemesan;
  String waktu_pesan;
  String waktu_jemput;
  String waktu_antar;
  String catatan_pesanan;
  String total_tarif_pesanan;

  PesananModel(
    this.id_pesanan,
    this.id_plg,
    this.id_status,
    this.id_ongkir,
    this.id_metode_bayar,
    this.alamat_pesanan,
    this.nohp_pemesan,
    this.waktu_pesan,
    this.waktu_jemput,
    this.waktu_antar,
    this.catatan_pesanan,
    this.total_tarif_pesanan,
  );
}
