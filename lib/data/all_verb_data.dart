import '../models/greek_verb.dart';
import '../models/person.dart';
import '../models/verb_category.dart';
import 'verb_data.dart';
import 'verb_data_b1.dart';

class AllVerbData {
  static List<GreekVerb> getAllVerbs() {
    List<GreekVerb> allVerbs = [];
    allVerbs.addAll(VerbData.getAllVerbs());
    allVerbs.addAll(VerbDataB1.getVerbs());
    
    // Категория B2 - -ώ
    allVerbs.addAll([
      GreekVerb(
        infinitive: 'αργώ',
        russianTranslation: 'опаздывать',
        category: VerbCategory.b2,
        conjugations: [
          VerbConjugation(greekForm: 'αργώ', russianTranslation: 'опаздываю', person: Person.firstSingular),
          VerbConjugation(greekForm: 'αργείς', russianTranslation: 'опаздываешь', person: Person.secondSingular),
          VerbConjugation(greekForm: 'αργεί', russianTranslation: 'опаздывает', person: Person.thirdSingular),
          VerbConjugation(greekForm: 'αργούμε', russianTranslation: 'опаздываем', person: Person.firstPlural),
          VerbConjugation(greekForm: 'αργείτε', russianTranslation: 'опаздываете', person: Person.secondPlural),
          VerbConjugation(greekForm: 'αργούν', russianTranslation: 'опаздывают', person: Person.thirdPlural),
        ],
      ),
      GreekVerb(
        infinitive: 'οδηγώ',
        russianTranslation: 'водить',
        category: VerbCategory.b2,
        conjugations: [
          VerbConjugation(greekForm: 'οδηγώ', russianTranslation: 'вожу', person: Person.firstSingular),
          VerbConjugation(greekForm: 'οδηγείς', russianTranslation: 'водишь', person: Person.secondSingular),
          VerbConjugation(greekForm: 'οδηγεί', russianTranslation: 'водит', person: Person.thirdSingular),
          VerbConjugation(greekForm: 'οδηγούμε', russianTranslation: 'водим', person: Person.firstPlural),
          VerbConjugation(greekForm: 'οδηγείτε', russianTranslation: 'водите', person: Person.secondPlural),
          VerbConjugation(greekForm: 'οδηγούν', russianTranslation: 'водят', person: Person.thirdPlural),
        ],
      ),
      GreekVerb(
        infinitive: 'συγχωρώ',
        russianTranslation: 'прощать',
        category: VerbCategory.b2,
        conjugations: [
          VerbConjugation(greekForm: 'συγχωρώ', russianTranslation: 'прощаю', person: Person.firstSingular),
          VerbConjugation(greekForm: 'συγχωρείς', russianTranslation: 'прощаешь', person: Person.secondSingular),
          VerbConjugation(greekForm: 'συγχωρεί', russianTranslation: 'прощает', person: Person.thirdSingular),
          VerbConjugation(greekForm: 'συγχωρούμε', russianTranslation: 'прощаем', person: Person.firstPlural),
          VerbConjugation(greekForm: 'συγχωρείτε', russianTranslation: 'прощаете', person: Person.secondPlural),
          VerbConjugation(greekForm: 'συγχωρούν', russianTranslation: 'прощают', person: Person.thirdPlural),
        ],
      ),
      GreekVerb(
        infinitive: 'μπορώ',
        russianTranslation: 'мочь',
        category: VerbCategory.b2,
        conjugations: [
          VerbConjugation(greekForm: 'μπορώ', russianTranslation: 'могу', person: Person.firstSingular),
          VerbConjugation(greekForm: 'μπορείς', russianTranslation: 'можешь', person: Person.secondSingular),
          VerbConjugation(greekForm: 'μπορεί', russianTranslation: 'может', person: Person.thirdSingular),
          VerbConjugation(greekForm: 'μπορούμε', russianTranslation: 'можем', person: Person.firstPlural),
          VerbConjugation(greekForm: 'μπορείτε', russianTranslation: 'можете', person: Person.secondPlural),
          VerbConjugation(greekForm: 'μπορούν', russianTranslation: 'могут', person: Person.thirdPlural),
        ],
      ),
      GreekVerb(
        infinitive: 'τηλεφωνώ',
        russianTranslation: 'звонить',
        category: VerbCategory.b2,
        conjugations: [
          VerbConjugation(greekForm: 'τηλεφωνώ', russianTranslation: 'звоню', person: Person.firstSingular),
          VerbConjugation(greekForm: 'τηλεφωνείς', russianTranslation: 'звонишь', person: Person.secondSingular),
          VerbConjugation(greekForm: 'τηλεφωνεί', russianTranslation: 'звонит', person: Person.thirdSingular),
          VerbConjugation(greekForm: 'τηλεφωνούμε', russianTranslation: 'звоним', person: Person.firstPlural),
          VerbConjugation(greekForm: 'τηλεφωνείτε', russianTranslation: 'звоните', person: Person.secondPlural),
          VerbConjugation(greekForm: 'τηλεφωνούν', russianTranslation: 'звонят', person: Person.thirdPlural),
        ],
      ),
      GreekVerb(
        infinitive: 'ζω',
        russianTranslation: 'жить',
        category: VerbCategory.b2,
        conjugations: [
          VerbConjugation(greekForm: 'ζω', russianTranslation: 'живу', person: Person.firstSingular),
          VerbConjugation(greekForm: 'ζεις', russianTranslation: 'живешь', person: Person.secondSingular),
          VerbConjugation(greekForm: 'ζει', russianTranslation: 'живет', person: Person.thirdSingular),
          VerbConjugation(greekForm: 'ζούμε', russianTranslation: 'живем', person: Person.firstPlural),
          VerbConjugation(greekForm: 'ζείτε', russianTranslation: 'живете', person: Person.secondPlural),
          VerbConjugation(greekForm: 'ζούν', russianTranslation: 'живут', person: Person.thirdPlural),
        ],
      ),
      GreekVerb(
        infinitive: 'καλώ',
        russianTranslation: 'звать',
        category: VerbCategory.b2,
        conjugations: [
          VerbConjugation(greekForm: 'καλώ', russianTranslation: 'зову', person: Person.firstSingular),
          VerbConjugation(greekForm: 'καλείς', russianTranslation: 'зовешь', person: Person.secondSingular),
          VerbConjugation(greekForm: 'καλεί', russianTranslation: 'зовет', person: Person.thirdSingular),
          VerbConjugation(greekForm: 'καλούμε', russianTranslation: 'зовем', person: Person.firstPlural),
          VerbConjugation(greekForm: 'καλείτε', russianTranslation: 'зовете', person: Person.secondPlural),
          VerbConjugation(greekForm: 'καλούν', russianTranslation: 'зовут', person: Person.thirdPlural),
        ],
      ),
      GreekVerb(
        infinitive: 'χρησιμοποιώ',
        russianTranslation: 'использовать',
        category: VerbCategory.b2,
        conjugations: [
          VerbConjugation(greekForm: 'χρησιμοποιώ', russianTranslation: 'использую', person: Person.firstSingular),
          VerbConjugation(greekForm: 'χρησιμοποιείς', russianTranslation: 'используешь', person: Person.secondSingular),
          VerbConjugation(greekForm: 'χρησιμοποιεί', russianTranslation: 'использует', person: Person.thirdSingular),
          VerbConjugation(greekForm: 'χρησιμοποιούμε', russianTranslation: 'используем', person: Person.firstPlural),
          VerbConjugation(greekForm: 'χρησιμοποιείτε', russianTranslation: 'используете', person: Person.secondPlural),
          VerbConjugation(greekForm: 'χρησιμοποιούν', russianTranslation: 'используют', person: Person.thirdPlural),
        ],
      ),
      GreekVerb(
        infinitive: 'εξηγώ',
        russianTranslation: 'объяснять',
        category: VerbCategory.b2,
        conjugations: [
          VerbConjugation(greekForm: 'εξηγώ', russianTranslation: 'объясняю', person: Person.firstSingular),
          VerbConjugation(greekForm: 'εξηγείς', russianTranslation: 'объясняешь', person: Person.secondSingular),
          VerbConjugation(greekForm: 'εξηγεί', russianTranslation: 'объясняет', person: Person.thirdSingular),
          VerbConjugation(greekForm: 'εξηγούμε', russianTranslation: 'объясняем', person: Person.firstPlural),
          VerbConjugation(greekForm: 'εξηγείτε', russianTranslation: 'объясняете', person: Person.secondPlural),
          VerbConjugation(greekForm: 'εξηγούν', russianTranslation: 'объясняют', person: Person.thirdPlural),
        ],
      ),
    ]);

    // Категория AB - Смешанная
    allVerbs.addAll([
      GreekVerb(
        infinitive: 'ακούω',
        russianTranslation: 'слушать',
        category: VerbCategory.ab,
        conjugations: [
          VerbConjugation(greekForm: 'ακούω', russianTranslation: 'слушаю', person: Person.firstSingular),
          VerbConjugation(greekForm: 'ακούς', russianTranslation: 'слушаешь', person: Person.secondSingular),
          VerbConjugation(greekForm: 'ακούει', russianTranslation: 'слушает', person: Person.thirdSingular),
          VerbConjugation(greekForm: 'ακούμε', russianTranslation: 'слушаем', person: Person.firstPlural),
          VerbConjugation(greekForm: 'ακούτε', russianTranslation: 'слушаете', person: Person.secondPlural),
          VerbConjugation(greekForm: 'ακούνε', russianTranslation: 'слушают', person: Person.thirdPlural),
        ],
      ),
      GreekVerb(
        infinitive: 'λέω',
        russianTranslation: 'сказать',
        category: VerbCategory.ab,
        conjugations: [
          VerbConjugation(greekForm: 'λέω', russianTranslation: 'говорю', person: Person.firstSingular),
          VerbConjugation(greekForm: 'λές', russianTranslation: 'говоришь', person: Person.secondSingular),
          VerbConjugation(greekForm: 'λέει', russianTranslation: 'говорит', person: Person.thirdSingular),
          VerbConjugation(greekForm: 'λέμε', russianTranslation: 'говорим', person: Person.firstPlural),
          VerbConjugation(greekForm: 'λέτε', russianTranslation: 'говорите', person: Person.secondPlural),
          VerbConjugation(greekForm: 'λένε', russianTranslation: 'говорят', person: Person.thirdPlural),
        ],
      ),
      GreekVerb(
        infinitive: 'καίω',
        russianTranslation: 'гореть',
        category: VerbCategory.ab,
        conjugations: [
          VerbConjugation(greekForm: 'καίω', russianTranslation: 'горю', person: Person.firstSingular),
          VerbConjugation(greekForm: 'καίς', russianTranslation: 'горишь', person: Person.secondSingular),
          VerbConjugation(greekForm: 'καίει', russianTranslation: 'горит', person: Person.thirdSingular),
          VerbConjugation(greekForm: 'καίμε', russianTranslation: 'горим', person: Person.firstPlural),
          VerbConjugation(greekForm: 'καίτε', russianTranslation: 'горите', person: Person.secondPlural),
          VerbConjugation(greekForm: 'καίνε', russianTranslation: 'горят', person: Person.thirdPlural),
        ],
      ),
      GreekVerb(
        infinitive: 'κλαίω',
        russianTranslation: 'плакать',
        category: VerbCategory.ab,
        conjugations: [
          VerbConjugation(greekForm: 'κλαίω', russianTranslation: 'плачу', person: Person.firstSingular),
          VerbConjugation(greekForm: 'κλαίς', russianTranslation: 'плачешь', person: Person.secondSingular),
          VerbConjugation(greekForm: 'κλαίει', russianTranslation: 'плачет', person: Person.thirdSingular),
          VerbConjugation(greekForm: 'κλαίμε', russianTranslation: 'плачем', person: Person.firstPlural),
          VerbConjugation(greekForm: 'κλαίτε', russianTranslation: 'плачете', person: Person.secondPlural),
          VerbConjugation(greekForm: 'κλαίνε', russianTranslation: 'плачут', person: Person.thirdPlural),
        ],
      ),
      GreekVerb(
        infinitive: 'φταίω',
        russianTranslation: 'провиниться',
        category: VerbCategory.ab,
        conjugations: [
          VerbConjugation(greekForm: 'φταίω', russianTranslation: 'провинился', person: Person.firstSingular),
          VerbConjugation(greekForm: 'φταίς', russianTranslation: 'провинился', person: Person.secondSingular),
          VerbConjugation(greekForm: 'φταίει', russianTranslation: 'провинился', person: Person.thirdSingular),
          VerbConjugation(greekForm: 'φταίμε', russianTranslation: 'провинились', person: Person.firstPlural),
          VerbConjugation(greekForm: 'φταίτε', russianTranslation: 'провинились', person: Person.secondPlural),
          VerbConjugation(greekForm: 'φταίνε', russianTranslation: 'провинились', person: Person.thirdPlural),
        ],
      ),
      GreekVerb(
        infinitive: 'τρώω',
        russianTranslation: 'есть',
        category: VerbCategory.ab,
        conjugations: [
          VerbConjugation(greekForm: 'τρώω', russianTranslation: 'ем', person: Person.firstSingular),
          VerbConjugation(greekForm: 'τρως', russianTranslation: 'ешь', person: Person.secondSingular),
          VerbConjugation(greekForm: 'τρώει', russianTranslation: 'ест', person: Person.thirdSingular),
          VerbConjugation(greekForm: 'τρώμε', russianTranslation: 'едим', person: Person.firstPlural),
          VerbConjugation(greekForm: 'τρώτε', russianTranslation: 'едите', person: Person.secondPlural),
          VerbConjugation(greekForm: 'τρώνε', russianTranslation: 'едят', person: Person.thirdPlural),
        ],
      ),
      GreekVerb(
        infinitive: 'πάω',
        russianTranslation: 'идти',
        category: VerbCategory.ab,
        conjugations: [
          VerbConjugation(greekForm: 'πάω', russianTranslation: 'иду', person: Person.firstSingular),
          VerbConjugation(greekForm: 'πας', russianTranslation: 'идешь', person: Person.secondSingular),
          VerbConjugation(greekForm: 'πάει', russianTranslation: 'идет', person: Person.thirdSingular),
          VerbConjugation(greekForm: 'πάμε', russianTranslation: 'идем', person: Person.firstPlural),
          VerbConjugation(greekForm: 'πάτε', russianTranslation: 'идете', person: Person.secondPlural),
          VerbConjugation(greekForm: 'πάνε', russianTranslation: 'идут', person: Person.thirdPlural),
        ],
      ),
    ]);

    // Категория Γ1 - -ομαι
    allVerbs.addAll([
      GreekVerb(
        infinitive: 'βρίσκομαι',
        russianTranslation: 'находиться',
        category: VerbCategory.gamma1,
        conjugations: [
          VerbConjugation(greekForm: 'βρίσκομαι', russianTranslation: 'нахожусь', person: Person.firstSingular),
          VerbConjugation(greekForm: 'βρίσκεσαι', russianTranslation: 'находишься', person: Person.secondSingular),
          VerbConjugation(greekForm: 'βρίσκεται', russianTranslation: 'находится', person: Person.thirdSingular),
          VerbConjugation(greekForm: 'βρισκόμαστε', russianTranslation: 'находимся', person: Person.firstPlural),
          VerbConjugation(greekForm: 'βρισκόσαστε', russianTranslation: 'находитесь', person: Person.secondPlural),
          VerbConjugation(greekForm: 'βρίσκονται', russianTranslation: 'находятся', person: Person.thirdPlural),
        ],
        alternativeEndings: ['βρίσκεστε'], // Сокращенная форма для "вы"
      ),
      GreekVerb(
        infinitive: 'αισθάνομαι',
        russianTranslation: 'чувствовать',
        category: VerbCategory.gamma1,
        conjugations: [
          VerbConjugation(greekForm: 'αισθάνομαι', russianTranslation: 'чувствую', person: Person.firstSingular),
          VerbConjugation(greekForm: 'αισθάνεσαι', russianTranslation: 'чувствуешь', person: Person.secondSingular),
          VerbConjugation(greekForm: 'αισθάνεται', russianTranslation: 'чувствует', person: Person.thirdSingular),
          VerbConjugation(greekForm: 'αισθανόμαστε', russianTranslation: 'чувствуем', person: Person.firstPlural),
          VerbConjugation(greekForm: 'αισθανόσαστε', russianTranslation: 'чувствуете', person: Person.secondPlural),
          VerbConjugation(greekForm: 'αισθάνονται', russianTranslation: 'чувствуют', person: Person.thirdPlural),
        ],
        alternativeEndings: ['αισθάνεστε'], // Сокращенная форма для "вы"
      ),
      GreekVerb(
        infinitive: 'σκέφτομαι',
        russianTranslation: 'думать',
        category: VerbCategory.gamma1,
        conjugations: [
          VerbConjugation(greekForm: 'σκέφτομαι', russianTranslation: 'думаю', person: Person.firstSingular),
          VerbConjugation(greekForm: 'σκέφτεσαι', russianTranslation: 'думаешь', person: Person.secondSingular),
          VerbConjugation(greekForm: 'σκέφτεται', russianTranslation: 'думает', person: Person.thirdSingular),
          VerbConjugation(greekForm: 'σκεφτόμαστε', russianTranslation: 'думаем', person: Person.firstPlural),
          VerbConjugation(greekForm: 'σκεφτόσαστε', russianTranslation: 'думаете', person: Person.secondPlural),
          VerbConjugation(greekForm: 'σκέφτονται', russianTranslation: 'думают', person: Person.thirdPlural),
        ],
        alternativeEndings: ['σκέφτεστε'], // Сокращенная форма для "вы"
      ),
      GreekVerb(
        infinitive: 'γίνομαι',
        russianTranslation: 'становиться',
        category: VerbCategory.gamma1,
        conjugations: [
          VerbConjugation(greekForm: 'γίνομαι', russianTranslation: 'становлюсь', person: Person.firstSingular),
          VerbConjugation(greekForm: 'γίνεσαι', russianTranslation: 'становишься', person: Person.secondSingular),
          VerbConjugation(greekForm: 'γίνεται', russianTranslation: 'становится', person: Person.thirdSingular),
          VerbConjugation(greekForm: 'γινόμαστε', russianTranslation: 'становимся', person: Person.firstPlural),
          VerbConjugation(greekForm: 'γινόσαστε', russianTranslation: 'становитесь', person: Person.secondPlural),
          VerbConjugation(greekForm: 'γίνονται', russianTranslation: 'становятся', person: Person.thirdPlural),
        ],
        alternativeEndings: ['γίνεστε'], // Сокращенная форма для "вы"
      ),
      GreekVerb(
        infinitive: 'έρχομαι',
        russianTranslation: 'приходить',
        category: VerbCategory.gamma1,
        conjugations: [
          VerbConjugation(greekForm: 'έρχομαι', russianTranslation: 'прихожу', person: Person.firstSingular),
          VerbConjugation(greekForm: 'έρχεσαι', russianTranslation: 'приходишь', person: Person.secondSingular),
          VerbConjugation(greekForm: 'έρχεται', russianTranslation: 'приходит', person: Person.thirdSingular),
          VerbConjugation(greekForm: 'ερχόμαστε', russianTranslation: 'приходим', person: Person.firstPlural),
          VerbConjugation(greekForm: 'ερχόσαστε', russianTranslation: 'приходите', person: Person.secondPlural),
          VerbConjugation(greekForm: 'έρχονται', russianTranslation: 'приходят', person: Person.thirdPlural),
        ],
        alternativeEndings: ['έρχεστε'], // Альтернативное окончание для "вы"
      ),
      GreekVerb(
        infinitive: 'φαίνομαι',
        russianTranslation: 'казаться',
        category: VerbCategory.gamma1,
        conjugations: [
          VerbConjugation(greekForm: 'φαίνομαι', russianTranslation: 'кажусь', person: Person.firstSingular),
          VerbConjugation(greekForm: 'φαίνεσαι', russianTranslation: 'кажешься', person: Person.secondSingular),
          VerbConjugation(greekForm: 'φαίνεται', russianTranslation: 'кажется', person: Person.thirdSingular),
          VerbConjugation(greekForm: 'φαινόμαστε', russianTranslation: 'кажемся', person: Person.firstPlural),
          VerbConjugation(greekForm: 'φαινόσαστε', russianTranslation: 'кажетесь', person: Person.secondPlural),
          VerbConjugation(greekForm: 'φαίνονται', russianTranslation: 'кажутся', person: Person.thirdPlural),
        ],
        alternativeEndings: ['φαίνεστε'], // Сокращенная форма для "вы"
      ),
      GreekVerb(
        infinitive: 'χρειάζομαι',
        russianTranslation: 'нуждаться',
        category: VerbCategory.gamma1,
        conjugations: [
          VerbConjugation(greekForm: 'χρειάζομαι', russianTranslation: 'нуждаюсь', person: Person.firstSingular),
          VerbConjugation(greekForm: 'χρειάζεσαι', russianTranslation: 'нуждаешься', person: Person.secondSingular),
          VerbConjugation(greekForm: 'χρειάζεται', russianTranslation: 'нуждается', person: Person.thirdSingular),
          VerbConjugation(greekForm: 'χρειαζόμαστε', russianTranslation: 'нуждаемся', person: Person.firstPlural),
          VerbConjugation(greekForm: 'χρειαζόσαστε', russianTranslation: 'нуждаетесь', person: Person.secondPlural),
          VerbConjugation(greekForm: 'χρειάζονται', russianTranslation: 'нуждаются', person: Person.thirdPlural),
        ],
        alternativeEndings: ['χρειάζεστε'], // Сокращенная форма для "вы"
      ),
      GreekVerb(
        infinitive: 'κουράζομαι',
        russianTranslation: 'уставать',
        category: VerbCategory.gamma1,
        conjugations: [
          VerbConjugation(greekForm: 'κουράζομαι', russianTranslation: 'устаю', person: Person.firstSingular),
          VerbConjugation(greekForm: 'κουράζεσαι', russianTranslation: 'устаешь', person: Person.secondSingular),
          VerbConjugation(greekForm: 'κουράζεται', russianTranslation: 'устает', person: Person.thirdSingular),
          VerbConjugation(greekForm: 'κουραζόμαστε', russianTranslation: 'устаем', person: Person.firstPlural),
          VerbConjugation(greekForm: 'κουραζόσαστε', russianTranslation: 'устаете', person: Person.secondPlural),
          VerbConjugation(greekForm: 'κουράζονται', russianTranslation: 'устают', person: Person.thirdPlural),
        ],
        alternativeEndings: ['κουράζεστε'], // Сокращенная форма для "вы"
      ),
      GreekVerb(
        infinitive: 'ξεκουράζομαι',
        russianTranslation: 'отдыхать',
        category: VerbCategory.gamma1,
        conjugations: [
          VerbConjugation(greekForm: 'ξεκουράζομαι', russianTranslation: 'отдыхаю', person: Person.firstSingular),
          VerbConjugation(greekForm: 'ξεκουράζεσαι', russianTranslation: 'отдыхаешь', person: Person.secondSingular),
          VerbConjugation(greekForm: 'ξεκουράζεται', russianTranslation: 'отдыхает', person: Person.thirdSingular),
          VerbConjugation(greekForm: 'ξεκουραζόμαστε', russianTranslation: 'отдыхаем', person: Person.firstPlural),
          VerbConjugation(greekForm: 'ξεκουραζόσαστε', russianTranslation: 'отдыхаете', person: Person.secondPlural),
          VerbConjugation(greekForm: 'ξεκουράζονται', russianTranslation: 'отдыхают', person: Person.thirdPlural),
        ],
        alternativeEndings: ['ξεκουράζεστε'], // Сокращенная форма для "вы"
      ),
    ]);

    // Категория Γ2 - -αμαι
    allVerbs.addAll([
      GreekVerb(
        infinitive: 'κοιμάμαι',
        russianTranslation: 'спать',
        category: VerbCategory.gamma2,
        conjugations: [
          VerbConjugation(greekForm: 'κοιμάμαι', russianTranslation: 'сплю', person: Person.firstSingular),
          VerbConjugation(greekForm: 'κοιμάσαι', russianTranslation: 'спишь', person: Person.secondSingular),
          VerbConjugation(greekForm: 'κοιμάται', russianTranslation: 'спит', person: Person.thirdSingular),
          VerbConjugation(greekForm: 'κοιμόμαστε', russianTranslation: 'спим', person: Person.firstPlural),
          VerbConjugation(greekForm: 'κοιμόσαστε', russianTranslation: 'спите', person: Person.secondPlural),
          VerbConjugation(greekForm: 'κοιμούνται', russianTranslation: 'спят', person: Person.thirdPlural),
        ],
        alternativeEndings: ['κοιμάστε'], // Сокращенная форма для "вы"
      ),
      GreekVerb(
        infinitive: 'θυμάμαι',
        russianTranslation: 'помнить',
        category: VerbCategory.gamma2,
        conjugations: [
          VerbConjugation(greekForm: 'θυμάμαι', russianTranslation: 'помню', person: Person.firstSingular),
          VerbConjugation(greekForm: 'θυμάσαι', russianTranslation: 'помнишь', person: Person.secondSingular),
          VerbConjugation(greekForm: 'θυμάται', russianTranslation: 'помнит', person: Person.thirdSingular),
          VerbConjugation(greekForm: 'θυμόμαστε', russianTranslation: 'помним', person: Person.firstPlural),
          VerbConjugation(greekForm: 'θυμόσαστε', russianTranslation: 'помните', person: Person.secondPlural),
          VerbConjugation(greekForm: 'θυμούνται', russianTranslation: 'помнят', person: Person.thirdPlural),
        ],
        alternativeEndings: ['θυμάστε'], // Сокращенная форма для "вы"
      ),
      GreekVerb(
        infinitive: 'λυπάμαι',
        russianTranslation: 'жалеть',
        category: VerbCategory.gamma2,
        conjugations: [
          VerbConjugation(greekForm: 'λυπάμαι', russianTranslation: 'жалею', person: Person.firstSingular),
          VerbConjugation(greekForm: 'λυπάσαι', russianTranslation: 'жалеешь', person: Person.secondSingular),
          VerbConjugation(greekForm: 'λυπάται', russianTranslation: 'жалеет', person: Person.thirdSingular),
          VerbConjugation(greekForm: 'λυπόμαστε', russianTranslation: 'жалеем', person: Person.firstPlural),
          VerbConjugation(greekForm: 'λυπόσαστε', russianTranslation: 'жалеете', person: Person.secondPlural),
          VerbConjugation(greekForm: 'λυπούνται', russianTranslation: 'жалеют', person: Person.thirdPlural),
        ],
        alternativeEndings: ['λυπάστε'], // Сокращенная форма для "вы"
      ),
      GreekVerb(
        infinitive: 'φοβάμαι',
        russianTranslation: 'бояться',
        category: VerbCategory.gamma2,
        conjugations: [
          VerbConjugation(greekForm: 'φοβάμαι', russianTranslation: 'боюсь', person: Person.firstSingular),
          VerbConjugation(greekForm: 'φοβάσαι', russianTranslation: 'боишься', person: Person.secondSingular),
          VerbConjugation(greekForm: 'φοβάται', russianTranslation: 'боится', person: Person.thirdSingular),
          VerbConjugation(greekForm: 'φοβόμαστε', russianTranslation: 'боимся', person: Person.firstPlural),
          VerbConjugation(greekForm: 'φοβόσαστε', russianTranslation: 'боитесь', person: Person.secondPlural),
          VerbConjugation(greekForm: 'φοβούνται', russianTranslation: 'боятся', person: Person.thirdPlural),
        ],
        alternativeEndings: ['φοβάστε'], // Сокращенная форма для "вы"
      ),
    ]);

    return allVerbs;
  }

  static List<GreekVerb> getVerbsByCategory(VerbCategory category) {
    return getAllVerbs().where((verb) => verb.category == category).toList();
  }
}
