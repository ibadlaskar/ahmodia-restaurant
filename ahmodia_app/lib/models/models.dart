// lib/models/models.dart

// ─── Menu Item ───────────────────────────────────────────────
class MenuItem {
  final String id;
  final String name;
  final String category;
  final String emoji;
  final String description;
  final double price;
  final double? halfPrice;   // null if not a rice pack
  final bool isPopular;
  final bool isPack;         // true = rice pack (has size options)
  final List<String> tags;

  MenuItem({
    required this.id,
    required this.name,
    required this.category,
    required this.emoji,
    required this.description,
    required this.price,
    this.halfPrice,
    this.isPopular = false,
    this.isPack = false,
    this.tags = const [],
  });
}

// ─── Addon ───────────────────────────────────────────────────
class Addon {
  final String id;
  final String name;
  final String description;
  final String emoji;
  final double price;

  const Addon({
    required this.id,
    required this.name,
    required this.description,
    required this.emoji,
    required this.price,
  });
}

// ─── Cart Item ───────────────────────────────────────────────
class CartItem {
  final String uid;           // unique cart entry id
  final String name;
  final String emoji;
  final String subtitle;
  final String size;          // 'half' | 'full' | ''
  final List<String> addons;  // addon names
  double unitPrice;
  int qty;

  CartItem({
    required this.uid,
    required this.name,
    required this.emoji,
    required this.subtitle,
    this.size = '',
    this.addons = const [],
    required this.unitPrice,
    this.qty = 1,
  });

  double get total => unitPrice * qty;
}

// ─── Order ───────────────────────────────────────────────────
class OrderModel {
  final String orderId;
  final String userId;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final List<Map<String, dynamic>> items;
  final double total;
  String status;
  final String paymentMethod;
  String paymentStatus;
  String? agentName;
  final DateTime createdAt;

  OrderModel({
    required this.orderId,
    required this.userId,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.items,
    required this.total,
    this.status = 'Pending',
    required this.paymentMethod,
    this.paymentStatus = 'pending',
    this.agentName,
    required this.createdAt,
  });

  factory OrderModel.fromFirestore(Map<String, dynamic> data) {
    return OrderModel(
      orderId: data['orderId'] ?? '',
      userId: data['userId'] ?? '',
      customerName: data['customer']?['name'] ?? '',
      customerPhone: data['customer']?['phone'] ?? '',
      customerAddress: data['customer']?['address'] ?? '',
      items: List<Map<String, dynamic>>.from(data['items'] ?? []),
      total: (data['total'] ?? 0).toDouble(),
      status: data['status'] ?? 'Pending',
      paymentMethod: data['payment']?['method'] ?? 'COD',
      paymentStatus: data['payment']?['status'] ?? 'pending',
      agentName: data['delivery']?['agentName'],
      createdAt: (data['createdAt'] as dynamic)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'orderId': orderId,
    'userId': userId,
    'customer': {
      'name': customerName,
      'phone': customerPhone,
      'address': customerAddress,
    },
    'items': items,
    'total': total,
    'status': status,
    'payment': {
      'method': paymentMethod,
      'status': paymentStatus,
    },
    'delivery': {
      'agentName': agentName ?? '',
    },
    'createdAt': createdAt,
  };
}

// ─── User Profile ─────────────────────────────────────────────
class UserProfile {
  final String uid;
  final String name;
  final String email;
  final String photo;
  String phone;
  String address;
  int orderCount;
  double totalSpent;

  UserProfile({
    required this.uid,
    required this.name,
    required this.email,
    required this.photo,
    this.phone = '',
    this.address = '',
    this.orderCount = 0,
    this.totalSpent = 0,
  });

  factory UserProfile.fromFirestore(String uid, Map<String, dynamic> data) {
    return UserProfile(
      uid: uid,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      photo: data['photo'] ?? '',
      phone: data['phone'] ?? '',
      address: data['address'] ?? '',
      orderCount: data['orderCount'] ?? 0,
      totalSpent: (data['totalSpent'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'name': name,
    'email': email,
    'photo': photo,
    'phone': phone,
    'address': address,
    'orderCount': orderCount,
    'totalSpent': totalSpent,
  };
}

// ─── Static Data ──────────────────────────────────────────────
class AppData {
  static final List<Addon> addons = [
    Addon(id:'chicken', name:'Chicken Curry',   emoji:'🍗', description:'Tender pieces in spiced gravy',       price:80),
    Addon(id:'mutton',  name:'Mutton Curry',    emoji:'🥩', description:'Slow-cooked mutton masala',           price:120),
    Addon(id:'fish',    name:'Fish Curry',      emoji:'🐟', description:'Fresh fish in tangy curry',           price:90),
    Addon(id:'prawn',   name:'Prawn Masala',    emoji:'🦐', description:'Juicy prawns in spicy masala',        price:110),
    Addon(id:'egg',     name:'Egg Curry',       emoji:'🥚', description:'Boiled eggs in onion gravy',          price:50),
    Addon(id:'dal',     name:'Dal Tadka',       emoji:'🫘', description:'Yellow dal with ghee tempering',      price:40),
    Addon(id:'veg',     name:'Mixed Veg Curry', emoji:'🥕', description:'Seasonal vegetables in masala',       price:45),
    Addon(id:'paneer',  name:'Paneer Curry',    emoji:'🧀', description:'Cottage cheese in rich tomato gravy', price:70),
    Addon(id:'raita',   name:'Raita',           emoji:'🥛', description:'Yogurt with cucumber & spices',       price:30),
    Addon(id:'pickle',  name:'Mango Pickle',    emoji:'🥭', description:'Homemade spicy mango pickle',         price:15),
    Addon(id:'papad',   name:'Papad (2 pcs)',   emoji:'🫓', description:'Crispy roasted papad',                price:10),
  ];

  static final List<MenuItem> menu = [
    // Rice Packs
    MenuItem(id:'rp1', name:'Half Rice Pack',   category:'Rice Pack', emoji:'🍚',
      description:'~300g steamed rice. Add your favourite curries below!',
      price:130, halfPrice:80, isPack:true),
    MenuItem(id:'rp2', name:'Full Rice Pack',   category:'Rice Pack', emoji:'🍛',
      description:'~500g steamed rice. Perfect for a hearty meal!',
      price:130, halfPrice:80, isPack:true, isPopular:true),

    // Thalis
    MenuItem(id:'th1', name:'Chicken Thali',    category:'Thali', emoji:'🍗',
      description:'Full rice + Chicken curry + Dal + Papad + Pickle',
      price:210, isPopular:true, tags:['Bestseller','Non-Veg']),
    MenuItem(id:'th2', name:'Fish Thali',       category:'Thali', emoji:'🐟',
      description:'Full rice + Fish curry + Dal + Raita + Pickle',
      price:220, tags:['Popular','Non-Veg']),
    MenuItem(id:'th3', name:'Mutton Thali',     category:'Thali', emoji:'🥩',
      description:'Full rice + Mutton curry + Raita + Papad',
      price:260, tags:['Premium','Non-Veg']),
    MenuItem(id:'th4', name:'Veg Thali',        category:'Thali', emoji:'🥗',
      description:'Full rice + 2 Veg curries + Dal + Raita + Papad',
      price:150, tags:['Veg']),
    MenuItem(id:'th5', name:'Prawn Thali',      category:'Thali', emoji:'🦐',
      description:'Full rice + Prawn masala + Dal + Pickle',
      price:240, isPopular:true, tags:['Special','Non-Veg']),
    MenuItem(id:'th6', name:'Egg Thali',        category:'Thali', emoji:'🥚',
      description:'Full rice + Egg curry + Dal + Papad',
      price:160, tags:['Non-Veg']),

    // Curries
    MenuItem(id:'cu1', name:'Chicken Curry',    category:'Curry', emoji:'🍗',
      description:'Tender chicken in rich spiced gravy', price:80, isPopular:true),
    MenuItem(id:'cu2', name:'Mutton Curry',     category:'Curry', emoji:'🥩',
      description:'Slow-cooked mutton in masala', price:120),
    MenuItem(id:'cu3', name:'Fish Curry',       category:'Curry', emoji:'🐟',
      description:'Fresh fish in tangy curry base', price:90),
    MenuItem(id:'cu4', name:'Dal Tadka',        category:'Curry', emoji:'🫘',
      description:'Yellow dal with ghee tempering', price:40, isPopular:true),

    // Sides
    MenuItem(id:'si1', name:'Raita',            category:'Sides', emoji:'🥛',
      description:'Yogurt with fresh cucumber & spices', price:30),
    MenuItem(id:'si2', name:'Papad (2 pcs)',    category:'Sides', emoji:'🫓',
      description:'Crispy roasted papad', price:10),
    MenuItem(id:'si3', name:'Mango Pickle',     category:'Sides', emoji:'🥭',
      description:'Spicy homemade mango pickle', price:15),

    // Drinks
    MenuItem(id:'dr1', name:'Nimbu Paani',      category:'Drinks', emoji:'🍋',
      description:'Fresh lime water with salt or sweet', price:30, isPopular:true),
    MenuItem(id:'dr2', name:'Sweet Lassi',      category:'Drinks', emoji:'🥛',
      description:'Thick creamy sweet lassi', price:40),
    MenuItem(id:'dr3', name:'Chaas / Buttermilk', category:'Drinks', emoji:'🫗',
      description:'Spiced thin buttermilk with jeera', price:25),
    MenuItem(id:'dr4', name:'Mineral Water',    category:'Drinks', emoji:'💧',
      description:'500ml chilled water bottle', price:20),
  ];

  static const statusList = [
    'Pending', 'Confirmed', 'Preparing', 'Out for Delivery', 'Delivered'
  ];

  static const statusIcons = {
    'Pending':          '⏳',
    'Confirmed':        '✅',
    'Preparing':        '👨‍🍳',
    'Out for Delivery': '🏍️',
    'Delivered':        '🎉',
  };
}
