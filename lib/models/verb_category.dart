enum VerbCategory {
  daily('Daily', 'Ежедневный квиз'),
  a('A', 'Безударная -ω'),
  b1('B1', '-άω'),
  b2('B2', '-ώ'),
  ab('AB', 'Смешанная'),
  gamma1('Γ1', '-ομαι'),
  gamma2('Γ2', '-αμαι');

  const VerbCategory(this.code, this.description);
  
  final String code;
  final String description;
}
