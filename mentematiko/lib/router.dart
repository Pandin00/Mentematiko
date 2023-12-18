// Copyright 2023, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:card/main_menu/login.dart';
import 'package:card/main_menu/register.dart';
import 'package:card/models/user.dart';
import 'package:card/services/login_register_service.dart';
import 'package:card/user_pages/new_table.dart';
import 'package:card/user_pages/new_tournament.dart';
import 'package:card/user_pages/tournament_view.dart';
import 'package:card/user_pages/user_menu.dart';
import 'package:card/user_pages/users_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'game_internals/score.dart';
import 'main_menu/main_menu_screen.dart';
import 'play_session/play_session_screen.dart';
import 'settings/settings_screen.dart';
import 'style/my_transition.dart';
import 'style/palette.dart';
import 'win_game/win_game_screen.dart';

/// The router describes the game's navigational hierarchy, from the main
/// screen through settings screens all the way to each individual level.
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainMenuScreen(key: Key('main menu')),
      routes: [
        GoRoute(
            path: 'login',
            pageBuilder: (context, state) => buildMyTransition<void>(
                  key: ValueKey('login'),
                  color: context.watch<Palette>().backgroundPlaySession,
                  child: LoginPage(
                    key: Key('login'),
                    loginService: context.read<LoginService>(),
                  ),
                )),
        GoRoute(
            path: 'register',
            pageBuilder: (context, state) => buildMyTransition<void>(
                  key: ValueKey('register'),
                  color: context.watch<Palette>().backgroundPlaySession,
                  child: RegisterPage(key: Key('registration')),
                )),
        GoRoute(
            path: 'userMenu',
            pageBuilder: (context, state) {
              UserMenu menu =
                  UserMenu(key: Key('userMenu'), user: state.extra as User);
              return buildMyTransition(
                  child: menu,
                  color: context.watch<Palette>().backgroundPlaySession,
                  key: ValueKey('userMenu'));
            },
            routes: [
              GoRoute(
                  path: 'newTournament',
                  pageBuilder: (context, state) => buildMyTransition<void>(
                        key: ValueKey('login'),
                        color: context.watch<Palette>().backgroundPlaySession,
                        child: NewTournamentPage(),
                      )),
              GoRoute(
                  path: 'newTable',
                  pageBuilder: (context, state) => buildMyTransition<void>(
                        key: ValueKey('newTable'),
                        color: context.watch<Palette>().backgroundPlaySession,
                        child: CreateNewTablePage(),
                      )),
              GoRoute(
                  path: 'tournamentsView',
                  pageBuilder: (context, state) => buildMyTransition<void>(
                        key: ValueKey('tournamentsView'),
                        color: context.watch<Palette>().backgroundPlaySession,
                        child: TournamentsView(),
                      )),
              GoRoute(
                  path: 'usersView',
                  pageBuilder: (context, state) => buildMyTransition<void>(
                        key: ValueKey('usersView'),
                        color: context.watch<Palette>().backgroundPlaySession,
                        child: UsersPage(),
                      )),
              GoRoute(
                path: 'play',
                pageBuilder: (context, state) => buildMyTransition<void>(
                  key: ValueKey('play'),
                  color: context.watch<Palette>().backgroundPlaySession,
                  child: const PlaySessionScreen(
                    key: Key('level selection'),
                  ),
                ),
                routes: [
                  GoRoute(
                    path: 'won',
                    redirect: (context, state) {
                      if (state.extra == null) {
                        // Trying to navigate to a win screen without any data.
                        // Possibly by using the browser's back button.
                        return '/';
                      }
                      // Otherwise, do not redirect.
                      return null;
                    },
                    pageBuilder: (context, state) {
                      final map = state.extra! as Map<String, dynamic>;
                      final score = map['score'] as Score;

                      return buildMyTransition<void>(
                        key: ValueKey('won'),
                        color: context.watch<Palette>().backgroundPlaySession,
                        child: WinGameScreen(
                          score: score,
                          key: const Key('win game'),
                        ),
                      );
                    },
                  )
                ],
              ),
            ]
          ),
        GoRoute(
          path: 'settings',
          builder: (context, state) =>
              const SettingsScreen(key: Key('settings')),
        ),
      ],
    ),
  ],
);
