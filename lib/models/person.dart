enum Person {
  firstSingular('έγω', 'я'),
  secondSingular('εσύ', 'ты'),
  thirdSingular('αυτός/αυτή/αυτό', 'он/она/оно'),
  firstPlural('εμείς', 'мы'),
  secondPlural('εσείς', 'вы'),
  thirdPlural('αυτοί/αυτές/αυτά', 'они');

  const Person(this.greekPronoun, this.russianPronoun);
  
  final String greekPronoun;
  final String russianPronoun;
}
