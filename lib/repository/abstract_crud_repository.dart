abstract mixin class AbstractCrudRepository<T, ID> {
  Future<void> add(T object);
  Future<void> delete(ID object);
  Future<List<T>> get({Object data});
  Future<void> update(ID object);
}
