class BaseUrl {
  // static String url = "http://192.168.100.6/";
  static String url = "http://192.168.43.182/";
  // static String url = "http://10.191.214.66/";
  static String baseUrl = url + "doktersepatu/api/";
  // static String baseUrl = "http://192.168.100.6/doktersepatu/api/";
  // static String baseUrl = "http://10.191.194.226/doktersepatu/api/";

//tmepat foto
  static String beforeAfter = url + "doktersepatu/uploads/foto-before-after/";

  //login
  static String login = baseUrl + "login";

  //akun
  static String akun = baseUrl + "akun";

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
  static String riwayatSaldo = baseUrl + "riwayatsaldo";

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
  static String detailPesanan = baseUrl + "detailpesanan";
}
