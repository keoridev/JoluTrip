class VideoHelpers {
  static String getDifficultyLabel(String difficult) {
    switch (difficult.toLowerCase()) {
      case 'easy':
        return 'Легко';
      case 'нормально':
        return 'Нормально';
      case 'medium':
        return 'Средне';
      case 'hard':
        return 'Сложно';
      default:
        return difficult;
    }
  }
}
