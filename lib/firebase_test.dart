// ignore_for_file: prefer_const_constructors_in_immutables,unnecessary_const,library_private_types_in_public_api,avoid_print
// Copyright 2021, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: defaultFirebaseOptions);
  runApp(FirestoreExampleApp());
}

/// A reference to the list of movies.
/// We are using `withConverter` to ensure that interactions with the collection
/// are type-safe.
final gamesRef =
    FirebaseFirestore.instance.collection('Game').withConverter<Game>(
          fromFirestore: (snapshots, _) => Game.fromJson(snapshots.data()!),
          toFirestore: (movie, _) => movie.toJson(),
        );

/// The different ways that we can filter/sort movies.
enum GameQuery {
  ord,
  name,
}

extension on Query<Game> {
  /// Create a firebase query from a [GameQuery]
  Query<Game> queryBy(GameQuery query) {
    switch (query) {
      case GameQuery.ord:
        return orderBy('ord', descending: true);

      case GameQuery.name:
        return where('name', arrayContainsAny: ['니케']);
    }
  }
}

/// The entry point of the application.
///
/// Returns a [MaterialApp].
class FirestoreExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firestore Example App',
      theme: ThemeData.dark(),
      home: const Scaffold(
        body: Center(child: FilmList()),
      ),
    );
  }
}

/// Holds all example app films
class FilmList extends StatefulWidget {
  const FilmList({Key? key}) : super(key: key);

  @override
  _FilmListState createState() => _FilmListState();
}

class _FilmListState extends State<FilmList> {
  GameQuery query = GameQuery.ord;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Firestore Example: Games'),

            // This is a example use for 'snapshots in sync'.
            // The view reflects the time of the last Firestore sync; which happens any time a field is updated.
            StreamBuilder(
              stream: FirebaseFirestore.instance.snapshotsInSync(),
              builder: (context, _) {
                return Text(
                  'Latest Snapshot: ${DateTime.now()}',
                  style: Theme.of(context).textTheme.bodySmall,
                );
              },
            )
          ],
        ),
        actions: <Widget>[
          PopupMenuButton<GameQuery>(
            onSelected: (value) => setState(() => query = value),
            icon: const Icon(Icons.sort),
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: GameQuery.ord,
                  child: Text('Sort by Ord'),
                ),
                const PopupMenuItem(
                  value: GameQuery.name,
                  child: Text('Sort by Name'),
                ),
              ];
            },
          ),
          PopupMenuButton<String>(
            onSelected: (_) => _resetLikes(),
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'reset_likes',
                  child: Text('Reset like counts (WriteBatch)'),
                ),
              ];
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Game>>(
        stream: gamesRef.queryBy(query).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.requireData;

          return ListView.builder(
            itemCount: data.size,
            itemBuilder: (context, index) {
              return _GameItem(
                data.docs[index].data(),
                data.docs[index].reference,
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _resetLikes() async {
    final games = await gamesRef.get();
    print(games.toString());
    WriteBatch batch = FirebaseFirestore.instance.batch();

    for (final movie in games.docs) {
      batch.update(movie.reference, {'likes': 0});
    }
    await batch.commit();
  }
}

/// A single movie row.
class _GameItem extends StatelessWidget {
  _GameItem(this.game, this.reference);

  final Game game;
  final DocumentReference<Game> reference;

  /// Returns the movie poster.
  Widget get poster {
    return SizedBox(
      width: 100,
      child: Image.network(game.name),
    );
  }

  /// Returns movie details.
  Widget get details {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          name,
          metadata,
          // genres,
        ],
      ),
    );
  }

  /// Return the movie title.
  Widget get name {
    return Text(
      '${game.name} (${game.ord})',
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  /// Returns metadata about the movie.
  Widget get metadata {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Text('Rated: ${game.communityList}'),
          ),
          // Text('Runtime: ${game.runtime}'),
        ],
      ),
    );
  }

  /// Returns a list of genre movie tags.
  // List<Widget> get genreItems {
  //   return [
  //     for (final name in game.name)
  //       Padding(
  //         padding: const EdgeInsets.only(right: 2),
  //         child: Chip(
  //           backgroundColor: Colors.lightBlue,
  //           label: Text(
  //             genre,
  //             style: const TextStyle(color: Colors.white),
  //           ),
  //         ),
  //       )
  //   ];
  // }

  /// Returns all genres.
  // Widget get genres {
  //   return Padding(
  //     padding: const EdgeInsets.only(top: 8),
  //     child: Wrap(
  //       children: genreItems,
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4, top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          poster,
          Flexible(child: details),
        ],
      ),
    );
  }
}

/// Displays and manages the movie 'like' count.
// class Likes extends StatefulWidget {
//   /// Constructs a new [Likes] instance with a given [DocumentReference] and
//   /// current like count.
//   Likes({
//     Key? key,
//     required this.reference,
//     required this.currentLikes,
//   }) : super(key: key);

//   /// The reference relating to the counter.
//   final DocumentReference<Game> reference;

//   /// The number of current likes (before manipulation).
//   final int currentLikes;

//   @override
//   _LikesState createState() => _LikesState();
// }

// class _LikesState extends State<Likes> {
//   /// A local cache of the current likes, used to immediately render the updated
//   /// likes count after an update, even while the request isn't completed yet.
//   late int _likes = widget.currentLikes;

//   Future<void> _onLike() async {
//     final currentLikes = _likes;

//     // Increment the 'like' count straight away to show feedback to the user.
//     setState(() {
//       _likes = currentLikes + 1;
//     });

//     try {
//       // Update the likes using a transaction.
//       // We use a transaction because multiple users could update the likes count
//       // simultaneously. As such, our likes count may be different from the likes
//       // count on the server.
//       int newLikes = await FirebaseFirestore.instance
//           .runTransaction<int>((transaction) async {
//         DocumentSnapshot<Game> movie =
//             await transaction.get<Game>(widget.reference);

//         if (!movie.exists) {
//           throw Exception('Document does not exist!');
//         }

//         int updatedLikes = movie.data()!.likes + 1;
//         transaction.update(widget.reference, {'likes': updatedLikes});
//         return updatedLikes;
//       });

//       // Update with the real count once the transaction has completed.
//       setState(() => _likes = newLikes);
//     } catch (e, s) {
//       print(s);
//       print('Failed to update likes for document! $e');

//       // If the transaction fails, revert back to the old count
//       setState(() => _likes = currentLikes);
//     }
//   }

//   @override
//   void didUpdateWidget(Likes oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     // The likes on the server changed, so we need to update our local cache to
//     // keep things in sync. Otherwise if another user updates the likes,
//     // we won't see the update.
//     if (widget.currentLikes != oldWidget.currentLikes) {
//       _likes = widget.currentLikes;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         IconButton(
//           iconSize: 20,
//           onPressed: _onLike,
//           icon: const Icon(Icons.favorite),
//         ),
//         Text('$_likes likes'),
//       ],
//     );
//   }
// }

@immutable
class Game {
  Game({
    required this.ord,
    required this.name,
    required this.description,
    required this.communityList,
  });

  Game.fromJson(Map<String, Object?> json)
      : this(
          ord: json['ord']! as int,
          name: json['name']! as String,
          description: json['description']! as String,
          communityList: json['communityList']! as Map,
        );

  final int ord;
  final String name;
  final String description;
  final Map communityList;

  Map<String, Object?> toJson() {
    return {
      'ord': ord,
      'name': name,
      'description': description,
      'communityList': communityList,
    };
  }
}

const defaultFirebaseOptions = const FirebaseOptions(
  apiKey: 'AIzaSyB7wZb2tO1-Fs6GbDADUSTs2Qs3w08Hovw',
  appId: '1:406099696497:web:87e25e51afe982cd3574d0',
  messagingSenderId: '406099696497',
  projectId: 'flutterfire-e2e-tests',
  authDomain: 'flutterfire-e2e-tests.firebaseapp.com',
  databaseURL:
      'https://flutterfire-e2e-tests-default-rtdb.europe-west1.firebasedatabase.app',
  storageBucket: 'flutterfire-e2e-tests.appspot.com',
  measurementId: 'G-JN95N1JV2E',
);
