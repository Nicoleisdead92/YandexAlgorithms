#include <iostream>
#include <vector>

using namespace std;
bool leap_year (int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
}


int main() {
    vector <pair<string,int>> months = {
            {"January", 31},
            {"February", 28},
            {"March", 31},
            {"April", 30},
            {"May", 31},
            {"June", 30},
            {"July", 31},
            {"August", 31},
            {"September", 30},
            {"October", 31},
            {"November", 30},
            {"December", 31}
    };

    std::vector<pair<std::string,int>> week_days = {
            {"Monday",52},
            {"Tuesday",52},
            {"Wednesday",52},
            {"Thursday",52},
            {"Friday",52},
            {"Saturday",52},
            {"Sunday",52}
    };
    int n, year;
    int days_in_year = 365;
    cin >> n >> year;
    if (leap_year(year)) {
        ++months[1].second;
        ++days_in_year;
    }
    int day;
    string month;
    vector <pair<string,int>> holidays;
    for (int i = 0; i < n; ++i) {
        cin >> day >> month;
        holidays.emplace_back(month,day);
    }
    string year_start;
    cin >> year_start;

    int start_index = 0;
    for (int i = 0; i < week_days.size(); ++i) {
        if (week_days[i].first == year_start) {
            start_index = i;
            break;
        }
    }

    if (leap_year(year)) {
        ++week_days[start_index].second;
        if (start_index + 1 == 7 ) {
            ++week_days[0].second;
        } else {
            ++week_days[start_index + 1].second;
        }

    } else {
        ++week_days[start_index].second;
    }


    for (const auto& e:holidays) {
        int days = 0;
        for (int i = 0; i < months.size(); ++i) {
            if (months[i].first == e.first) {
                days += e.second;
                break;
            } else {
                days += months[i].second;
            }
        }
        if (days%7 && days > 7) {
            int index = days%7 - 1 + start_index;
            if (index >= 7) {
                index -= 7;
            }
            --week_days[index].second;
        } else {
            int index = (days+start_index)%7 - 1;
            if (index < 0) {
                index = 6;
            }
            --week_days[index].second;
        }

    }

    string good;
    string bad;

    int max = -1;
    int min = 53;
    for (auto & week_day : week_days) {
        if (week_day.second > max) {
            max = week_day.second;
            good = week_day.first;
        }
        if (week_day.second < min) {
            min = week_day.second;
            bad = week_day.first;
        }
    }

    cout << good << " " << bad;
    return 0;
}
