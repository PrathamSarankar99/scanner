enum BookingStatus {
  booked,
  parked,
  over,
}

encodeBookingStatus(BookingStatus status) {
  switch (status) {
    case BookingStatus.booked:
      return 0;
    case BookingStatus.parked:
      return 1;
    case BookingStatus.over:
      return 2;
  }
}

decodeBookingStatus(int status) {
  if (status == 0) return BookingStatus.booked;
  if (status == 1) return BookingStatus.parked;
  return BookingStatus.over;
}
