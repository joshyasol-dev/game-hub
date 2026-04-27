class GameData {
  final List<Game> games;
  final List<FeaturedGame> featuredGames;
  final List<Game> newGames;

  GameData({
    required this.games,
    required this.featuredGames,
    required this.newGames,
  });

  factory GameData.fromJson(Map<String, dynamic> json) {
    return GameData(
      games: (json['games'] as List)
          .map((e) => Game.fromJson(e))
          .toList(),
      featuredGames: (json['featured_games'] as List)
          .map((e) => FeaturedGame.fromJson(e))
          .toList(),
      newGames: (json['new_games'] as List)
          .map((e) => Game.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'games': games.map((e) => e.toJson()).toList(),
      'featured_games': featuredGames.map((e) => e.toJson()).toList(),
      'new_games': newGames.map((e) => e.toJson()).toList(),
    };
  }
}
      

class Game {
  final int id;
  final int gameId;
  final String slug;
  final String name;
  final String description;
  final String imageUrl;
  final String gameUrl;
  final DateTime createdAt;

  Game({
    required this.id,
    required this.gameId,
    required this.slug,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.gameUrl,
    required this.createdAt,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'],
      gameId: json['game_id'],
      slug: json['slug'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['image_url'],
      gameUrl: json['game_url'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'game_id': gameId,
      'slug': slug,
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'game_url': gameUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class FeaturedGame extends Game {
  final int totalPlayers;

  FeaturedGame({
    required super.id,
    required this.totalPlayers,
    required super.gameId,
    required super.slug,
    required super.name,
    required super.description,
    required super.imageUrl,
    required super.gameUrl,
    required super.createdAt,
  });

  factory FeaturedGame.fromJson(Map<String, dynamic> json) {
    return FeaturedGame(
      id: json['id'],
      totalPlayers: json['total_players'],
      gameId: json['game_id'],
      slug: json['slug'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['image_url'],
      gameUrl: json['game_url'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  @override
  Map<String,dynamic> toJson() =>{
    ...super.toJson(),
    'total_players': totalPlayers,
  };
}








// List<GameModel> sampleGames = [
//   GameModel(
//     id: 14,
//     gameid: "13",
//     name: "Smash it Joe",
//     description: "army smasher game",
//     gameurl:
//         "/uploads/games/1776924428950-fdacbbcc-8548-4e2f-829c-3f468d793086.jpg",
//     createdate: "2026-04-23T06:00:38.000Z",
//   ),
//   GameModel(
//     id: 12,
//     gameid: "11",
//     name: "Chicken Nuketz",
//     description: "Shoot Dead Break",
//     gameurl:
//         "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRJqejMAqk8A370P1abenkH2CL0mAiH53B5Rw&s",
//     createdate: "2026-04-16T06:42:16.000Z",
//   ),
//   GameModel(
//     id: 10,
//     gameid: "9",
//     name: "Chicken Ninja Live",
//     description: "Chicken Ninja Wars",
//     gameurl:
//         "https://thumbs.dreamstime.com/b/cartoon-ninja-chicken-sword-vector-clip-art-illustration-simple-gradients-all-single-layer-109872296.jpg",
//     createdate: "2026-04-16T04:24:45.000Z",
//   ),
//   GameModel(
//     id: 8,
//     gameid: "8",
//     name: "Mario Bro Live",
//     description: "Brotherhood action Live",
//     gameurl:
//         "https://static.wikia.nocookie.net/mariokart/images/f/fc/Mario_in_Mario_Kart_World.png/revision/latest/thumbnail/width/360/height/450?cb=20250403191846",
//     createdate: "2026-04-16T03:05:19.000Z",
//   ),
//   GameModel(
//     id: 7,
//     gameid: "7",
//     name: "Bingo Boss Live",
//     description: "Bingo Live Bonanza",
//     gameurl:
//         "https://media.istockphoto.com/id/1205079090/vector/bingo-neon-sign-with-lottery-balls-and-stars.jpg?s=612x612&w=0&k=20&c=O9Q2YjvIARZL7nvDKVFDP_Zm2Pcnj8ZaMkGjailuG8A=",
//     createdate: "2026-04-13T07:06:06.000Z",
//   ),
//   GameModel(
//     id: 6,
//     gameid: "6",
//     name: "Mytic Tree Live",
//     description: "Defend and grow and nourished it",
//     gameurl: "https://i.scdn.co/image/ab67616d0000b273de2413389247e7d5b20954a0",
//     createdate: "2026-04-11T02:48:27.000Z",
//   ),
//   GameModel(
//     id: 5,
//     gameid: "5",
//     name: "PowerHammer",
//     description: "sukatan ng lakas gamit ang hammer",
//     gameurl:
//         "https://store.crunchyroll.com/on/demandware.static/-/Sites-crunchyroll-master-catalog/default/dw9279e9b5/rightstuf/4981932518060_figure-power-hammer-ver-chainsaw-man-alti.jpg",
//     createdate: "2026-04-10T03:13:57.000Z",
//   ),
//   GameModel(
//     id: 4,
//     gameid: "4",
//     name: "ShaboXing",
//     description: "Boxing boxingan ng mga  manoks",
//     gameurl:
//         "https://t3.ftcdn.net/jpg/15/97/31/36/240_F_1597313652_Qbf3PZaymphVRv56Pg3UXlZkAwY12ljj.jpg",
//     createdate: "2026-04-06T09:19:30.000Z",
//   ),
//   GameModel(
//     id: 1,
//     gameid: "1",
//     name: "Shabong Frenzy",
//     description: "Manok manokan daw kuno kuno",
//     gameurl:
//         "https://t4.ftcdn.net/jpg/07/68/11/93/240_F_768119371_8UAHPq8o2laeHuh7qUZRFu4qHUOmauDF.jpg",
//     createdate: "2026-04-06T08:49:37.000Z",
//   ),
// ];
