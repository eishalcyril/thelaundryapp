
// Function to check whether icon HexaCode is valid, used in PRAYERS home page

int isIcon(String value) {
  int data;
  try {
    data = int.parse(
      value,
    );
  } catch (e) {
    data = int.parse(
      '0xe815',
    );
  }
  return data;
}
