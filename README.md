# VitrinSepet

**VitrinSepet**, Flutter ile geliştirilmiş, kullanıcı dostu ve modern bir e-ticaret vitrin ve sepet uygulamasıdır. Bu proje, kullanıcı arayüzü tasarımı, dinamik veri yönetimi ve farklı API entegrasyonlarını öğretmek amacıyla hazırlanmıştır.

## 🚀 Özellikler

- **Çoklu Veri Kaynağı Desteği**: Uygulama, **WantAPI**, **Fake Store API** ve **DummyJSON** olmak üzere 3 farklı sağlayıcıdan veri çekebilir.
- **Dinamik Banner Alanı**: Seçilen veri kaynağına göre (WantAPI özelinde) dinamik olarak değişen arayüz elemanları.
- **Kategori Filtreleme**: Ürünleri kategorilerine göre filtreleyerek kolayca bulabilme.
- **Arama Özelliği**: Ürünler arasında isim bazlı anlık arama yapabilme.
- **Görünüm Seçenekleri**: Liste ve Izgara (Grid) görünümü arasında geçiş yapabilme.
- **Sepet Yönetimi**: Ürünleri sepete ekleme, miktar artırma/azaltma ve toplam tutarın anlık hesaplanması.
- **Modern Arayüz**: `Sliver` yapıları, animasyonlu switchler ve temiz bir tasarım dili.

## 🛠️ Kullanılan Teknolojiler

Bu projede aşağıdaki teknolojiler ve paketler kullanılmıştır:

- **[Flutter](https://flutter.dev/) & Dart**: Ana geliştirme platformu ve dili.
- **http Paketi**: REST API isteklerini yönetmek ve veri çekmek için.
- **State Management**: Harici bir kütüphane yerine Flutter'ın kendi `ValueNotifier` ve `ValueListenableBuilder` yapıları ile performanslı durum yönetimi. (Sadece gerektiği yerde `setState` kullanılmıştır).
- **Material Design 3**: Modern ve tutarlı kullanıcı arayüzü bileşenleri.

## 🌐 Kullanılan Veri Kaynakları ve Eğitim Amaçlı Açıklama

Bu proje kapsamında kullanılan aşağıdaki kaynaklar **eğitim ve demo amaçlıdır**:

### 1. WantAPI (Demo Kaynağı)
- **Banner Görseli**: `https://wantapi.com/assets/banner.png`
- **Ürün Verileri**: `https://wantapi.com/products.php`

> **Not:** Bu adresler gerçek bir e-ticaret altyapısını temsil etmez. API kullanımı, JSON veri modelleme (serializing) ve listeleme mantığını öğretmek amacıyla kullanılmıştır.

### 2. Alternatif Test API'leri (Opsiyonel)
Projede veri kaynağı çeşitliliğini ve adaptasyonu göstermek için şu servisler de entegre edilmiştir:
- **[Fake Store API](https://fakestoreapi.com/products)**: Basit ve tutarlı veri yapısıyla bilinen popüler test API'si.
- **[DummyJSON](https://dummyjson.com/products)**: Daha karmaşık veri yapıları sunan alternatif bir kaynak.

## 📂 Proje Yapısı

```
lib/
├── models/         # Veri modelleri (Product, CartItem)
├── screens/        # Uygulama ekranları (Home, Detail, Cart)
├── services/       # API servisleri ve Sepet yönetimi (State)
├── widgets/        # Tekrar kullanılabilir arayüz parçaları (ProductCard, SourceSwitch vb.)
└── main.dart       # Uygulama giriş noktası
```

## 📦 Kurulum ve Çalıştırma

Projeyi bilgisayarınızda çalıştırmak için:

1.  Bu depoyu klonlayın:
    ```bash
    git clone https://github.com/kullanici_adiniz/vitrin_sepet.git
    ```
2.  Proje dizinine gidin:
    ```bash
    cd vitrin_sepet
    ```
3.  Gerekli paketleri indirin:
    ```bash
    flutter pub get
    ```
4.  Uygulamayı başlatın:
    ```bash
    flutter run
    ```
