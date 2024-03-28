#include <iostream>
#include <fstream>
#include <vector>
#include <unordered_map>
#include <iomanip>
#include <string>
using namespace std;

struct Player;
struct Goal;
struct Team;
struct Game;

struct Player {
    string player_name;
    Team* player_team{};
    vector <Goal*> player_goals;
    int player_total_goals = 0;
    int player_open = 0;

    explicit Player(string name):player_name(std::move(name)) {}
};

struct Goal {
    Player* player;
    Team* team;
    int time;

    Goal(Player* p,Team* t,int tm):
    player(p),
    team(t),
    time(tm)
    {}
};

struct Team {
    string team_name;
    int total_goals = 0;
    int total_games = 0;
    int team_open = 0;

    explicit Team(string name):team_name(std::move(name)){}
};

struct Game {
    Team* team1{};
    int team1_counter = 0;
    Team* team2{};
    int team2_counter = 0;
    vector <Goal*> game_goals;
};

void create_game(Game& g,unordered_map <string,Team*>& map_teams,const string& str) {
    int i = 0;
    string tmp;
    ++i;
    while (str[i] != '"') {
        tmp += str[i];
        ++i;
    }
    if (map_teams[tmp] == nullptr) {
        map_teams[tmp] = new Team(tmp);
        g.team1 = map_teams[tmp];
        ++map_teams[tmp]->total_games;
    } else {
        g.team1 = map_teams[tmp];
        ++map_teams[tmp]->total_games;
    }
    tmp.clear();
    i += 5;
    while (str[i] != '"') {
        tmp += str[i];
        ++i;
    }
    if (map_teams[tmp] == nullptr) {
        map_teams[tmp] = new Team(tmp);
        g.team2 = map_teams[tmp];
        ++map_teams[tmp]->total_games;
    } else {
        g.team2 = map_teams[tmp];
        ++map_teams[tmp]->total_games;
    }
    i += 2;
    tmp.clear();
    while (str[i] != ':') {
        tmp += str[i];
        ++i;
    }
    int goal_team = stoi(tmp);
    ++i;
    map_teams[g.team1->team_name]->total_goals += goal_team;
    g.team1_counter = goal_team;
    tmp.clear();
    for (; i < str.size(); ++i) {
        tmp += str[i];
    }
    goal_team = stoi(tmp);
    map_teams[g.team2->team_name]->total_goals += goal_team;
    g.team2_counter = goal_team;
}

void create_goal(Game& g,Team* team,unordered_map <string,Player*>& map_players,const string& str) {
    string player;
    int i = 0;
    while (str[i] != ' ') {
        player += str[i];
        ++i;
    }
    while (str[i+1] < 48 || str[i+1] > 57) {
        player += str[i++];
        while (str[i] != ' ') {
            player += str[i];
            ++i;
        }
    }
    if (map_players[player] == nullptr) {
        map_players[player] = new Player(player);
        map_players[player]->player_team = team;
        ++map_players[player]->player_total_goals;
    } else {
        if ( map_players[player]->player_team == nullptr) {
            map_players[player]->player_team = team;
        }
        ++map_players[player]->player_total_goals;
    }
    ++i;
    string s;
    s = str[i++];
    s += str[i];
    int time = stoi(s);
    Goal* goal = new Goal(map_players[player],team,time);
    map_players[player]->player_goals.push_back(goal);
    g.game_goals.push_back(goal);
}

void open_goals(Game& g) {
    Goal first(nullptr, nullptr,91);
    for (const auto& goal : g.game_goals) {
        if (goal->time < first.time) {
            first.time = goal->time;
            first.player = goal->player;
            first.team = goal->team;
        }
    }
    if (first.player) {
        ++first.player->player_open;
        ++first.team->team_open;
    }
}

void total_goals_for_team(const string& str,unordered_map <string,Team*>& map_teams) {
    string team;
    int i = 17;
    while (str[i] != '"') {
        team += str[i];
        ++i;
    }
    if (map_teams[team] == nullptr) {
        map_teams[team] = new Team(team);
    }
    cout << map_teams[team]->total_goals << endl;
}

void total_goals_by_player(const string& str,unordered_map <string,Player*>& map_players) {
    string player;
    for (int i = 15; i < str.size(); ++i) {
        player += str[i];
    }
    if (map_players[player] == nullptr) {
        map_players[player] = new Player(player);
    }
    cout << map_players[player]->player_total_goals << endl;

}

void mean_goals_per_game_for_team(const string& str,unordered_map <string,Team*>& map_teams) {
    string team;
    int i = 25;
    while (str[i] != '"') {
        team += str[i];
        ++i;
    }
    float mean_goals = (float)map_teams[team]->total_goals / (float)map_teams[team]->total_games;
    cout << mean_goals << endl;
}

void mean_goals_per_game_by_player(const string& str,unordered_map <string,Player*>& map_players) {
    string player;
    for (int i = 23; i < str.size(); ++i) {
        player += str[i];
    }
    float ttp = (float)map_players[player]->player_total_goals;
    float ttg = (float)map_players[player]->player_team->total_games;

    float mean_goals = ttp / ttg;
    cout << mean_goals << endl;
}

void goals_on_minute(const string& str,unordered_map <string,Player*>& map_players) {
    string player;
    string minute;
    int i = 16;
    while (str[i] != ' ') {
        minute += str[i];
        ++i;
    }
    int minute_int = stoi(minute);
    i += 4;
    for (; i < str.size(); ++i) {
        player += str[i];
    }
    if (map_players[player] == nullptr) {
        map_players[player] = new Player(player);
    }
    auto& vec = map_players[player]->player_goals;
    int result = 0;
    for (auto j : vec) {
        if (j->time == minute_int) {
            ++result;
        }
    }
    cout << result << endl;
}

void goals_on_first(const string& str,unordered_map <string,Player*>& map_players) {
    string player;
    string minute;
    int i = 15;
    while (str[i] != ' ') {
        minute += str[i];
        ++i;
    }
    int minute_int = stoi(minute);
    i += 12;
    for (; i < str.size(); ++i) {
        player += str[i];
    }
    if (map_players[player] == nullptr) {
        map_players[player] = new Player(player);
    }
    auto& vec = map_players[player]->player_goals;
    int result = 0;
    for (auto & j : vec) {
        if (j->time <= minute_int) {
            ++result;
        }
    }
    cout << result << endl;
}

void goals_on_last(const string& str,unordered_map <string,Player*>& map_players) {
    string player;
    string minute;
    int i = 14;
    while (str[i] != ' ') {
        minute += str[i];
        ++i;
    }
    int minute_int = stoi(minute);
    i += 12;
    for (; i < str.size(); ++i) {
        player += str[i];
    }
    if (map_players[player] == nullptr) {
        map_players[player] = new Player(player);
    }
    auto& vec = map_players[player]->player_goals;
    int result = 0;
    for (auto & j : vec) {
        if (j->time >= 91 - minute_int) {
            ++result;
        }
    }
    cout << result << endl;
}

void score_opens_by_team(const string& str,unordered_map <string,Team*>& map_teams) {
    string team;
    int i = 16;
    while (str[i] != '"') {
        team += str[i];
        ++i;
    }if (map_teams[team] == nullptr) {
        map_teams[team] = new Team(team);
    }
    cout << map_teams[team]->team_open << endl;
}

void score_opens_by_player(const string& str,unordered_map <string,Player*>& map_players) {
    string player;
    for (int i = 15; i < str.size(); ++i) {
        player += str[i];
    }
    if (map_players[player] == nullptr) {
        map_players[player] = new Player(player);
    }
    cout << map_players[player]->player_open << endl;
}

void solution() {
    ifstream file("input.txt");
    string str;
    unordered_map <string,Team*> map_teams;
    unordered_map <string,Player*> map_players;
    while(getline(file,str)) {
        if (str[0] == '"') {
            Game g;
            create_game(g, map_teams, str);
            for (int i = 0; i < g.team1_counter; ++i) {
                getline(file,str); // Check str
                create_goal(g, g.team1, map_players, str);
            }
            for (int i = 0; i < g.team2_counter; ++i) {
                getline(file,str);
                create_goal(g, g.team2, map_players, str);
            }
            open_goals(g);
        } else {
            if (str[0] == 'T') {
                if (str[12] == 'f') {
                    total_goals_for_team(str, map_teams);
                }
                if (str[12] == 'b') {
                    total_goals_by_player(str,map_players);
                }
            }
            if (str[0] == 'M') {
                if (str[20] == 'f') {
                    mean_goals_per_game_for_team(str,map_teams);
                }
                if (str[20] == 'b') {
                    mean_goals_per_game_by_player(str,map_players);
                }
            }
            if (str[0] == 'G') {
                if (str[9] == 'm') {
                    goals_on_minute(str,map_players);
                }
                if (str[9] == 'f') {
                    goals_on_first(str,map_players);
                }
                if (str[9] == 'l') {
                    goals_on_last(str,map_players);
                }
            }
            if (str[0] == 'S') {
                if (str[15] == '"') {
                    score_opens_by_team(str,map_teams);
                } else {
                    score_opens_by_player(str,map_players);
                }
            }
        }

    }
    file.close();
    for (auto& i:map_teams) {
        delete i.second;
    }
    for (auto& i:map_players) {
        for (auto& j :i.second->player_goals) {
            delete j;
        }
        delete i.second;
    }
}

int main() {
    solution();
    return 0;
}
