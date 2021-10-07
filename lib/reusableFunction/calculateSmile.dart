String calculateSmile({double? smilingProbability}) {
  if (smilingProbability! > 0.3 && smilingProbability <= 0.54) {
    return "Neutral";
  } else if (smilingProbability <= 0.3) {
    return "sad";
  } else {
    return "Smiling";
  }
}
