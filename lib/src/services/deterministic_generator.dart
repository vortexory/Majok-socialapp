import 'dart:math';

class DeterministicGenerator {
  static final DeterministicGenerator _instance = DeterministicGenerator._internal();
  factory DeterministicGenerator() => _instance;
  DeterministicGenerator._internal();

  static DeterministicGenerator get instance => _instance;

  /// Creates a deterministic seed from user inputs
  int createSeed(Map<String, dynamic> userInputs) {
    String seedString = '';
    
    // Convert all user inputs to a consistent string
    final sortedKeys = userInputs.keys.toList()..sort();
    for (String key in sortedKeys) {
      final value = userInputs[key];
      if (value != null) {
        seedString += '$key:${value.toString()}|';
      }
    }
    
    // Create a numeric seed from the string
    int seed = seedString.hashCode;
    
    // Ensure positive seed
    if (seed < 0) seed = -seed;
    
    return seed;
  }

  /// Gets a seeded Random instance
  Random getSeededRandom(int seed) {
    return Random(seed);
  }

  /// Selects items from pools using seeded randomness
  List<T> selectFromPools<T>({
    required List<List<T>> pools,
    required int seed,
    int? count,
  }) {
    final random = getSeededRandom(seed);
    final results = <T>[];
    
    for (int i = 0; i < pools.length; i++) {
      final pool = pools[i];
      if (pool.isNotEmpty) {
        // Use seed + pool index for variation between pools
        final poolRandom = Random(seed + i);
        final selectedItem = pool[poolRandom.nextInt(pool.length)];
        results.add(selectedItem);
        
        if (count != null && results.length >= count) break;
      }
    }
    
    return results;
  }

  /// Selects a single item from a pool
  T selectFromPool<T>({
    required List<T> pool,
    required int seed,
    int offset = 0,
  }) {
    if (pool.isEmpty) throw ArgumentError('Pool cannot be empty');
    
    final random = getSeededRandom(seed + offset);
    return pool[random.nextInt(pool.length)];
  }

  /// Selects multiple unique items from a single pool
  List<T> selectMultipleFromPool<T>({
    required List<T> pool,
    required int count,
    required int seed,
    int offset = 0,
  }) {
    if (pool.isEmpty) throw ArgumentError('Pool cannot be empty');
    if (count > pool.length) throw ArgumentError('Cannot select more items than available in pool');
    
    final random = getSeededRandom(seed + offset);
    final shuffled = List<T>.from(pool)..shuffle(random);
    return shuffled.take(count).toList();
  }

  /// Generates a percentage match score
  int generateMatchPercentage({
    required int seed,
    int minPercentage = 75,
    int maxPercentage = 99,
  }) {
    final random = getSeededRandom(seed);
    return minPercentage + random.nextInt(maxPercentage - minPercentage + 1);
  }
}