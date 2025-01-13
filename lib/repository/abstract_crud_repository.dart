abstract mixin class AbstractCrudRepository<T, ID> {
  Future<void> add(T object);
  Future<void> delete(ID object);
  Future<List<T>> get();
  Future<void> update(ID object);
}
