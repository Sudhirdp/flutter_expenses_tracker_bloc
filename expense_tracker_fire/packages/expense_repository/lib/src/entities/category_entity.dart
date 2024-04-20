class CategoryEntity{
  final String categoryId;
  final String name;
  final int totalExpenses;
  final int icon;
  final int color;

  const CategoryEntity({
    required this.categoryId,
    required this.name,
    required this.totalExpenses,
    required this.icon,
    required this.color,
  });

  Map<String,Object> toDocument(){
    return {
      'categoryId':categoryId,
      'name':name,
      'totalExpenses':totalExpenses,
      'icon':icon,
      'color':color,
    };
  }

  static CategoryEntity fromDocument(Map<String,dynamic> doc){
    return CategoryEntity(categoryId: doc['categoryId'], name: doc['name'], totalExpenses: doc['totalExpenses'], icon: doc['icon'], color: doc['color']);
  }
}