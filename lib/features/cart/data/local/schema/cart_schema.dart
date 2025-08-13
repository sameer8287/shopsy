class CartSchema {
  static const String tableName = 'cart';

  // static const String columnId = 'id';
  static const String columnProductId = 'product_id';
  static const String columnQuantity = 'quantity';
  static const String columnCreatedAt = 'created_at';
  static const String columnUpdatedAt = 'updated_at';
  static const String columnPrice = 'price';
  static const String columnProductData = 'product_data';

  static const String createTableQuery =
      '''
    CREATE TABLE IF NOT EXISTS $tableName (
      $columnProductId TEXT NOT NULL PRIMARY KEY,
      $columnQuantity INTEGER NOT NULL,
      $columnCreatedAt TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
      $columnUpdatedAt TEXT NOT NULL,
      $columnPrice REAL NOT NULL,
      $columnProductData TEXT NOT NULL
    )
  ''';
}
