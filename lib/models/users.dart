class User {
  String userName;
  String email;
  String phoneNumber;
  String password;

  User({
    required this.userName,
    required this.email,
    required this.phoneNumber,
    required this.password,
  });
}

class Player extends User {
  int jerseyNumber;
  int age;
  String typeOfPlayer;
  double ratings;
  int matchesPlayed;
  int wonMatches;
  List<Match> matches;

  Player({
    required super.userName,
    required super.email,
    required super.phoneNumber,
    required super.password,
    required this.jerseyNumber,
    required this.age,
    required this.typeOfPlayer,
    required this.ratings,
    required this.matchesPlayed,
    required this.wonMatches,
    required this.matches,
  });
}

class Team {
  String teamName;
  String logo;
  String address;
  int numberOfChampionships;
  int numberOfPlayers;
  List<Player> players;
  List<Match> matches;

  Team({
    required this.teamName,
    required this.logo,
    required this.address,
    required this.numberOfChampionships,
    required this.numberOfPlayers,
    required this.players,
    required this.matches,
  });
}


