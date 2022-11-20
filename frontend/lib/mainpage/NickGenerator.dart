import 'dart:math';

final _prefix = [
  "사이코패스",
  "귀여운",
  "민머리",
  "대머리",
  "빡빡이",
  "원형탈모",
  "대마법사",
  "싸움꾼",
  "월급루팡",
  "심신미약",
  "알코올중독",
  "예비군",
  "아이돌",
  "울보",
  "광신도",
  "단소살인마",
  "지옥에서온",
  "댄싱머신",
  "자전거도둑",
  "멀쩡한",
  "평범한",
  "탈주한",
  "싸피",
  "개발자",
  "코딩노예",
  "애송이",
  "디자이너",
  "아마추어",
  "댄서",
  "아티스트",
  "방랑자",
  "골목대장",
  "레어",
  "유니크",
  "멸종위기",
  "욕심쟁이",
  "빌런지망생",
  "초식",
  "육식",
  "평화주의자"
];

final List<Map> _animals = [
  {"name": "사자", "image": "lion"},
  {"name": "기린", "image": "giraffe"},
  {"name": "코알라", "image": "koala"},
  {"name": "코끼리", "image": "elephant"},
  {"name": "곰", "image": "bear"},
  {"name": "호랑이", "image": "tiger"},
  {"name": "라쿤", "image": "raccoon"},
  {"name": "알파카", "image": "alpaca"},
  {"name": "독수리", "image": "eagle"},
  {"name": "고릴라", "image": "gorilla"},
  {"name": "펭귄", "image": "penguin"},
  {"name": "팬더", "image": "panda"},
  {"name": "영양", "image": "antelope"},
  {"name": "다람쥐", "image": "squirrel"},
  {"name": "원숭이", "image": "monkey"},
  {"name": "타조", "image": "ostrich"},
  {"name": "얼룩말", "image": "zebra"},
  {"name": "하마", "image": "hippo"},
  {"name": "캥거루", "image": "kangaroo"},
  {"name": "앵무새", "image": "macaw"}
];

landumeNick() {
  Random random = Random();

  int p = random.nextInt(_prefix.length);
  int k = random.nextInt(_animals.length);

  String randomNick = "${_prefix[p]} ${_animals[k]['name']}";

  String imagePath = _animals[k]['image'] + ".png";

  return randomNick;
}
