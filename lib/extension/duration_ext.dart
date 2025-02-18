extension DurationExt on Duration {

  Future get delay => Future.delayed(this);

}