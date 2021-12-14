String calculateSmile({double? smilingProbability}) {
  if (smilingProbability! > 0.86) {
    return 'Big smile with teeth';
  } else if (smilingProbability > 0.8) {
    return 'Big Smile';
  } else if (smilingProbability > 0.3) {
    return 'Smile';
  }
  if (smilingProbability > 0.3 && smilingProbability <= 0.54) {
    return "Neutral";
  } else if (smilingProbability <= 0.3) {
    return "sad";
  } else {
    return 'Sad';
  }
}

// String determineBehavior ({}){
  
// }
