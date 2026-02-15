enum IngredientCategory {
  vegetables,
  meat,
  dairy,
  fruits,
  fishSeafood,
  grainsCereals,
  legumes,
  nutsSeed,
  oilsFats,
  spicesHerbs,
  eggs,
  beverages,
  saucesCondiments,
  sweetsSugars,
  processed;

  String get displayName => switch (this) {
        vegetables => 'Verduras',
        meat => 'Carnes',
        dairy => 'Lacteos',
        fruits => 'Frutas',
        fishSeafood => 'Pescados',
        grainsCereals => 'Granos',
        legumes => 'Legumbres',
        nutsSeed => 'Frutos secos',
        oilsFats => 'Aceites',
        spicesHerbs => 'Especias',
        eggs => 'Huevos',
        beverages => 'Bebidas',
        saucesCondiments => 'Salsas',
        sweetsSugars => 'Dulces',
        processed => 'Procesados',
      };

  /// Valor que corresponde a la columna `category` en la tabla `ingredient`.
  String get value => switch (this) {
        vegetables => 'vegetables',
        meat => 'meat',
        dairy => 'dairy',
        fruits => 'fruits',
        fishSeafood => 'fish_seafood',
        grainsCereals => 'grains_cereals',
        legumes => 'legumes',
        nutsSeed => 'nuts_seeds',
        oilsFats => 'oils_fats',
        spicesHerbs => 'spices_herbs',
        eggs => 'eggs',
        beverages => 'beverages',
        saucesCondiments => 'sauces_condiments',
        sweetsSugars => 'sweets_sugars',
        processed => 'processed',
      };
}
