enum Time { AM, PM }

String TimeToString(Time time) {
  switch (time) {
    case Time.AM:
      return "AM";
    case Time.PM:
      return "PM";
  }
}

List<Time> getListOfTime() {
  return [Time.AM, Time.PM];
}
