class BaseUrl {
  // static String url = "http://192.168.100.6/";
  // static String url = "http://192.168.100.6/doktersepatu/";
  // static String url = "http://192.168.43.182/";
  static String url = "https://doktersepatu.000webhostapp.com/";
  // static String url = "http://doktersepatu.codebanua.me/";

  // static String baseUrl = url + "doktersepatu/api/";
  static String baseUrl = url + "api/";

//tmepat foto
  // static String beforeAfter = url + "doktersepatu/uploads/foto-before-after/";
  // static String fotoArtikel = url + "dokters epatu/uploads/foto-artikel/";

  static String beforeAfter = url + "uploads/foto-before-after/";
  static String fotoArtikel = url + "uploads/foto-artikel/";

  //login
  static String login = baseUrl + "login";

  //akun
  static String akun = baseUrl + "akun/";
  static String editProfil = akun + "editProfil";

  // rekening
  static String rekening = baseUrl + "rekening";

  //deposit
  static String deposit = baseUrl + "deposit";
  static String lastDeposit = baseUrl + "deposit/lastdeposit";

  //jasa
  static String jasa = baseUrl + "jasa";

  //ongkir
  static String ongkir = baseUrl + "ongkir";

  //status
  static String status = baseUrl + "status";

  //metode bayar
  static String metode = baseUrl + "metode";

  //riwayat saldo
  static String riwayatSaldo = baseUrl + "RiwayatSaldo";

  //artikel
  static String artikel = baseUrl + "artikel";
  static String dilihat = artikel + "/dilihat";
  static String artikelTerbaru = artikel + "/terbaru";
  static String artikelFavorit = artikel + "/favorit";

  //artikel
  static String admin = baseUrl + "admin";

  //registrasi
  static String registrasi = baseUrl + "registrasi";

  //pesanan
  static String pesanan = baseUrl + "pesanan";
  static String pesananProses = baseUrl + "pesanan/proses";
  static String pesananSelesai = baseUrl + "pesanan/selesai";
  static String detailPesanan = baseUrl + "DetailPesanan";
}
