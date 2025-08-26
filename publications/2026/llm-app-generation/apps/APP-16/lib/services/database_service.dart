import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/blood_pressure_reading.dart';
import '../models/user.dart';
import '../models/reminder.dart';
import '../models/health_article.dart';

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
    String path = join(await getDatabasesPath(), 'blood_pressure_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create blood_pressure_readings table
    await db.execute('''
      CREATE TABLE blood_pressure_readings(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        systolic INTEGER NOT NULL,
        diastolic INTEGER NOT NULL,
        pulse INTEGER NOT NULL,
        dateTime INTEGER NOT NULL,
        tags TEXT,
        notes TEXT,
        category INTEGER NOT NULL
      )
    ''');

    // Create users table
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        age INTEGER,
        email TEXT,
        createdAt INTEGER NOT NULL,
        updatedAt INTEGER NOT NULL
      )
    ''');

    // Create reminders table
    await db.execute('''
      CREATE TABLE reminders(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        time INTEGER NOT NULL,
        frequency INTEGER NOT NULL,
        isActive INTEGER NOT NULL,
        daysOfWeek TEXT,
        createdAt INTEGER NOT NULL,
        updatedAt INTEGER NOT NULL
      )
    ''');

    // Create health_articles table
    await db.execute('''
      CREATE TABLE health_articles(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        summary TEXT NOT NULL,
        content TEXT NOT NULL,
        category INTEGER NOT NULL,
        imageUrl TEXT,
        readTimeMinutes INTEGER NOT NULL,
        tags TEXT,
        publishedAt INTEGER NOT NULL,
        isFavorite INTEGER NOT NULL
      )
    ''');

    // Insert sample health articles
    await _insertSampleArticles(db);
  }

  Future<void> _insertSampleArticles(Database db) async {
    final sampleArticles = [
      {
        'title': 'Understanding Blood Pressure Numbers',
        'summary': 'Learn what your blood pressure readings mean and how to interpret them.',
        'content': '''Blood pressure is measured using two numbers: systolic and diastolic pressure.

**Systolic Pressure (Top Number):**
This measures the pressure in your arteries when your heart beats and pumps blood.

**Diastolic Pressure (Bottom Number):**
This measures the pressure in your arteries when your heart rests between beats.

**Normal Blood Pressure Categories:**
- Normal: Less than 120/80 mmHg
- Elevated: 120-129 systolic and less than 80 diastolic
- High Blood Pressure Stage 1: 130-139 systolic or 80-89 diastolic
- High Blood Pressure Stage 2: 140/90 mmHg or higher
- Hypertensive Crisis: Higher than 180/120 mmHg

Regular monitoring helps you understand your cardiovascular health and work with your healthcare provider to maintain optimal blood pressure levels.''',
        'category': 0, // BloodPressure
        'imageUrl': null,
        'readTimeMinutes': 3,
        'tags': 'blood pressure,health,monitoring',
        'publishedAt': DateTime.now().millisecondsSinceEpoch,
        'isFavorite': 0,
      },
      {
        'title': 'Heart-Healthy Diet Tips',
        'summary': 'Discover foods that can help lower your blood pressure naturally.',
        'content': '''A heart-healthy diet can significantly impact your blood pressure. Here are key dietary strategies:

**Foods to Include:**
- Fruits and vegetables (aim for 5-9 servings daily)
- Whole grains instead of refined grains
- Lean proteins like fish, poultry, and legumes
- Low-fat dairy products
- Nuts and seeds in moderation

**Foods to Limit:**
- Sodium (aim for less than 2,300mg daily)
- Saturated and trans fats
- Added sugars
- Processed and packaged foods
- Excessive alcohol

**The DASH Diet:**
The Dietary Approaches to Stop Hypertension (DASH) diet has been proven effective in lowering blood pressure. It emphasizes fruits, vegetables, whole grains, and lean proteins while limiting sodium and unhealthy fats.

**Practical Tips:**
- Read nutrition labels carefully
- Cook more meals at home
- Use herbs and spices instead of salt
- Choose fresh or frozen vegetables over canned
- Drink plenty of water throughout the day''',
        'category': 1, // Diet
        'imageUrl': null,
        'readTimeMinutes': 5,
        'tags': 'diet,nutrition,heart health,DASH',
        'publishedAt': DateTime.now().subtract(Duration(days: 1)).millisecondsSinceEpoch,
        'isFavorite': 0,
      },
      {
        'title': 'Exercise for Better Blood Pressure',
        'summary': 'Learn how physical activity can help manage your blood pressure effectively.',
        'content': '''Regular physical activity is one of the most effective ways to lower blood pressure naturally.

**Benefits of Exercise:**
- Strengthens your heart muscle
- Improves blood flow
- Helps maintain healthy weight
- Reduces stress and anxiety
- Improves overall cardiovascular health

**Recommended Exercise Types:**
1. **Aerobic Exercise:** 150 minutes of moderate-intensity or 75 minutes of vigorous-intensity per week
   - Walking, jogging, swimming, cycling
   - Dancing, hiking, playing sports

2. **Strength Training:** 2-3 sessions per week
   - Weight lifting, resistance bands
   - Bodyweight exercises like push-ups and squats

3. **Flexibility and Balance:** Daily stretching and balance exercises
   - Yoga, tai chi, stretching routines

**Getting Started:**
- Start slowly and gradually increase intensity
- Choose activities you enjoy
- Set realistic goals
- Track your progress
- Consult your doctor before starting a new exercise program

**Safety Tips:**
- Warm up before exercising
- Stay hydrated
- Listen to your body
- Cool down after workouts
- Monitor your blood pressure regularly''',
        'category': 2, // Exercise
        'imageUrl': null,
        'readTimeMinutes': 4,
        'tags': 'exercise,fitness,cardio,strength training',
        'publishedAt': DateTime.now().subtract(Duration(days: 2)).millisecondsSinceEpoch,
        'isFavorite': 0,
      },
      {
        'title': 'Stress Management for Heart Health',
        'summary': 'Explore techniques to manage stress and its impact on blood pressure.',
        'content': '''Chronic stress can contribute to high blood pressure. Learning to manage stress is crucial for heart health.

**How Stress Affects Blood Pressure:**
- Triggers release of stress hormones
- Causes temporary spikes in blood pressure
- May lead to unhealthy coping behaviors
- Can contribute to long-term hypertension

**Stress Management Techniques:**

1. **Deep Breathing Exercises:**
   - Practice diaphragmatic breathing
   - Try the 4-7-8 breathing technique
   - Use breathing apps for guidance

2. **Meditation and Mindfulness:**
   - Start with 5-10 minutes daily
   - Use guided meditation apps
   - Practice mindful eating and walking

3. **Physical Activity:**
   - Regular exercise reduces stress hormones
   - Releases mood-boosting endorphins
   - Provides a healthy outlet for tension

4. **Social Support:**
   - Connect with family and friends
   - Join support groups
   - Consider counseling if needed

5. **Time Management:**
   - Prioritize tasks and set realistic goals
   - Learn to say no to excessive commitments
   - Take regular breaks throughout the day

**Lifestyle Changes:**
- Maintain a regular sleep schedule
- Limit caffeine and alcohol
- Practice hobbies you enjoy
- Spend time in nature
- Consider relaxation techniques like yoga or tai chi''',
        'category': 3, // Lifestyle
        'imageUrl': null,
        'readTimeMinutes': 6,
        'tags': 'stress,relaxation,mindfulness,mental health',
        'publishedAt': DateTime.now().subtract(Duration(days: 3)).millisecondsSinceEpoch,
        'isFavorite': 0,
      },
    ];

    for (var article in sampleArticles) {
      await db.insert('health_articles', article);
    }
  }

  // Blood Pressure Reading CRUD operations
  Future<int> insertBloodPressureReading(BloodPressureReading reading) async {
    final db = await database;
    return await db.insert('blood_pressure_readings', reading.toMap());
  }

  Future<List<BloodPressureReading>> getAllBloodPressureReadings() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'blood_pressure_readings',
      orderBy: 'dateTime DESC',
    );
    return List.generate(maps.length, (i) {
      return BloodPressureReading.fromMap(maps[i]);
    });
  }

  Future<List<BloodPressureReading>> getBloodPressureReadingsByDateRange(
      DateTime startDate, DateTime endDate) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'blood_pressure_readings',
      where: 'dateTime >= ? AND dateTime <= ?',
      whereArgs: [startDate.millisecondsSinceEpoch, endDate.millisecondsSinceEpoch],
      orderBy: 'dateTime DESC',
    );
    return List.generate(maps.length, (i) {
      return BloodPressureReading.fromMap(maps[i]);
    });
  }

  Future<BloodPressureReading?> getLatestBloodPressureReading() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'blood_pressure_readings',
      orderBy: 'dateTime DESC',
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return BloodPressureReading.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateBloodPressureReading(BloodPressureReading reading) async {
    final db = await database;
    return await db.update(
      'blood_pressure_readings',
      reading.toMap(),
      where: 'id = ?',
      whereArgs: [reading.id],
    );
  }

  Future<int> deleteBloodPressureReading(int id) async {
    final db = await database;
    return await db.delete(
      'blood_pressure_readings',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // User CRUD operations
  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<User?> getUser() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users', limit: 1);
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateUser(User user) async {
    final db = await database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  // Reminder CRUD operations
  Future<int> insertReminder(Reminder reminder) async {
    final db = await database;
    return await db.insert('reminders', reminder.toMap());
  }

  Future<List<Reminder>> getAllReminders() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('reminders');
    return List.generate(maps.length, (i) {
      return Reminder.fromMap(maps[i]);
    });
  }

  Future<int> updateReminder(Reminder reminder) async {
    final db = await database;
    return await db.update(
      'reminders',
      reminder.toMap(),
      where: 'id = ?',
      whereArgs: [reminder.id],
    );
  }

  Future<int> deleteReminder(int id) async {
    final db = await database;
    return await db.delete(
      'reminders',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Health Article CRUD operations
  Future<List<HealthArticle>> getAllHealthArticles() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'health_articles',
      orderBy: 'publishedAt DESC',
    );
    return List.generate(maps.length, (i) {
      return HealthArticle.fromMap(maps[i]);
    });
  }

  Future<List<HealthArticle>> getHealthArticlesByCategory(ArticleCategory category) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'health_articles',
      where: 'category = ?',
      whereArgs: [category.index],
      orderBy: 'publishedAt DESC',
    );
    return List.generate(maps.length, (i) {
      return HealthArticle.fromMap(maps[i]);
    });
  }

  Future<int> updateHealthArticle(HealthArticle article) async {
    final db = await database;
    return await db.update(
      'health_articles',
      article.toMap(),
      where: 'id = ?',
      whereArgs: [article.id],
    );
  }

  // Close database
  Future<void> close() async {
    final db = await database;
    db.close();
  }
}