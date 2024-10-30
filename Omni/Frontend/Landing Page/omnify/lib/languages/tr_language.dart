// ignore_for_file: camel_case_types, annotate_overrides

import 'app_language.dart';

class TR_Language implements AppLanguage {
  final String home1 = "Ana Sayfa";
  final String home2 = "Kaşif";
  final String home3 = "Yönetim";
  final String home4 = "Ücretler";
  final String home5 = "Uygulamayı aç";
  final String home6 = "Cüzdanı bağla";
  final String home7 = "Yeni Teklif";
  final String home8 = "Bağlandı";
  final String home9 = "Jetonlar";
  final String carTitle0 = "Omnify";
  final String carTitle1 = "Omni Havale";
  final String carTitle2 = "Omni Emanet";
  final String carTitle3 = "Omni Köprü";
  final String carTitle4 = "Omni Piyango";
  final String carTitle5 = "Omni Krediler";
  final String carTitle6 = "Omni Yönetim";
  final String carTitle7 = "Omni Ödeme";
  final String carTitle8 = "Omni Arabuluculuk";
  final String carTitle9 = "Omni Doldurucu";
  final carDescription0 =
      "Akıllı kontratların güvenliği için şeffaf işlem kolaylaştırıcı çoklu ürün ve hizmet zincirlerini bir araya getirin.";
  final carDescription1 =
      "Sınırlayıcı olarak Omnify aktarımlarından yararlanın, aktarımlara aracılık hizmeti ve aracılık hizmeti sağlayın";
  final carDescription2 =
      "Ödemeleriniz için büyük ödeme platformu: OmniPay'e toplam ödeme ve artı ödemeler";
  final carDescription3 =
      "ERC20 veya OmniTrust'ta uyumlu jetonlar için kendi deponuzu oluşturun. Faydalı olanları veya özel tahsisleri ekleyin";
  //TODO ADD NEXT SUPPORTED NETWORKS HERE
  final carDescription4 =
      "Avalche, Optimism, Binance Smart Chain, Fantom, Mantle, Gnosis, Celo, Tron, Arbitrum, ApeChain, Polygon, Base, Linea, Scroll, Blast ve ZKsync arasındaki köprülü tokenleri taşıyın veya geri getirin.\nKilitleme ve nane / yakmayı kullanır dönüş işlevinde";
  final carDescription5 = "PIYANGO ";
  final carDescription6 = "KREDİLER";
  final carDescription7 =
      "Omnify'ın yönetimine katılın ve yardımcı jetonunu tutarak toplanan ücretlerden pay alın: \$OFY";
  final carDescription8 =
      "Varlıkları teklif etmek ve teklif almak veya mevcut sözleşmeler için teklif vermek üzere yeni emanet sözleşmeleri oluşturun";
  final carDescription9 =
      "Yerel gaz jetonunuz mu azaldı? Sizi düşündük. Yerel ERC20 uyumlu jetonları takas ederek gaz jetonları edinin veya başka bir ağın gaz jetonunu takas ederek (Refueler geliştirme aşamasındadır) ";
  final transferCard1 = "Anında ödeme (aynı işlem)";
  final transferCard2 = "Sınırsız ERC20 uyumlu jeton transferleri";
  final transferCard3 = "Sınırsız yerel jeton transferleri";
  final transferCard4 = "Birden fazla benzersiz alıcı";
  final transferCard5 =
      "Akıllı sözleşme aynı işlemde sınırsız sayıda transferi destekler";
  final payCard1 = "Tek seferlik ödemeler";
  final payCard2 = "Peşinatlar";
  final payCard3 = "Aylık taksitler (maks. 10 yıl )";
  final payCard4 = "0,00% ücretle anında gelir çekimleri";
  final payCard5 = "Ödeme Ağ Geçidi API'si (URL üzerinden yönlendirme)";
  final payCard6 = "Ödeme yapmak için tarayın";
  final trustCard1 =
      "Parayı değiştirmek için sahip ayrıcalıklarına sahip olan kişiyi belirtin";
  final trustCard2 =
      "Geri çekilebilir mevduatlar sahiplerinden herhangi biri tarafından geri çekilebilir";
  final trustCard3 =
      "Değiştirilebilir mevduatlar değiştirilebilir (fon ekleme, yararlanıcı ekleme veya çıkarma, yararlanıcı ödeneğini değiştirme)";
  final trustCard4 =
      "Mevduatlar aktif olarak işaretlenmelidir çekme işlemine başlamak için";
  final trustCard5 = "Belirtilen ödenek günde bir kez çekilebilir";
  final bridgeCard1 = "ERC20 uyumlu herhangi bir varlığı destekler";
  final bridgeCard2 = "Kaynak ağındaki varlıkları kilitle";
  final bridgeCard3 = "Hedef ağdaki varlıkları bas";
  final bridgeCard4 =
      "Varlıkları kaynak zincirine geri döndürürken köprülenmiş tokenleri yak";
  final bridgeCard5 =
      "Kaynak ve OFY köprülenmiş varlıklar arasında 1:1 sabitleme";
  final escrowCard1 = "Anında anlaşma çözümü tamamlama";
  final escrowCard2 =
      "Kabul edilen teklif sahibi sözleşmede teklif edilen varlıkları alır";
  final escrowCard3 = "Sahip teklif sahibinin teklif ettiği varlıkları alır";
  final escrowCard4 = "Adrese göre sınırsız sözleşme";
  final escrowCard5 = "Aynı sözleşmede adrese göre 1 teklif";
  final refuelCard1 = "Çapraz zincir gaz jetonu takası";
  final refuelCard2 = "ERC20 gaz jetonu takası";
  final theme0 = "parlak mod";
  final theme1 = "karanlık mod";
  final theme3 = "Belgeler";
  final avalancheDescription =
      "Avalanche, sonsuza kadar ölçeklenen ve işlemleri bir saniyeden daha kısa sürede düzenli olarak sonuçlandıran bir akıllı sözleşme platformudur.";
  final optimismDescription =
      "OP Mainnet, Ethereum'un güçlü güvenlik garantilerinden yararlanırken maliyetini ve gecikmesini azaltmak için tasarlanmış bir Katman 2 İyimser Toplama ağıdır.";
  final ethereumDescription =
      "Ethereum, dijital paraya, küresel ödemelere ve uygulamalara ev sahipliği yapan bir teknolojidir.";
  final bscDescription =
      "Binance Smart Chain (BSC), Binance tarafından Eylül 2020'de başlatılan bir blockchain ağıdır.";
  final arbitrumDescription =
      "Arbitrum, en büyük Katman 1 ekosistemi olan Ethereum'u keşfetmenize ve inşa etmenize olanak tanıyan lider Katman 2 teknolojisidir.";
  final polygonDescription =
      "Polygon, Ethereum ile uyumlu çok zincirli bir blockchain sistemi oluşturmayı amaçlayan bir blockchain platformudur.";
  final fantomDescription =
      "Fantom, DeFi, kripto dApp'ler ve kurumsal uygulamalar için yüksek düzeyde ölçeklenebilir bir blockchain platformudur.";
  final tronDescription =
      "TRON, akıllı sözleşme işlevine, fikir birliği algoritması olarak hisse kanıtı ilkelerine ve Tronix (TRX) olarak bilinen, sisteme özgü bir kripto para birimine sahip, merkezi olmayan, blockchain tabanlı bir işletim sistemidir.";
  final baseDescription =
      "Base, zincir üstü uygulamalar oluşturmak için güvenli, uygun maliyetli ve geliştirici dostu bir ortam sağlamak amacıyla Optimism ortaklığıyla kripto para borsası Coinbase tarafından geliştirilen bir Ethereum Layer 2 çözümüdür.";
  final lineaDescription =
      "Linea, kullanım kolaylığını, ölçeklenebilirliği ve güvenliği vurgulayarak işletmeler için blockchain'in benimsenmesini kolaylaştırmak üzere tasarlanmıştır. Finanstan tedarik zincirine kadar çok çeşitli kurumsal uygulamaları destekler.";
  final cronosDescription =
      "Cronos, akıllı sözleşme işlevine, fikir birliği algoritması olarak hisse kanıtı ilkelerine ve CRO olarak bilinen, sisteme özgü bir kripto para birimine sahip, blockchain tabanlı bir işletim sistemidir.";
  final mantleDescription =
      "Mantle Network, Ethereum Virtual Machine (EVM) ile uyumlu bir Layer-2 ölçeklendirme çözümüdür.";
  final gnosisDescription =
      "Gnosis, merkezi olmayan finansal araçları herkes için erişilebilir ve kullanılabilir hale getirmek amacıyla ödemeler altyapısında devrim yaratan uyumlu projelerden oluşan bir kolektiftir.";
  final kavaDescription =
      "Kava, Cosmos'un yüksek işlem hızlarını Ethereum'un geliştirici dostu ortamıyla birleştiren merkezi olmayan bir blockchain platformudur.";
  final roninDescription =
      "Ronin Network, oyun için tasarlanmış EVM (Ethereum Sanal Makinesi) uyumlu bir blockchaindir.";
  final zksyncDescription =
      "zkSync, zkRollup teknolojisiyle desteklenen, Ethereum'da ölçeklenebilir düşük maliyetli ödemeler için güvenilir bir Katman 2 protokolüdür.";
  final celoDescription =
      "Celo, mobil öncelikli merkezi olmayan uygulamalar ve akıllı sözleşmeler konusunda uzmanlaşmış, blockchain tabanlı bir ekosistemdir.";
  final scrollDescription =
      "Scroll, Ethereum üzerinde yeni bir katman oluşturmak için ölçeklendirme tasarımındaki yenilikleri ve sıfır bilgi kanıtını kullanan, Ethereum için güvenlik odaklı bir ölçeklendirme çözümüdür.";
  final hederaDescription =
      "Hedera, hızlı, adil ve güvenli karma grafik konsensüsünü kullanan, tamamen açık kaynaklı, halka açık bir defterdir.";
  final blastDescription =
      "Fullstack blockchain – ETH ve stabilcoinler için yerel getiri sağlayan tek EVM blockchain.";
  final apeDescription =
      "ApeChain, ApeCoin DAO tarafından Arbitrum Orbit zinciri olarak geliştirilen yeni bir Katman-3 blok zinciridir.";
  final explorer0 = "Havaleler";
  final explorer1 = "Aktarılan değer";
  final explorer2 = "Mevduat";
  final explorer3 = "Yatırılan Değer";
  final explorer4 = "Çekilmeler";
  final explorer5 = "Çekilen Değer";
  final explorer6 = "Ödünç verilen";
  final explorer7 = "Piyango çekilişleri";
  final explorer8 = "Kazananlar";
  final explorer9 = "Dağıtılan Ödülleri";
  final explorer10 = "Ödünç alınan";
  final explorer11 = "Havaleler";
  final explorer12 = "Emanet";
  final explorer13 = "Piyango";
  final explorer14 = "Krediler";
  final explorer15 = "Ödemeler";
  final explorer16 = "Teklifler";
  final explorer17 = "Sahipler";
  final explorer18 = "Faydalanıcılar";
  final explorerHint0 = "Aktarım Numarası";
  final explorerHint1 = "Yatırım Numarası";
  final explorerHint2 = "Numarası";
  final explorerHint3 = "Sözleşme Numarası";
  final explorerHint4 = "Ödeme Numarası";
  final explorerSearch = "Ara";
  final table0 = "Alıcı";
  final table1 = 'Tutar';
  final table2 = 'Tarih';
  final table3 = 'Planlanan Tarih';
  final table4 = 'Durum';
  final table5 = 'Ücret';
  final table6 = 'Kimlik';
  final table7 = 'Yatıran';
  final table8 = 'Tutar';
  final table9 = 'Tarih';
  final table10 = 'Kilit Açılma Tarihi';
  final table11 = 'Ücret';
  final table12 = 'Durum';
  final table13 = 'Kimlik';
  final table14 = 'Çekiliş Numarası';
  final table15 = 'Ödül';
  final table16 = 'Tarih';
  final table17 = 'Kazananlar';
  final table18 = 'Kredi Alan/Borç Alan';
  final table19 = 'Tutar';
  final table20 = 'Teminat';
  final table21 = 'Yayınlanma Tarihi';
  final table22 = 'Durum';
  final table23 = 'Kararlaştırılma Tarihi';
  final table24 = 'Kredi Numarası';
  final table25 = 'Ödeyen';
  final table26 = 'Tutar';
  final table27 = 'Durum';
  final table28 = 'Alıcı';
  final table29 = 'Ödeme Tarihi';
  final table30 = 'Veri yok';
  final table31 = "Tutar";
  final table32 = "Kaynak ağı";
  final table33 = "Kaynak adresi";
  final table34 = "Hedef ağ";
  final table35 = "Hedef adres";
  final table36 = "Silindi";
  final table37 = "Tamamlandı";
  final table38 = "Devam ediyor";
  final table39 = "Sahip";
  final table40 = "Tutar";
  final table41 = "Varlık adresi";
  final table42 = "Gönderen";
  final subtable1 = "Kabul edildi";
  final subtable2 = "Kabul Edilmedi";
  final subtable3 = "Sınırsız";
  final subtable4 = "Adres";
  final subtable5 = "Teklif Veren";
  final subtable6 = "Tutar";
  final subtable7 = "Varlık Adresi";
  final subtable8 = "Durum";
  final subtable9 = "Tarih";
  final subtable10 = "Adres";
  final subtable11 = "Ödenek/gün";
  final subtable12 = "İptal edildi";
  final subtable13 = "Son Çekme";
  String governance0(int roundInterval, int coinholdDuration) =>
      "Omnify, fayda belirteci olan \$OFY tarafından yönetilir. Toplanan karlar dağıtım turlarında dağıtılır.\n\$OFY ayrıca teklifler üzerinde oylama yapmak için de gereklidir.\n 1 OFY = 1 HİSSE = 1 OY";
  final governance1 = "Teklifler";
  final governance2 = "Başarılar";
  final governance3 = "Paylar";
  final governance4 = "Teklif Ücreti: ";
  final fees1 = "Havaleler";
  final fees2 = "Ödemeler";
  final fees3 = "Emanet";
  final fees4 = "Köprü";
  final fees5 = "Arabuluculuk";
  final fees6 = "Piyango";
  final fees7 = "Krediler";
  final fees8 = "Miktar";
  final fees9 = "Temel ücret";
  final fees10 = "Planlama ücreti (isteğe bağlı)";
  final fees11 = "Ağ ücreti";
  final fees12 = "Miktar";
  final fees13 = "Yüzde (%)";
  final fees14 = "Ağ ücreti";
  final fees15 = "Miktar";
  final fees16 = "Temel ücret";
  final fees17 = "Planlama ücreti (isteğe bağlı)";
  final fees18 = "Ağ ücreti";
  final fees19 = "Miktar";
  final fees20 = "Ücret (kaynak ağda)";
  final fees21 = "Ağ ücreti";
  final fees22 = "Varlık değeri";
  final fees23 = "Sözleşme ücreti";
  final fees24 = "Ağ ücreti";
  final fees25 = "Fiyat/kombinasyon";
  final fees26 = "Ağ ücreti (nft + gaz)";
  final fees27 = "Miktar";
  final fees28 = "Faiz (%)";
  final fees29 = "Alternatif paralar: ";
  final fees30 = "/ödeme";
  final fees31 = "/taksit";
  final fees32 = "/yatırım";
  final fees33 = "/yararlanıcı";
  final fees34 = "/işlem";
  final fees35 = "/sözleşme";
  final fees36 = "Doldurucu";
  final shares = "Hisseleriniz: ";
  final shares2 = "Karınız: ";
  final shares3 = "Dağıtılan Kâr: ";
  String shares4(int d) =>
      "Sorumluluk reddi: Omni jetonları, dağıtım turundan elde edilen kârın çekilmesinden $d gün önce alınmalıdır.";
  final shares5 = "Dağıtım Turları";
  final shares6 =
      "Çekilmeye uygun hisselerinizi ve karlarınızı görmek için cüzdanınızı bağlayın";
  final shares7 = "Tur";
  final shares8 = "Çekilen ";
  final shares9 = "Kalan ";
  final shares10 = "Toplanan Ücretler: ";
  final shares11 = "Kar/hisse: ";
  final shares12 = "Çekilen Karlar: ";
  final shares13 = "Kalan Kâr: ";
  final shares14 = "Kesiminiz: ";
  final shares15 = "Açık";
  final shares16 = "Kapalı";
  final shares17 = "Çekildi";
  final shares18 = "Çek";
  final shares19 = "Mevcut Karlar: ";
  String shares20(int d) =>
      "Omnify dağıtım turları, mevcut kar 1 jeton ve üzerinde olduğunda her $d günde bir tetiklenir.";
  final yes = "EVET";
  final no = "HAYIR";
  final proposal1 = "Gönder";
  final proposal2 = "Teklif Adı";
  final proposal3 = "Teklif Açıklaması";
  final paste = "Yapıştır";
  final changingNetwork = "Ağ Geçişi";
  final transacting = "İşleniyor...";
  final transactionSent = "İşlem gönderildi";
  final transactionSent2 = "İşlem blockchain'e gönderildi!";
  final toasts21 = "Doğrulama başarısız";
  final toasts22 = "Omnify için ödenek ";
  final toasts23 = "Alınamadı";
  final toasts24 = "Ödenek Talebi Başarısız";
  final toasts25 = "Omnify için ödenekler talep edilemedi";
  final toasts26 = "Yetersiz Fon";
  final toasts27 = "Yetersiz bakiye: ";
  final toasts28 = "Bağlantı Başarısız";
  final toasts29 =
      "Önceki cüzdan oturumuna yeniden bağlanılamadı, tekrar deneyin";
  final toasts30 = "İşlem gerçekleştirilemedi, tekrar deneyin";
  final toasts31 = "Ödenek Çekildi";
  final toasts32 = "";
  final toasts33 = " dakika sonra tekrar gel";
  final toast11 = "Onaylar İsteniyor";
  final toast12 = "Ödeneği onaylamak için cüzdandan imzalayın";
  final error1 = "Bağlantı başarısız oldu";
  final retry = "TEKRAR DENE";
  final wcsheet1 = "Bir cüzdan bağlayın";
  final wcsheet2 = "Kodu Göster";
  final wcsheet3 = "Gösterilen QR kodunu tarayarak bağlanın.";
  final wcsheet4 = "Cüzdan Seçin";
  final wcsheet5 = "Cüzdana giderek bağlanın.";
  final wcDescription = "DeFi hizmet kümesi";
  final toast5 = "Link kopyalandı";
  final wcRequest1 = "Bağlantı İstendi";
  final wcRequest2 =
      "Önceden bağlanılan cüzdanı kullanarak bağlanmak için cüzdanı açın.";
  final toast13 = "Hata";
  final toast14 = "Cüzdan bağlantısı kesilemedi";
  final toast15 = "Desteklenmeyen ağlar";
  final toasts16 =
      "Bağlanmaya çalıştığınız cüzdan, konuşlandırılan ağlarımızdan hiçbirini desteklemiyor";
  final toasts17 = "Oturumun süresi doldu";
  final toasts18 = "Cüzdan oturumunun süresi doldu, yeniden bağlantı gerekiyor";
  final showMore = 'Daha fazlasını göster';
  final timer1 = "Sonraki Tur: ";
  final timer2 = "ICO başlangıcı: ";
  final timer3 = "ICO sonu: ";
  final timer4 = "Kar şu süreden sonra çekilir: ";
  final timer5 = "Tur biter: ";
  final checkWallet = "Bağlı cüzdanı kontrol et";
  final votingEnds = "Oylama sonu:";
  final coinseller1 = "Toplam Arz: ";
  final coinseller2 = "Satılan jetonlar: ";
  final coinseller3 = "Kalan jetonlar: ";
  final coinseller4 = "Fiyat / OFY: ";
  final coinseller5 = "Toplam";
  final coinseller6 = "\$OFY al";
  final coinseller7 = "Jeton adresi";
  final coinseller8 = "Jeton adı";
  final coinseller9 = "Jeton sembolü";
  final coinseller10 = "Jeton ondalık sayıları";
  final profit = "Kâr";
  final next = "Sonraki";
  final previous = "Önceki";
}
