class Band {
  const Band({this.id, this.nombre, this.votes});

  final String id;
  final String nombre;
  final int votes;

  // Instanciar una banda desde un Map provisto por el backend
  factory Band.fromMap(Map<String, dynamic> obj) => Band(
        id: obj['id'],
        nombre: obj['nombre'],
        votes: obj['votes'],
      );
}
