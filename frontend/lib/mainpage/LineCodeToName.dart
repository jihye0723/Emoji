lineCodeName(String? line) {
  String _name = "";

  switch (line) {
    case "1001":
      _name = "1호선";
      break;
    case "1002":
      _name = "2호선";
      break;
    case "1003":
      _name = "3호선";
      break;
    case "1004":
      _name = "4호선";
      break;
    case "1005":
      _name = "5호선";
      break;
    case "1006":
      _name = "6호선";
      break;
    case "1007":
      _name = "7호선";
      break;
    case "1008":
      _name = "8호선";
      break;
    case "1009":
      _name = "9호선";
      break;
    case "1075":
      _name = "분당선";
      break;
    case "1077":
      _name = "신분당선";
      break;
    case "1063":
      _name = "경의중앙선";
      break;
    case "1067":
      _name = "경춘선";
      break;
    case "1065":
      _name = "공항철도";
      break;
    default:
      break;
  }

  return _name;
  // "1001": "1호선",
  // "1002": "2호선",
  // "1003": "3호선",
  // "1004": "4호선",
  // "1005": "5호선",
  // "1006": "6호선",
  // "1007": "7호선",
  // "1008": "8호선",
  // "1009": "9호선",
  // "1075": "분당선",
  // "1077": "신분당선",
  // "1063": "경의중앙선",
  // "1067": "경춘선",
  // "1065": "공항철도"
}
