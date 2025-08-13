import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_fm/features/products/domain/entity/product_entity.dart';
import 'package:pocket_fm/features/products/domain/repository/product_repository.dart';
import 'package:pocket_fm/features/products/domain/usecase/product_usecase.dart';

// Mock repository for testing
class MockProductRepository implements ProductRepository {
  final List<ProductEntity> _products = [
    ProductEntity(
      id: '1',
      title: 'Test Product 1',
      subtitle: 'Test Subtitle 1',
      description: 'Test Description 1',
      price: 9.99,
      currency: 'USD',
      type: 'Digital',
      rating: 4.5,
    ),
    ProductEntity(
      id: '2',
      title: 'Test Product 2',
      subtitle: 'Test Subtitle 2',
      description: 'Test Description 2',
      price: 19.99,
      currency: 'USD',
      type: 'Digital',
      rating: 4.8,
    ),
    ProductEntity(
      id: '3',
      title: 'Test Product 3',
      subtitle: 'Test Subtitle 3',
      description: 'Test Description 3',
      price: 29.99,
      currency: 'EUR',
      type: 'Physical',
      rating: 4.2,
    ),
  ];

  @override
  Future<List<ProductEntity>> getProductsList() async {
    return _products;
  }

  @override
  Future<ProductEntity?> getProductById(String id) async {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }
}

// Mock repository that throws exceptions for testing error scenarios
class MockProductRepositoryWithErrors implements ProductRepository {
  @override
  Future<List<ProductEntity>> getProductsList() async {
    throw Exception('Failed to fetch products');
  }

  @override
  Future<ProductEntity?> getProductById(String id) async {
    throw Exception('Failed to fetch product with id: $id');
  }
}

// Mock repository that returns empty results
class MockProductRepositoryEmpty implements ProductRepository {
  @override
  Future<List<ProductEntity>> getProductsList() async {
    return [];
  }

  @override
  Future<ProductEntity?> getProductById(String id) async {
    return null;
  }
}

void main() {
  group('ProductUseCase Tests', () {
    late ProductUseCase productUseCase;
    late MockProductRepository mockRepository;

    setUp(() {
      mockRepository = MockProductRepository();
      productUseCase = ProductUseCase(mockRepository);
    });

    group('getProducts Tests', () {
      test('should return list of products successfully', () async {
        // Act
        final result = await productUseCase.getProducts();

        // Assert
        expect(result, isA<List<ProductEntity>>());
        expect(result.length, equals(3));
        expect(result[0].title, equals('Test Product 1'));
        expect(result[1].title, equals('Test Product 2'));
        expect(result[2].title, equals('Test Product 3'));
      });

      test('should return products with correct data structure', () async {
        // Act
        final result = await productUseCase.getProducts();

        // Assert
        expect(result[0].id, equals('1'));
        expect(result[0].subtitle, equals('Test Subtitle 1'));
        expect(result[0].description, equals('Test Description 1'));
        expect(result[0].price, equals(9.99));
        expect(result[0].currency, equals('USD'));
        expect(result[0].type, equals('Digital'));
        expect(result[0].rating, equals(4.5));
      });

      test('should handle empty product list', () async {
        // Arrange
        final emptyRepository = MockProductRepositoryEmpty();
        final emptyUseCase = ProductUseCase(emptyRepository);

        // Act
        final result = await emptyUseCase.getProducts();

        // Assert
        expect(result, isA<List<ProductEntity>>());
        expect(result, isEmpty);
      });

      test('should propagate repository errors', () async {
        // Arrange
        final errorRepository = MockProductRepositoryWithErrors();
        final errorUseCase = ProductUseCase(errorRepository);

        // Act & Assert
        expect(
          () => errorUseCase.getProducts(),
          throwsA(isA<Exception>()),
        );
      });

      test('should return products with different currencies', () async {
        // Act
        final result = await productUseCase.getProducts();

        // Assert
        final usdProducts = result.where((p) => p.currency == 'USD').toList();
        final eurProducts = result.where((p) => p.currency == 'EUR').toList();

        expect(usdProducts.length, equals(2));
        expect(eurProducts.length, equals(1));
        expect(eurProducts[0].price, equals(29.99));
      });

      test('should return products with different types', () async {
        // Act
        final result = await productUseCase.getProducts();

        // Assert
        final digitalProducts = result.where((p) => p.type == 'Digital').toList();
        final physicalProducts = result.where((p) => p.type == 'Physical').toList();

        expect(digitalProducts.length, equals(2));
        expect(physicalProducts.length, equals(1));
        expect(physicalProducts[0].title, equals('Test Product 3'));
      });
    });

    group('getProductById Tests', () {
      test('should return product when valid ID is provided', () async {
        // Act
        final result = await productUseCase.getProductById('1');

        // Assert
        expect(result, isNotNull);
        expect(result!.id, equals('1'));
        expect(result.title, equals('Test Product 1'));
        expect(result.price, equals(9.99));
      });

      test('should return correct product for different IDs', () async {
        // Act
        final result1 = await productUseCase.getProductById('2');
        final result2 = await productUseCase.getProductById('3');

        // Assert
        expect(result1!.id, equals('2'));
        expect(result1.title, equals('Test Product 2'));
        expect(result1.price, equals(19.99));

        expect(result2!.id, equals('3'));
        expect(result2.title, equals('Test Product 3'));
        expect(result2.price, equals(29.99));
        expect(result2.currency, equals('EUR'));
      });

      test('should return null when product ID does not exist', () async {
        // Act
        final result = await productUseCase.getProductById('999');

        // Assert
        expect(result, isNull);
      });

      test('should return null when empty ID is provided', () async {
        // Act
        final result = await productUseCase.getProductById('');

        // Assert
        expect(result, isNull);
      });

      test('should handle special characters in ID', () async {
        // Act
        final result = await productUseCase.getProductById('!@#\$%^&*()');

        // Assert
        expect(result, isNull);
      });

      test('should propagate repository errors for getProductById', () async {
        // Arrange
        final errorRepository = MockProductRepositoryWithErrors();
        final errorUseCase = ProductUseCase(errorRepository);

        // Act & Assert
        expect(
          () => errorUseCase.getProductById('1'),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('Edge Cases and Error Handling', () {
      test('should handle very long product IDs', () async {
        // Arrange
        final longId = 'A' * 1000;

        // Act
        final result = await productUseCase.getProductById(longId);

        // Assert
        expect(result, isNull);
      });

      test('should handle null-like IDs gracefully', () async {
        // Act
        final result = await productUseCase.getProductById('null');

        // Assert
        expect(result, isNull);
      });

      test('should handle whitespace-only IDs', () async {
        // Act
        final result = await productUseCase.getProductById('   ');

        // Assert
        expect(result, isNull);
      });

      test('should handle numeric string IDs', () async {
        // Act
        final result = await productUseCase.getProductById('123');

        // Assert
        expect(result, isNull);
      });
    });

    group('Data Validation Tests', () {
      test('should return products with valid price ranges', () async {
        // Act
        final result = await productUseCase.getProducts();

        // Assert
        for (final product in result) {
          expect(product.price, isNotNull);
          expect(product.price!, greaterThan(0));
          expect(product.price!, lessThan(1000)); // Reasonable upper limit
        }
      });

      test('should return products with valid rating ranges', () async {
        // Act
        final result = await productUseCase.getProducts();

        // Assert
        for (final product in result) {
          if (product.rating != null) {
            expect(product.rating!, greaterThanOrEqualTo(0));
            expect(product.rating!, lessThanOrEqualTo(5));
          }
        }
      });

      test('should return products with non-empty titles', () async {
        // Act
        final result = await productUseCase.getProducts();

        // Assert
        for (final product in result) {
          expect(product.title, isNotNull);
          expect(product.title!.isNotEmpty, isTrue);
        }
      });
    });

    group('Performance Tests', () {
      test('should handle multiple concurrent requests', () async {
        // Act
        final futures = List.generate(10, (index) => productUseCase.getProducts());
        final results = await Future.wait(futures);

        // Assert
        expect(results.length, equals(10));
        for (final result in results) {
          expect(result.length, equals(3));
        }
      });

      test('should handle multiple concurrent getProductById requests', () async {
        // Act
        final futures = List.generate(5, (index) => productUseCase.getProductById('1'));
        final results = await Future.wait(futures);

        // Assert
        expect(results.length, equals(5));
        for (final result in results) {
          expect(result!.id, equals('1'));
        }
      });
    });
  });
}
