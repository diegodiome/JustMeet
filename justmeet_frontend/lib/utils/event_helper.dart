
double averageRating(List<double> rates) {
  if (rates != null && rates.isNotEmpty) {
    double sum = 0;
    for (double num in rates) {
      sum += num;
    }
    return sum / rates.length;
  }
  return 0.0;
}