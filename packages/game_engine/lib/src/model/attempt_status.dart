enum AttemptStatus {
  inProgress,
  won,
  outOfMoves;

  static AttemptStatus fromName(String name) =>
      AttemptStatus.values.firstWhere((e) => e.name == name);
}
