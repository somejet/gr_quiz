import '../models/greek_verb.dart';
import '../models/person.dart';
import '../models/verb_category.dart';

class VerbDataB1 {
  static List<GreekVerb> getVerbs() {
    return [
      // Категория B1 - -άω
      GreekVerb(
        infinitive: 'μιλάω',
        russianTranslation: 'говорить',
        category: VerbCategory.b1,
        conjugations: [
          VerbConjugation(greekForm: 'μιλάω', russianTranslation: 'говорю', person: Person.firstSingular),
          VerbConjugation(greekForm: 'μιλάς', russianTranslation: 'говоришь', person: Person.secondSingular),
          VerbConjugation(greekForm: 'μιλάει', russianTranslation: 'говорит', person: Person.thirdSingular),
          VerbConjugation(greekForm: 'μιλάμε', russianTranslation: 'говорим', person: Person.firstPlural),
          VerbConjugation(greekForm: 'μιλάτε', russianTranslation: 'говорите', person: Person.secondPlural),
          VerbConjugation(greekForm: 'μιλάνε', russianTranslation: 'говорят', person: Person.thirdPlural),
        ],
      ),
      GreekVerb(
        infinitive: 'ρωτάω',
        russianTranslation: 'спрашивать',
        category: VerbCategory.b1,
        conjugations: [
          VerbConjugation(greekForm: 'ρωτάω', russianTranslation: 'спрашиваю', person: Person.firstSingular),
          VerbConjugation(greekForm: 'ρωτάς', russianTranslation: 'спрашиваешь', person: Person.secondSingular),
          VerbConjugation(greekForm: 'ρωτάει', russianTranslation: 'спрашивает', person: Person.thirdSingular),
          VerbConjugation(greekForm: 'ρωτάμε', russianTranslation: 'спрашиваем', person: Person.firstPlural),
          VerbConjugation(greekForm: 'ρωτάτε', russianTranslation: 'спрашиваете', person: Person.secondPlural),
          VerbConjugation(greekForm: 'ρωτάνε', russianTranslation: 'спрашивают', person: Person.thirdPlural),
        ],
      ),
      GreekVerb(
        infinitive: 'απαντάω',
        russianTranslation: 'отвечать',
        category: VerbCategory.b1,
        conjugations: [
          VerbConjugation(greekForm: 'απαντάω', russianTranslation: 'отвечаю', person: Person.firstSingular),
          VerbConjugation(greekForm: 'απαντάς', russianTranslation: 'отвечаешь', person: Person.secondSingular),
          VerbConjugation(greekForm: 'απαντάει', russianTranslation: 'отвечает', person: Person.thirdSingular),
          VerbConjugation(greekForm: 'απαντάμε', russianTranslation: 'отвечаем', person: Person.firstPlural),
          VerbConjugation(greekForm: 'απαντάτε', russianTranslation: 'отвечаете', person: Person.secondPlural),
          VerbConjugation(greekForm: 'απαντάνε', russianTranslation: 'отвечают', person: Person.thirdPlural),
        ],
      ),
      GreekVerb(
        infinitive: 'πεινάω',
        russianTranslation: 'хотеть есть',
        category: VerbCategory.b1,
        conjugations: [
          VerbConjugation(greekForm: 'πεινάω', russianTranslation: 'хочу есть', person: Person.firstSingular),
          VerbConjugation(greekForm: 'πεινάς', russianTranslation: 'хочешь есть', person: Person.secondSingular),
          VerbConjugation(greekForm: 'πεινάει', russianTranslation: 'хочет есть', person: Person.thirdSingular),
          VerbConjugation(greekForm: 'πεινάμε', russianTranslation: 'хотим есть', person: Person.firstPlural),
          VerbConjugation(greekForm: 'πεινάτε', russianTranslation: 'хотите есть', person: Person.secondPlural),
          VerbConjugation(greekForm: 'πεινάνε', russianTranslation: 'хотят есть', person: Person.thirdPlural),
        ],
      ),
      GreekVerb(
        infinitive: 'διψάω',
        russianTranslation: 'хотеть пить',
        category: VerbCategory.b1,
        conjugations: [
          VerbConjugation(greekForm: 'διψάω', russianTranslation: 'хочу пить', person: Person.firstSingular),
          VerbConjugation(greekForm: 'διψάς', russianTranslation: 'хочешь пить', person: Person.secondSingular),
          VerbConjugation(greekForm: 'διψάει', russianTranslation: 'хочет пить', person: Person.thirdSingular),
          VerbConjugation(greekForm: 'διψάμε', russianTranslation: 'хотим пить', person: Person.firstPlural),
          VerbConjugation(greekForm: 'διψάτε', russianTranslation: 'хотите пить', person: Person.secondPlural),
          VerbConjugation(greekForm: 'διψάνε', russianTranslation: 'хотят пить', person: Person.thirdPlural),
        ],
      ),
      GreekVerb(
        infinitive: 'ζητάω',
        russianTranslation: 'просить',
        category: VerbCategory.b1,
        conjugations: [
          VerbConjugation(greekForm: 'ζητάω', russianTranslation: 'прошу', person: Person.firstSingular),
          VerbConjugation(greekForm: 'ζητάς', russianTranslation: 'просишь', person: Person.secondSingular),
          VerbConjugation(greekForm: 'ζητάει', russianTranslation: 'просит', person: Person.thirdSingular),
          VerbConjugation(greekForm: 'ζητάμε', russianTranslation: 'просим', person: Person.firstPlural),
          VerbConjugation(greekForm: 'ζητάτε', russianTranslation: 'просите', person: Person.secondPlural),
          VerbConjugation(greekForm: 'ζητάνε', russianTranslation: 'просят', person: Person.thirdPlural),
        ],
      ),
      GreekVerb(
        infinitive: 'περνάω',
        russianTranslation: 'проходить',
        category: VerbCategory.b1,
        conjugations: [
          VerbConjugation(greekForm: 'περνάω', russianTranslation: 'прохожу', person: Person.firstSingular),
          VerbConjugation(greekForm: 'περνάς', russianTranslation: 'проходишь', person: Person.secondSingular),
          VerbConjugation(greekForm: 'περνάει', russianTranslation: 'проходит', person: Person.thirdSingular),
          VerbConjugation(greekForm: 'περνάμε', russianTranslation: 'проходим', person: Person.firstPlural),
          VerbConjugation(greekForm: 'περνάτε', russianTranslation: 'проходите', person: Person.secondPlural),
          VerbConjugation(greekForm: 'περνάνε', russianTranslation: 'проходят', person: Person.thirdPlural),
        ],
      ),
      GreekVerb(
        infinitive: 'σταματάω',
        russianTranslation: 'переставать',
        category: VerbCategory.b1,
        conjugations: [
          VerbConjugation(greekForm: 'σταματάω', russianTranslation: 'перестаю', person: Person.firstSingular),
          VerbConjugation(greekForm: 'σταματάς', russianTranslation: 'перестаешь', person: Person.secondSingular),
          VerbConjugation(greekForm: 'σταματάει', russianTranslation: 'перестает', person: Person.thirdSingular),
          VerbConjugation(greekForm: 'σταματάμε', russianTranslation: 'перестаем', person: Person.firstPlural),
          VerbConjugation(greekForm: 'σταματάτε', russianTranslation: 'перестаете', person: Person.secondPlural),
          VerbConjugation(greekForm: 'σταματάνε', russianTranslation: 'перестают', person: Person.thirdPlural),
        ],
      ),
      GreekVerb(
        infinitive: 'ξεκινάω',
        russianTranslation: 'выезжать',
        category: VerbCategory.b1,
        conjugations: [
          VerbConjugation(greekForm: 'ξεκινάω', russianTranslation: 'выезжаю', person: Person.firstSingular),
          VerbConjugation(greekForm: 'ξεκινάς', russianTranslation: 'выезжаешь', person: Person.secondSingular),
          VerbConjugation(greekForm: 'ξεκινάει', russianTranslation: 'выезжает', person: Person.thirdSingular),
          VerbConjugation(greekForm: 'ξεκινάμε', russianTranslation: 'выезжаем', person: Person.firstPlural),
          VerbConjugation(greekForm: 'ξεκινάτε', russianTranslation: 'выезжаете', person: Person.secondPlural),
          VerbConjugation(greekForm: 'ξεκινάνε', russianTranslation: 'выезжают', person: Person.thirdPlural),
        ],
      ),
      GreekVerb(
        infinitive: 'περπατάω',
        russianTranslation: 'ходить',
        category: VerbCategory.b1,
        conjugations: [
          VerbConjugation(greekForm: 'περπατάω', russianTranslation: 'хожу', person: Person.firstSingular),
          VerbConjugation(greekForm: 'περπατάς', russianTranslation: 'ходишь', person: Person.secondSingular),
          VerbConjugation(greekForm: 'περπατάει', russianTranslation: 'ходит', person: Person.thirdSingular),
          VerbConjugation(greekForm: 'περπατάμε', russianTranslation: 'ходим', person: Person.firstPlural),
          VerbConjugation(greekForm: 'περπατάτε', russianTranslation: 'ходите', person: Person.secondPlural),
          VerbConjugation(greekForm: 'περπατάνε', russianTranslation: 'ходят', person: Person.thirdPlural),
        ],
      ),
      GreekVerb(
        infinitive: 'ξυπνάω',
        russianTranslation: 'просыпаться',
        category: VerbCategory.b1,
        conjugations: [
          VerbConjugation(greekForm: 'ξυπνάω', russianTranslation: 'просыпаюсь', person: Person.firstSingular),
          VerbConjugation(greekForm: 'ξυπνάς', russianTranslation: 'просыпаешься', person: Person.secondSingular),
          VerbConjugation(greekForm: 'ξυπνάει', russianTranslation: 'просыпается', person: Person.thirdSingular),
          VerbConjugation(greekForm: 'ξυπνάμε', russianTranslation: 'просыпаемся', person: Person.firstPlural),
          VerbConjugation(greekForm: 'ξυπνάτε', russianTranslation: 'просыпаетесь', person: Person.secondPlural),
          VerbConjugation(greekForm: 'ξυπνάνε', russianTranslation: 'просыпаются', person: Person.thirdPlural),
        ],
      ),
      GreekVerb(
        infinitive: 'ξεχνάω',
        russianTranslation: 'забывать',
        category: VerbCategory.b1,
        conjugations: [
          VerbConjugation(greekForm: 'ξεχνάω', russianTranslation: 'забываю', person: Person.firstSingular),
          VerbConjugation(greekForm: 'ξεχνάς', russianTranslation: 'забываешь', person: Person.secondSingular),
          VerbConjugation(greekForm: 'ξεχνάει', russianTranslation: 'забывает', person: Person.thirdSingular),
          VerbConjugation(greekForm: 'ξεχνάμε', russianTranslation: 'забываем', person: Person.firstPlural),
          VerbConjugation(greekForm: 'ξεχνάτε', russianTranslation: 'забываете', person: Person.secondPlural),
          VerbConjugation(greekForm: 'ξεχνάνε', russianTranslation: 'забывают', person: Person.thirdPlural),
        ],
      ),
      GreekVerb(
        infinitive: 'κολυμπάω',
        russianTranslation: 'плавать',
        category: VerbCategory.b1,
        conjugations: [
          VerbConjugation(greekForm: 'κολυμπάω', russianTranslation: 'плаваю', person: Person.firstSingular),
          VerbConjugation(greekForm: 'κολυμπάς', russianTranslation: 'плаваешь', person: Person.secondSingular),
          VerbConjugation(greekForm: 'κολυμπάει', russianTranslation: 'плавает', person: Person.thirdSingular),
          VerbConjugation(greekForm: 'κολυμπάμε', russianTranslation: 'плаваем', person: Person.firstPlural),
          VerbConjugation(greekForm: 'κολυμπάτε', russianTranslation: 'плаваете', person: Person.secondPlural),
          VerbConjugation(greekForm: 'κολυμπάνε', russianTranslation: 'плавают', person: Person.thirdPlural),
        ],
      ),
      GreekVerb(
        infinitive: 'γελάω',
        russianTranslation: 'смеяться',
        category: VerbCategory.b1,
        conjugations: [
          VerbConjugation(greekForm: 'γελάω', russianTranslation: 'смеюсь', person: Person.firstSingular),
          VerbConjugation(greekForm: 'γελάς', russianTranslation: 'смеешься', person: Person.secondSingular),
          VerbConjugation(greekForm: 'γελάει', russianTranslation: 'смеется', person: Person.thirdSingular),
          VerbConjugation(greekForm: 'γελάμε', russianTranslation: 'смеемся', person: Person.firstPlural),
          VerbConjugation(greekForm: 'γελάτε', russianTranslation: 'смеетесь', person: Person.secondPlural),
          VerbConjugation(greekForm: 'γελάνε', russianTranslation: 'смеются', person: Person.thirdPlural),
        ],
      ),
    ];
  }
}
