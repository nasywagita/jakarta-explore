import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'jakarta_explore.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add profileImage column if migrating from version 1
      try {
        await db.execute('ALTER TABLE users ADD COLUMN profileImage TEXT');
      } catch (e) {
        // Column might already exist if app was reinstalled
      }
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id TEXT PRIMARY KEY,
        name TEXT,
        email TEXT UNIQUE,
        password TEXT,
        totalPoints INTEGER DEFAULT 0,
        totalQuizCompleted INTEGER DEFAULT 0,
        createdAt TEXT,
        profileImage TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE bookmarks(
        userId TEXT,
        destinationId TEXT,
        PRIMARY KEY (userId, destinationId),
        FOREIGN KEY (userId) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE quiz_scores(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId TEXT,
        quizId TEXT,
        score INTEGER,
        createdAt TEXT,
        FOREIGN KEY (userId) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Seed dummy users for leaderboard
    final List<Map<String, dynamic>> dummyUsers = [
      {'id': 'dummy1', 'name': 'Aksara Bintang', 'email': 'bintang@example.com', 'password': '123', 'totalPoints': 850, 'totalQuizCompleted': 12, 'createdAt': DateTime.now().toIso8601String()},
      {'id': 'dummy2', 'name': 'Abelia Arjuna', 'email': 'abelia@example.com', 'password': '123', 'totalPoints': 720, 'totalQuizCompleted': 10, 'createdAt': DateTime.now().toIso8601String()},
      {'id': 'dummy3', 'name': 'Bumi Bimantara', 'email': 'bima@example.com', 'password': '123', 'totalPoints': 640, 'totalQuizCompleted': 8, 'createdAt': DateTime.now().toIso8601String()},
      {'id': 'dummy4', 'name': 'Aditama Yunevil', 'email': 'tama@example.com', 'password': '123', 'totalPoints': 510, 'totalQuizCompleted': 6, 'createdAt': DateTime.now().toIso8601String()},
      {'id': 'dummy5', 'name': 'Kai Kamal', 'email': 'kamal@example.com', 'password': '123', 'totalPoints': 430, 'totalQuizCompleted': 5, 'createdAt': DateTime.now().toIso8601String()},
    ];
    
    for (var user in dummyUsers) {
      await db.insert('users', user);
    }
  }

  // --- USER CRUD ---

  Future<UserModel?> login(String email, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (maps.isNotEmpty) {
      return await _getUserWithBookmarks(maps.first);
    }
    return null;
  }

  Future<bool> register(UserModel user) async {
    final db = await database;
    try {
      await db.insert(
        'users',
        {
          'id': user.id,
          'name': user.name,
          'email': user.email,
          'password': user.password,
          'totalPoints': user.totalPoints,
          'totalQuizCompleted': user.totalQuizCompleted,
          'createdAt': user.createdAt.toIso8601String(),
          'profileImage': user.profileImage,
        },
        conflictAlgorithm: ConflictAlgorithm.fail, // Fail if email exists
      );
      return true;
    } catch (e) {
      return false; // Registration failed (e.g., email already exists)
    }
  }

  Future<UserModel> getUserById(String id) async {
    final db = await database;
    final maps = await db.query('users', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return await _getUserWithBookmarks(maps.first);
    }
    throw Exception('User not found');
  }

  Future<UserModel> _getUserWithBookmarks(Map<String, dynamic> userMap) async {
    final db = await database;
    final userId = userMap['id'] as String;
    
    // Get bookmarks
    final bookmarkMaps = await db.query(
      'bookmarks',
      columns: ['destinationId'],
      where: 'userId = ?',
      whereArgs: [userId],
    );
    final bookmarkedIds = bookmarkMaps.map((e) => e['destinationId'] as String).toList();

    return UserModel(
      id: userId,
      name: userMap['name'] as String,
      email: userMap['email'] as String,
      password: userMap['password'] as String,
      totalPoints: userMap['totalPoints'] as int,
      totalQuizCompleted: userMap['totalQuizCompleted'] as int,
      createdAt: DateTime.parse(userMap['createdAt'] as String),
      bookmarkedIds: bookmarkedIds,
      profileImage: userMap['profileImage'] as String?,
    );
  }

  Future<void> updateUserScore(String userId, int addedPoints) async {
    final db = await database;
    await db.rawUpdate(
      'UPDATE users SET totalPoints = totalPoints + ?, totalQuizCompleted = totalQuizCompleted + 1 WHERE id = ?',
      [addedPoints, userId],
    );
  }

  Future<void> updateUserInfo(String userId, String name, String? email, String? profileImage) async {
    final db = await database;
    await db.update(
      'users',
      {
        'name': name,
        if (email != null) 'email': email,
        if (profileImage != null) 'profileImage': profileImage,
      },
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  // --- BOOKMARKS ---

  Future<void> addBookmark(String userId, String destinationId) async {
    final db = await database;
    await db.insert(
      'bookmarks',
      {'userId': userId, 'destinationId': destinationId},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<void> removeBookmark(String userId, String destinationId) async {
    final db = await database;
    await db.delete(
      'bookmarks',
      where: 'userId = ? AND destinationId = ?',
      whereArgs: [userId, destinationId],
    );
  }

  // --- LEADERBOARD / SCORES ---

  Future<void> addQuizScore(String userId, String quizId, int score) async {
    final db = await database;
    await db.insert('quiz_scores', {
      'userId': userId,
      'quizId': quizId,
      'score': score,
      'createdAt': DateTime.now().toIso8601String(),
    });
    // Also update user's total points
    await updateUserScore(userId, score);
  }

  Future<List<Map<String, dynamic>>> getLeaderboard() async {
    final db = await database;

    // Pastikan ada user lain (dummy) jika database baru/kosong agar papan peringkat ramai
    final List<Map<String, dynamic>> users = await db.query('users');
    if (users.length <= 1) {
      final List<Map<String, dynamic>> dummyUsers = [
        {'id': 'dummy1', 'name': 'Budi Santoso', 'email': 'budi@example.com', 'password': '123', 'totalPoints': 850, 'totalQuizCompleted': 12, 'createdAt': DateTime.now().toIso8601String()},
        {'id': 'dummy2', 'name': 'Siti Aminah', 'email': 'siti@example.com', 'password': '123', 'totalPoints': 720, 'totalQuizCompleted': 10, 'createdAt': DateTime.now().toIso8601String()},
        {'id': 'dummy3', 'name': 'Agus Prayogo', 'email': 'agus@example.com', 'password': '123', 'totalPoints': 640, 'totalQuizCompleted': 8, 'createdAt': DateTime.now().toIso8601String()},
        {'id': 'dummy4', 'name': 'Dewi Lestari', 'email': 'dewi@example.com', 'password': '123', 'totalPoints': 510, 'totalQuizCompleted': 6, 'createdAt': DateTime.now().toIso8601String()},
        {'id': 'dummy5', 'name': 'Rizky Pratama', 'email': 'rizky@example.com', 'password': '123', 'totalPoints': 430, 'totalQuizCompleted': 5, 'createdAt': DateTime.now().toIso8601String()},
      ];
      for (var user in dummyUsers) {
        await db.insert('users', user, conflictAlgorithm: ConflictAlgorithm.ignore);
      }
    }

    // Get top users ordered by totalPoints
    return await db.query(
      'users',
      columns: ['id', 'name', 'totalPoints', 'profileImage'],
      orderBy: 'totalPoints DESC',
      limit: 10,
    );
  }
}
